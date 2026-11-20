package com.karimkmorsi.expat_manager

import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.AtomicFile
import java.io.File
import java.io.FileNotFoundException
import java.security.KeyStore
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

internal class LedgerVault(private val directory: File, private val keyAlias: String = defaultAlias) {
    private val aad = keyAlias.toByteArray(Charsets.UTF_8)
    private val database = File(directory, "ledger.sqlite")
    private val wrappedKey = AtomicFile(File(directory, "ledger-key.v1"))

    fun open(): Pair<String, ByteArray> = synchronized(lock) {
        val store = KeyStore.getInstance("AndroidKeyStore").also { it.load(null) }
        val envelope = try {
            wrappedKey.readFully()
        } catch (error: FileNotFoundException) {
            val artifacts = listOf(database, File("${database.path}-wal"),
                File("${database.path}-shm"), File("${database.path}-journal"))
            if (artifacts.any(File::exists) || wrappedKey.baseFile.exists() ||
                File("${wrappedKey.baseFile.path}.bak").exists() ||
                File("${wrappedKey.baseFile.path}.new").exists()) throw error
            null
        }
        val key = if (envelope == null) createKey(store) else unwrap(store, envelope)
        database.absolutePath to key
    }

    private fun createKey(store: KeyStore): ByteArray {
        val wrapper = store.getKey(keyAlias, null) as? SecretKey ?: KeyGenerator
            .getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
            .apply {
                init(KeyGenParameterSpec.Builder(
                    keyAlias, KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
                ).setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                    .setKeySize(256)
                    .build())
            }.generateKey()
        val key = ByteArray(keyLength).also { SecureRandom().nextBytes(it) }
        try {
            val cipher = Cipher.getInstance(transformation)
            cipher.init(Cipher.ENCRYPT_MODE, wrapper)
            check(cipher.iv.size == ivLength)
            cipher.updateAAD(aad)
            val envelope = cipher.iv + cipher.doFinal(key)
            val output = wrappedKey.startWrite()
            try {
                output.write(envelope)
                wrappedKey.finishWrite(output)
            } catch (error: Exception) {
                wrappedKey.failWrite(output)
                throw error
            }
            check(wrappedKey.readFully().contentEquals(envelope))
            return key
        } catch (error: Exception) {
            key.fill(0)
            throw error
        }
    }

    private fun unwrap(store: KeyStore, envelope: ByteArray): ByteArray {
        check(envelope.size == ivLength + keyLength + tagLength)
        val wrapper = store.getKey(keyAlias, null) as? SecretKey ?: error("Keystore key unavailable")
        val cipher = Cipher.getInstance(transformation)
        cipher.init(Cipher.DECRYPT_MODE, wrapper, GCMParameterSpec(128, envelope, 0, ivLength))
        cipher.updateAAD(aad)
        return cipher.doFinal(envelope, ivLength, envelope.size - ivLength)
    }

    private companion object {
        val lock = Any()
        const val defaultAlias = "expat-manager.ledger-key.v1"
        const val transformation = "AES/GCM/NoPadding"
        const val keyLength = 32
        const val ivLength = 12
        const val tagLength = 16
    }
}
