package com.karimkmorsi.expat_manager

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val backupDocuments by lazy { BackupDocuments(this) }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (!backupDocuments.onActivityResult(requestCode, resultCode, data)) {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }

    override fun onDestroy() {
        backupDocuments.close()
        super.onDestroy()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(messenger, "com.karimkmorsi.expat_manager/backup")
            .setMethodCallHandler(backupDocuments::handle)
        MethodChannel(messenger, "com.karimkmorsi.expat_manager/appearance")
            .setMethodCallHandler { call, result ->
                val prefs = getSharedPreferences("appearance", MODE_PRIVATE)
                when (call.method) {
                    "read" -> result.success(prefs.getString("theme", "system"))
                    "write" -> {
                        val value = call.arguments as? String
                        if (value in setOf("system", "light", "dark")) {
                            prefs.edit().putString("theme", value).apply()
                            result.success(null)
                        } else {
                            result.error("APPEARANCE", "Invalid theme", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        MethodChannel(
            messenger, "com.karimkmorsi.expat_manager/storage",
            io.flutter.plugin.common.StandardMethodCodec.INSTANCE,
            messenger.makeBackgroundTaskQueue()
        ).setMethodCallHandler { call, result ->
            try {
                val locations = LedgerLocations(noBackupFilesDir)
                val storage = when (call.method) {
                    "openLedger" -> locations.openActive()
                    "openRecoveryLedger" -> locations.openRecovery(call.arguments as String)
                    "recoveryDirectory" -> {
                        result.success(noBackupFilesDir.absolutePath)
                        return@setMethodCallHandler
                    }
                    "createRecoveryLedger" -> {
                        result.success(locations.createRecovery())
                        return@setMethodCallHandler
                    }
                    "activateRecoveryLedger" -> {
                        locations.activate(call.arguments as String)
                        result.success(null)
                        return@setMethodCallHandler
                    }
                    else -> {
                        result.notImplemented()
                        return@setMethodCallHandler
                    }
                }
                val (path, key) = storage
                try {
                    result.success(mapOf("path" to path, "key" to key))
                } finally {
                    key.fill(0)
                }
            } catch (_: Exception) {
                result.error("STORAGE_LOCKED", "Local encrypted storage is unavailable", null)
            }
        }
    }
}
