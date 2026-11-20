package com.karimkmorsi.expat_manager

import android.app.Activity
import android.content.Intent
import android.view.WindowManager
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors

internal class BackupDocuments(private val activity: Activity) {
    private data class Pending(val result: MethodChannel.Result, val export: ByteArray?)

    private val worker = Executors.newSingleThreadExecutor()
    private var pending: Pending? = null

    fun handle(call: io.flutter.plugin.common.MethodCall, result: MethodChannel.Result) {
        if (call.method == "protectPassword") {
            val flag = WindowManager.LayoutParams.FLAG_SECURE
            if (call.arguments == true) activity.window.addFlags(flag)
            else activity.window.clearFlags(flag)
            result.success(null)
            return
        }
        val bytes = when (call.method) {
            "import" -> null
            "export" -> call.arguments as? ByteArray
                ?: return result.error("BACKUP_FILE", "Invalid export", null)
            else -> return result.notImplemented()
        }
        if (pending != null || (bytes != null && bytes.size > maxBytes)) {
            return result.error("BACKUP_FILE", "Backup file unavailable", null)
        }
        val intent = Intent(
            if (bytes == null) Intent.ACTION_OPEN_DOCUMENT else Intent.ACTION_CREATE_DOCUMENT
        ).addCategory(Intent.CATEGORY_OPENABLE).apply {
            type = if (bytes == null) "*/*" else "application/octet-stream"
            putExtra(Intent.EXTRA_LOCAL_ONLY, true)
            if (bytes != null) putExtra(Intent.EXTRA_TITLE, "Expat-Manager.expbackup")
        }
        pending = Pending(result, bytes)
        try {
            activity.startActivityForResult(intent, request)
        } catch (_: Exception) {
            pending = null
            result.error("BACKUP_FILE", "No document provider", null)
        }
    }

    fun onActivityResult(code: Int, status: Int, data: Intent?): Boolean {
        if (code != request) return false
        val operation = pending ?: return true
        val uri = data?.data
        if (status != Activity.RESULT_OK || uri == null) {
            pending = null
            operation.result.success(null)
            return true
        }
        worker.execute {
            val resolver = activity.contentResolver
            try {
                val value = if (operation.export == null) {
                    val input = checkNotNull(resolver.openInputStream(uri))
                    input.use { source ->
                        val output = ByteArrayOutputStream()
                        val buffer = ByteArray(32 * 1024)
                        while (true) {
                            val count = source.read(buffer)
                            if (count < 0) break
                            if (count > maxBytes - output.size()) throw TooLarge()
                            output.write(buffer, 0, count)
                        }
                        output.toByteArray()
                    }
                } else {
                    checkNotNull(resolver.openOutputStream(uri, "wt")).use { output ->
                        output.write(operation.export)
                        output.flush()
                    }
                    true
                }
                activity.runOnUiThread {
                    pending = null
                    operation.result.success(value)
                }
            } catch (error: Exception) {
                activity.runOnUiThread {
                    pending = null
                    val code = if (error is TooLarge) "BACKUP_TOO_LARGE" else "BACKUP_FILE"
                    operation.result.error(code, "Backup file unavailable", null)
                }
            }
        }
        return true
    }

    fun close() {
        worker.shutdown()
    }

    private class TooLarge : Exception()

    private companion object {
        const val request = 0x4558
        const val maxBytes = 16 * 1024 * 1024
    }
}
