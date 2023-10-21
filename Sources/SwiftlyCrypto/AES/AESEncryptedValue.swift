//
//  AESEncryptedValue.swift
//
//
//  Created by Akivili Collindort on 2023/8/25.
//

import Foundation
import SwCrypt

/// Encrypted AES value
public struct AESEncryptedValue {
    private var data: Data
}

// Initializers
extension AESEncryptedValue {
    /// Initialize from raw data
    /// - Parameter data: Raw data
    public init(_ data: Data) {
        self.data = data
    }
    
    /// Initialize AES excrypted value from Base-64 encoded string
    /// - Parameters:
    ///   - base64Encoded: Base-64 encoded string
    ///   - options: The options to use for the decoding. Default value is `[]`.
    public init?(base64Encoded: String, options: Data.Base64DecodingOptions = []) {
        if let data = Data(base64Encoded: base64Encoded, options: options) {
            self.data = data
        } else {
            return nil
        }
    }
}

// Values
extension AESEncryptedValue {
    internal var rawValue: Data {
        data
    }
}

// Functions
extension AESEncryptedValue {
    /// Return a Base-64 Encoded AES encrypted value
    /// - Parameter options: The options to use for the encoding. Default value is [].
    /// - Returns: Base-64 encoded AES encrypted value
    public func base64EncodedString(options: Data.Base64EncodingOptions = []) -> String {
        rawValue.base64EncodedString(options: options)
    }
    
    /// Decrypt
    /// - Parameters:
    ///   - key: AES key
    ///   - iv: AES initialization vector
    ///   - blockMode: Block mode, `.cbc` for default
    ///   - padding: Padding, `.pkcs7Padding` for default
    /// - Returns: Raw AES value
    public func decrypt(
        key: AESKey,
        iv: AESIV,
        blockMode: CC.BlockMode = .cbc,
        padding: CC.Padding = .pkcs7Padding
    ) throws -> AESRawValue {
        try AES.decrypt(data: self, key: key, iv: iv, blockMode: blockMode, padding: padding)
    }
}
