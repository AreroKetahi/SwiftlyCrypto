//
//  AES.swift
//
//
//  Created by Akivili Collindort on 2023/8/25.
//

import Foundation
import SwCrypt

/// Advanced Encryption Standard
public final class AES {
    internal static func encrypt(
        data: AESRawValue,
        key: AESKey,
        iv: AESIV,
        blockMode: CC.BlockMode = .cbc,
        padding: CC.Padding = .pkcs7Padding
    ) throws -> AESEncryptedValue {
        let data = try CC.crypt(.encrypt, blockMode: blockMode, algorithm: .aes, padding: padding, data: data.rawValue, key: key.rawValue, iv: iv.rawValue)
        return AESEncryptedValue(data)
    }
    
    internal static func decrypt(
        data: AESEncryptedValue,
        key: AESKey,
        iv: AESIV,
        blockMode: CC.BlockMode = .cbc,
        padding: CC.Padding = .pkcs7Padding
    ) throws -> AESRawValue {
        let data = try CC.crypt(.decrypt, blockMode: blockMode, algorithm: .aes, padding: padding, data: data.rawValue, key: key.rawValue, iv: iv.rawValue)
        return AESRawValue(data)
    }
    
    public static func generateRandomKey(keySize: Int = 32) throws -> AESKey {
        let rawValue = CC.generateRandom(keySize)
        guard let key = AESKey(rawValue) else {
            throw AESError.invaildGeneration
        }
        return key
    }
    
    public static func generateRandomIV() throws -> AESIV {
        let rawValue = CC.generateRandom(16)
        guard let iv = AESIV(rawValue) else {
            throw AESError.invaildGeneration
        }
        return iv
    }
}
