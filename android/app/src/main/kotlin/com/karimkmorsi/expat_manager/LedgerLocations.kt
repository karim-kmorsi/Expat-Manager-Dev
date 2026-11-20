package com.karimkmorsi.expat_manager

import android.util.AtomicFile
import java.io.File
import java.io.FileNotFoundException
import java.util.UUID

/** A recovered vault is keyed separately. The original files remain private and untouched. */
internal class LedgerLocations(private val root: File) {
    private val pointer = AtomicFile(File(root, "ledger-location.v1"))

    fun openActive(): Pair<String, ByteArray> {
        val active = try {
            pointer.readFully().toString(Charsets.UTF_8)
        } catch (error: FileNotFoundException) {
            check(!pointer.baseFile.exists())
            check(!File("${pointer.baseFile.path}.new").exists())
            check(!File("${pointer.baseFile.path}.bak").exists())
            return LedgerVault(root).open()
        }
        check(File(directory(active), "ledger.sqlite").isFile)
        return openRecovery(active)
    }

    fun createRecovery(): String {
        val id = UUID.randomUUID().toString().replace("-", "")
        check(directory(id).mkdir())
        return id
    }

    fun openRecovery(id: String): Pair<String, ByteArray> =
        LedgerVault(directory(id).also { check(it.isDirectory) }, "expat-manager.recovered.$id").open()

    fun activate(id: String) {
        check(File(directory(id), "ledger.sqlite").isFile)
        val stream = pointer.startWrite()
        try {
            stream.write(id.toByteArray(Charsets.UTF_8))
            pointer.finishWrite(stream)
        } catch (error: Exception) {
            pointer.failWrite(stream)
            throw error
        }
        check(pointer.readFully().toString(Charsets.UTF_8) == id)
    }

    private fun directory(id: String): File {
        require(id.matches(Regex("[0-9a-f]{32}")))
        return File(root, "ledger-recovered-$id")
    }
}
