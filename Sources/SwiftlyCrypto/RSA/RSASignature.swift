//
//  RSASignature.swift
//  
//
//  Created by Akivili Collindort on 2023/8/24.
//

import Foundation

struct RSASignature {
    private var data: Data
}

// Initializers
extension RSASignature {
    /// Use raw value to genreate a `RSASignature`
    /// - Parameter data: Raw value
    public init(rawValue data: Data) {
        self.data = data
    }
    
    /// Generate RSA signature value from Base-64 encoded string
    /// - Parameters:
    ///   - base64Encoded: Base-64 encoded string
    ///   - options: The options to use for the decoding. Default value is `[]`.
    public init?(base64Encoded: String, options: Data.Base64DecodingOptions = []) {
        guard let data = Data(base64Encoded: base64Encoded, options: options) else {
            return nil
        }
        self.data = data
    }
}

// Values
extension RSASignature {
    /// Get raw value
    public var rawValue: Data {
        data
    }
}

// Functions
extension RSASignature {
    /// Return a Base-64 Encoded RSA signature value
    /// - Parameter options: The options to use for the encoding. Default value is `[]`.
    /// - Returns: Base-64 encoded RSA signature value
    public func base64EncodedString(options: Data.Base64EncodingOptions = []) -> String {
        rawValue.base64EncodedString(options: options)
    }
}
