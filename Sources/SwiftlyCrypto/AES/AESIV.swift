//
//  AESIV.swift
//
//
//  Created by Akivili Collindort on 2023/8/25.
//

import Foundation

/// AES Initialization Vector
struct AESIV {
    private var data: Data
    
    /// Generate IV from raw data
    /// - Parameter data: IV data
    public init?(_ data: Data) {
        if data.count == 16 {
            self.data = data
        } else {
            return nil
        }
    }
}

// Initializers
extension AESIV {
    /// Generate a empty IV
    /// Use this initializer when performing encryption without a specified IV.
    public init() {
        self.data = Data()
    }
    
    /// Generate IV from hexadecimal string
    /// - Parameters:
    ///   - hexString: Hexadecimal string
    ///   - length: IV length, for AES is 16
    public init(fromHexString hexString: String, length: Int = 16) throws {
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
    
    /// Generate IV from base-64 encoded string
    /// - Parameter string: Base-64 encoded string
    public init?(base64Encoded string: String) {
        if let data = Data(base64Encoded: string) {
            self.data = data
        }
        return nil
    }
}

// Values
extension AESIV {
    internal var rawValue: Data {
        data
    }
    /// A Boolean value indicating whether the IV is empty.
    public var isEmpty: Bool {
        self.rawValue.isEmpty
    }
}

// Functions
extension AESIV {
    /// Get hexadecimal string
    /// - Returns: Hexadecimal string
    public func toHexString() -> String {
        var result = ""
        self.rawValue.forEach { element in
            result += String(format: "%02x", element)
        }
        return result
    }
    
    /// Get base-64 encoded string
    /// - Returns: Base-64 encoded string
    public func base64EncodedString() -> String {
        self.rawValue.base64EncodedString()
    }
}
