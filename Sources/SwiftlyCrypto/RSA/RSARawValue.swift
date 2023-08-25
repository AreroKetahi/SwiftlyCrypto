//
//  RSARawValue.swift
//
//
//  Created by Akivili Collindort on 2023/8/24.
//

import Foundation
import SwCrypt

/// RSA Raw Value
struct RSARawValue {
    private var data: Data
}

// Initializers
extension RSARawValue {
    /// Create raw value from `Data` type
    /// - Parameter data: Raw data
    public init(_ data: Data) {
        self.data = data
    }
    
    /// Create raw value from a specific string
    /// - Parameter string: Raw string
    public init(_ string: String) {
        self.data = string.data(using: .utf8)!
    }
}

// Values
extension RSARawValue {
    internal var rawValue: Data {
        data
    }
    
    /// Export string from `RSARawValue`
    public var toString: String? {
        String(data: rawValue, encoding: .utf8)
    }
    
    /// Export data from `RSARawValue`
    public var toData: Data {
        rawValue
    }
}

// Functions
extension RSARawValue {
    /// Encrypt
    /// - Parameters:
    ///   - publicKey: RSA Public Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    /// - Returns: Encrypted value
    public func encrypt(
        publicKey: RSAPublicKey,
        padding: CC.RSA.AsymmetricPadding = .pkcs1,
        digest: CC.DigestAlgorithm = .sha256
    ) throws -> RSAEncryptedValue {
        try RSA.encrypt(data: self, publicKey: publicKey, padding: padding, digest: digest)
    }
    
    /// Sign
    /// - Parameters:
    ///   - privateKey: Private key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    ///   - saltLength: Salt Length
    /// - Returns: Signed Message
    public func sign(
        privateKey: RSAPrivateKey,
        padding: CC.RSA.AsymmetricSAPadding = .pss,
        digest: CC.DigestAlgorithm = .sha256,
        saltLength: Int = 16
    ) throws -> RSASignature {
        try RSA.sign(message: self, privateKey: privateKey, padding: padding, digest: digest, saltLength: saltLength)
    }
    
    /// Verify
    /// - Parameters:
    ///   - signature: Signed message
    ///   - publicKey: Public Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    ///   - saltLength: Salt Length
    /// - Returns: Verify result. `true` for succes, `false` for false
    public func verify(
        signature: RSASignature,
        publicKey: RSAPublicKey,
        padding: CC.RSA.AsymmetricSAPadding = .pss,
        digest: CC.DigestAlgorithm = .sha256,
        saltLength: Int = 16
    ) throws -> Bool {
        try RSA.verify(message: self, signature: signature, publicKey: publicKey, padding: padding, digest: digest, saltLength: saltLength)
    }
}
