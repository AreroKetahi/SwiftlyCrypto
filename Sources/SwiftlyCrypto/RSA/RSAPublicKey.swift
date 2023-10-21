//
//  RSAPublicKey.swift
//
//
//  Created by Akivili Collindort on 2023/8/24.
//

import Foundation
import SwCrypt

/// RSA Public Key
public struct RSAPublicKey {
    private var data: Data
}

// Initializers
extension RSAPublicKey {
    /// Generate a RSA Public Key from DER `Data`
    /// - Parameter data: DER Data
    public init(fromDER data: Data) {
        self.data = data
    }
    
    /// Generate a RSA Public Key from PKCS1 string
    /// - Parameter PKCS1Key: PKCS1 String
    public init(fromPKCS1 PKCS1Key: String) throws {
        self.data = try SwCrypt.SwKeyConvert.PublicKey.pemToPKCS1DER(PKCS1Key)
    }
    
    /// Generate a RSA Public Key from PKCS8 string
    /// - Parameter PKCS8Key: PKCS8 String
    public init(fromPKCS8 PKCS8Key: String) throws {
        self.data = try SwCrypt.SwKeyConvert.PublicKey.pemToPKCS1DER(PKCS8Key)
    }
    
    /// Generate a RSA Public key from encoded Base-64 string
    /// - Parameter base64Encoded: Encoded Base-64 string
    public init?(base64Encoded: String) {
        if let data = Data(base64Encoded: base64Encoded) {
            self.data = data
        } else {
            return nil
        }
    }
}

// Values
extension RSAPublicKey {
    internal var rawValue: Data {
        data
    }
}

// Functions
extension RSAPublicKey {
    /// Export key to DER format
    /// - Returns: DER Data
    public func toDER() -> Data {
        rawValue
    }
    
    /// Export key to PEM PKCS1 format
    /// - Returns: PKCS1 String
    public func toPKCS1() -> String {
        SwKeyConvert.PublicKey.derToPKCS1PEM(rawValue)
    }
    
    /// Export key to PEM PKCS8 format
    /// - Returns: PKCS8 String
    public func toPKCS8() -> String {
        SwKeyConvert.PublicKey.derToPKCS8PEM(rawValue)
    }
}
