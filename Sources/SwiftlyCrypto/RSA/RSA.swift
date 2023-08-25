//
//  RSA.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/8/24.
//

import Foundation
import SwCrypt

/// RSA Asymmetric Encryption
/// Encapsulated from SwCrypt
final class RSA {
    /// Generate a key pair
    /// - Parameter keySize: Key size, default as `4096`
    /// - Returns: private key and public key (in order)
    static public func generateKeyPair(_ keySize: Int = 4096) throws -> (RSAPrivateKey, RSAPublicKey) {
        let (priKey, pubKey) = try CC.RSA.generateKeyPair(keySize)
        return (RSAPrivateKey(fromDER: priKey), RSAPublicKey(fromDER: pubKey))
    }
    
    /// Encrypt a `RSARawValue`
    /// - Parameters:
    ///   - data: `RSARawValue` that should encrypt
    ///   - publicKey: RSA Public Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    /// - Returns: Encrypted value
    static internal func encrypt(
        data: RSARawValue,
        publicKey: RSAPublicKey,
        padding: CC.RSA.AsymmetricPadding = .pkcs1,
        digest: CC.DigestAlgorithm = .sha256
    ) throws -> RSAEncryptedValue {
        let encrypted = try CC.RSA.encrypt(data.rawValue, derKey: publicKey.rawValue, tag: Data(), padding: padding, digest: digest)
        return RSAEncryptedValue(rawValue: encrypted)
    }
    
    /// Decrypt a `RSAEncryptedValue`
    /// - Parameters:
    ///   - data: `RSAEncryptedValue` that should decrypt
    ///   - privateKey: RSA Private Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    /// - Returns: Decrypted value
    static internal func decrypt(
        data: RSAEncryptedValue,
        privateKey: RSAPrivateKey,
        padding: CC.RSA.AsymmetricPadding = .pkcs1,
        digest: CC.DigestAlgorithm = .sha256
    ) throws -> RSARawValue {
        let decrypt = try CC.RSA.decrypt(data.rawValue, derKey: privateKey.rawValue, tag: Data(), padding: padding, digest: digest)
        return RSARawValue(decrypt.0)
    }
    
    /// Sign a message
    /// - Parameters:
    ///   - message: A `RSARawValue`, the message that you need to sign
    ///   - privateKey: Private key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    ///   - saltLength: Salt Length
    /// - Returns: Signed Message
    static internal func sign(
        message: RSARawValue,
        privateKey: RSAPrivateKey,
        padding: CC.RSA.AsymmetricSAPadding = .pss,
        digest: CC.DigestAlgorithm = .sha256,
        saltLength: Int = 16
    ) throws -> RSASignature {
        let signed = try CC.RSA.sign(message.rawValue, derKey: privateKey.rawValue, padding: padding, digest: digest, saltLen: saltLength)
        return RSASignature(rawValue: signed)
    }
    
    /// Verify a original message
    /// - Parameters:
    ///   - message: Original message that
    ///   - signature: Signed message
    ///   - publicKey: Public Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    ///   - saltLength: Salt Length
    /// - Returns: Verify result. `true` for succes, `false` for false
    static internal func verify(
        message: RSARawValue,
        signature: RSASignature,
        publicKey: RSAPublicKey,
        padding: CC.RSA.AsymmetricSAPadding = .pss,
        digest: CC.DigestAlgorithm = .sha256,
        saltLength: Int = 16
    ) throws -> Bool {
        return try CC.RSA.verify(message.rawValue, derKey: publicKey.rawValue, padding: padding, digest: digest, saltLen: saltLength, signedData: signature.rawValue)
    }
}
