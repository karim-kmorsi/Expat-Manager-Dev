package com.karimkmorsi.expat_manager

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(
            messenger, "com.karimkmorsi.expat_manager/storage",
            io.flutter.plugin.common.StandardMethodCodec.INSTANCE,
            messenger.makeBackgroundTaskQueue()
        ).setMethodCallHandler { call, result ->
            if (call.method != "openLedger") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            try {
                val (path, key) = LedgerVault(noBackupFilesDir).open()
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
