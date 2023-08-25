//
//  AESKey.swift
//
//
//  Created by Akivili Collindort on 2023/8/25.
//

import Foundation
import SwCrypt

/// AES Key
struct AESKey {
    private var data: Data
}

// Initializers
extension AESKey {
    /// Generate a empty key
    /// Use this initializer when performing encryption without a specified key.
    public init() {
        self.data = Data()
    }
    
    /// Create AES key from raw data
    /// - Parameter data: AES key data
    public init?(_ data: Data) {
        if [16, 24, 32].contains(data.count) {
            self.data = data
        } else {
            return nil
        }
    }
    
    /// Create AES key from hexadecimal string
    /// String length will effect what AES method that will use
    /// - Parameters:
    ///   - hexString: Hexadecimal string
    ///   - length: Passworf length
    public init(fromHexString hexString: String, length: Int = 32) throws {
        if hexString.count != length * 2 {
            throw AESError.unmatchedLength(length)
        }
        var hexString = hexString
        var result = [UInt8]()
        while !hexString.isEmpty {
            let sub = hexString.prefix(2)
            guard let byte = UInt8(sub, radix: 16) else {
                throw AESError.unexpectedHexString(String(sub))
            }
            result.append(byte)
            hexString = String(hexString.dropFirst(2))
        }
        self.data = Data(result)
    }
    
    public init?(_ key: String) {
        guard let key = key.data(using: .utf8) else {
            return nil
        }
        let digested = CC.digest(key, alg: .sha256)
        self.data = digested
    }
    
    /// Create AES key from base-64 encoded string
    /// - Parameter string: Base-64 encoded string
    public init?(base64Encoded string: String) {
        guard let data = Data(base64Encoded: string) else {
            return nil
        }
        self.data = data
    }
}

// Values
extension AESKey {
    internal var rawValue: Data {
        data
    }
    
    /// A Boolean value indicating whether the Key is empty.
    public var isEmpty: Bool {
        self.rawValue.isEmpty
    }
}

// Functions
extension AESKey {
    /// Get hexadecimal key
    /// - Returns: Hexadecimal key
    public func toHexString() -> String {
        var result = ""
        self.rawValue.forEach { element in
            result += String(format: "%02x", element)
        }
        return result
    }
    
    /// Get base-64 encoded key
    /// - Returns: Base-64 encoded key
    public func base64EncodedString() -> String {
        self.rawValue.base64EncodedString()
    }
}
