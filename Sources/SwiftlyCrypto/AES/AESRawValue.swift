//
//  AESRawValue.swift
//
//
//  Created by Akivili Collindort on 2023/8/25.
//

import Foundation
import SwCrypt

/// AES Raw Value
struct AESRawValue {
    private var data: Data
}

// Initializers
extension AESRawValue {
    /// Generate raw value from data
    /// - Parameter data: Raw data
    public init(_ data: Data) {
        self.data = data
    }
    
    /// Generate raw value from string
    /// - Parameter string: String
    public init(_ string: String) {
        self.data = string.data(using: .utf8)!
    }
}

// Values
extension AESRawValue {
    internal var rawValue: Data {
        data
    }
    
    /// Get string from raw value
    public var toString: String? {
        String(data: rawValue, encoding: .utf8)
    }
    
    /// Get data from raw value
    public var toData: Data {
        rawValue
    }
}

// Functions
extension AESRawValue {
    /// Encrypt
    /// - Parameters:
    ///   - key: AES key
    ///   - iv: AES initialization vector
    ///   - blockMode: Block mode, `.cbc` for default
    ///   - padding: Padding, `.pkcs7Padding` for default
    /// - Returns: Encrypted value
    public func encrypt(
        key: AESKey,
        iv: AESIV,
        blockMode: CC.BlockMode = .cbc,
        padding: CC.Padding = .pkcs7Padding
    ) throws -> AESEncryptedValue {
        try AES.encrypt(data: self, key: key, iv: iv, blockMode: blockMode, padding: padding)
    }
}
