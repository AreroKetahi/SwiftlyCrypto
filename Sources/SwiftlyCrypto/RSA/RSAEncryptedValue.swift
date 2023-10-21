//
//  RSAEncryptedValue.swift
//
//
//  Created by Akivili Collindort on 2023/8/24.
//

import Foundation
import SwCrypt

/// Encrypted RSA Raw Value
public struct RSAEncryptedValue {
    private var data: Data
}

// Initializers
extension RSAEncryptedValue {
    /// Generate `RSAEncryptedValue` from raw value
    /// - Parameter data: Raw value
    public init(rawValue data: Data) {
        self.data = data
    }
    
    /// Generate RSA excrypted value from Base-64 encoded string
    /// - Parameters:
    ///   - base64Encoded: Base-64 encoded string
    ///   - options: The options to use for the decoding. Default value is [].
    public init?(base64Encoded: String, options: Data.Base64DecodingOptions = []) {
        if let data = Data(base64Encoded: base64Encoded, options: options) {
            self.data = data
        } else {
            return nil
        }
    }
}

// Values
extension RSAEncryptedValue {
    /// Get raw value
    public var rawValue: Data {
        data
    }
}

// Functions
extension RSAEncryptedValue {
    /// Return a Base-64 Encoded RSA encrypted value
    /// - Parameter options: The options to use for the encoding. Default value is [].
    /// - Returns: Base-64 encoded RSA encrypted value
    public func base64EncodedString(options: Data.Base64EncodingOptions = []) -> String {
        rawValue.base64EncodedString(options: options)
    }
    
    /// Decrypt
    /// - Parameters:
    ///   - privateKey: RSA Private Key
    ///   - padding: Padding Method
    ///   - digest: Digest algorithm
    /// - Returns: Decrypted value
    public func decrypt(
        privateKey: RSAPrivateKey,
        padding: CC.RSA.AsymmetricPadding = .pkcs1,
        digest: CC.DigestAlgorithm = .sha256
    ) throws -> RSARawValue {
        try RSA.decrypt(data: self, privateKey: privateKey, padding: padding, digest: digest)
    }
}
