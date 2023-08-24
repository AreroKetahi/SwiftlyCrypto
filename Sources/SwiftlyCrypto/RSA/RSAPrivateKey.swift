//
//  RSAPrivateKey.swift
//
//
//  Created by Akivili Collindort on 2023/8/24.
//

import Foundation
import SwCrypt

/// RSA Private Key
struct RSAPrivateKey {
    private var data: Data
}

// Initializers
extension RSAPrivateKey {
    /// Generate a RSA Private Key from DER `Data`
    /// - Parameter data: DER Data
    public init(fromDER data: Data) {
        self.data = data
    }
    
    /// Generate a RSA Private Key from PKCS1 string
    /// - Parameter PKCS1Key: PKCS1 String
    public init(fromPKCS1 PKCS1Key: String) throws {
        self.data = try SwKeyConvert.PrivateKey.pemToPKCS1DER(PKCS1Key)
    }
    
    /// Generate a RSA Private Key from encrypted PEM string
    /// - Parameters:
    ///   - encryptedKey: Encrypted PEM string
    ///   - password: Key password
    public init(_ encryptedKey: String, password: String) throws {
        let decryptedPEMKey = try SwKeyConvert.PrivateKey.decryptPEM(encryptedKey, passphrase: password)
        self = try Self.init(fromPKCS1: decryptedPEMKey)
    }
}

// Values
extension RSAPrivateKey {
    internal var rawValue: Data {
        data
    }
}

// Functions
extension RSAPrivateKey {
    /// Export key to DER format
    /// - Returns: DER Data
    public func toDER() -> Data {
        rawValue
    }
    
    /// Export key to PEM PKCS1 format
    /// - Returns: PKCS1 String
    public func toPKCS1() -> String {
        SwCrypt.SwKeyConvert.PrivateKey.derToPKCS1PEM(rawValue)
    }
    
    /// Export key to encrypted PEM format
    /// - Parameters:
    ///   - password: Key password
    ///   - aesMode: AES encryption mode
    /// - Returns: Encrypted PEM key
    public func encryptedKey(_ password: String, aesMode: SwKeyConvert.PrivateKey.EncMode = .aes256CBC) throws -> String {
        try SwKeyConvert.PrivateKey.encryptPEM(self.toPKCS1(), passphrase: password, mode: aesMode)
    }
    
    /// Get public key from this key
    /// - Returns: RSA Public Key
    public func getPublicKey() throws -> RSAPublicKey {
        let pubKey = try CC.RSA.getPublicKeyFromPrivateKey(self.rawValue)
        return RSAPublicKey(fromDER: pubKey)
    }
}
