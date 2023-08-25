import XCTest
@testable import SwiftlyCrypto


final class SwiftlyCryptoRSATests: XCTestCase {
    func testRSAKeyMethods() throws {
        let (priKey, pubKey) = try RSA.generateKeyPair()
        // Test private key
        let priDER = priKey.toDER()
        let priPKCS = priKey.toPKCS1()
        XCTAssert(!priDER.isEmpty) // Test export DER
        XCTAssert(!priPKCS.isEmpty) // Test export PKCS1
        
        let priFromDER = RSAPrivateKey(fromDER: priDER)
        let priFromPKCS = try RSAPrivateKey(fromPKCS1: priPKCS)
        XCTAssert(priFromDER == priFromPKCS)
        
        let encryptPassword = "password"
        let encryptedKey = try priKey.encryptedKey(encryptPassword)
        let decryptedKey = try RSAPrivateKey(encryptedKey, password: encryptPassword)
        XCTAssert(priKey == decryptedKey)
        
        let exportedPubKey = try priKey.getPublicKey()
        XCTAssert(exportedPubKey == pubKey)
        
        // Test public key
        let pubDER = pubKey.toDER()
        let pubPKCS1 = pubKey.toPKCS1()
        let pubPKCS8 = pubKey.toPKCS8()
        XCTAssert(!pubDER.isEmpty) // Test export DER
        XCTAssert(!pubPKCS1.isEmpty) // Test export PKCS1
        XCTAssert(!pubPKCS8.isEmpty) // Test export PKCS8
        
        let pubFromDER = RSAPublicKey(fromDER: pubDER)
        let pubFromPKCS1 = try RSAPublicKey(fromPKCS1: pubPKCS1)
        let pubFromPKCS8 = try RSAPublicKey(fromPKCS8: pubPKCS8)
        XCTAssert(pubKey == pubFromDER)
        XCTAssert(pubKey == pubFromPKCS1)
        XCTAssert(pubKey == pubFromPKCS8)
    }
    
    func testRSAEncrypt() throws {
        let (priKey, pubKey) = try RSA.generateKeyPair()
        let message = RSARawValue("Hello, world!")
        
        let encrypted = try message.encrypt(publicKey: pubKey)
        let decrypted = try encrypted.decrypt(privateKey: priKey)
        
        XCTAssert(message.toString == decrypted.toString)
    }
    
    func testRSASign() throws {
        let (priKey, pubKey) = try RSA.generateKeyPair()
        let message = RSARawValue("Hello, world!")
        
        let sign = try message.sign(privateKey: priKey)
        let verifySign = try sign.verify(message: message, publicKey: pubKey)
        let verifyMessage = try message.verify(signature: sign, publicKey: pubKey)
        
        XCTAssert(verifySign)
        XCTAssert(verifyMessage)
    }
}

final class SwiftlyCryptoAESTestsL: XCTestCase {
    func testGenerateRandomKeyIV() throws {
        let randomKey = try? AES.generateRandomKey()
        let randomIV = try? AES.generateRandomIV()
        XCTAssert(randomKey != nil)
        XCTAssert(randomIV != nil)
    }
    
    func testAESKeyMethods() throws {
        let password = "password"
        guard let key1 = AESKey(password) else {
            fatalError()
        }
        let key2 = try AESKey(fromHexString: key1.toHexString())
        
        XCTAssert(key1 == key2)
        
        let base64Encoded = key1.base64EncodedString()
        let backToKey = AESKey(base64Encoded: base64Encoded)
        
        XCTAssert(backToKey != nil)
    }
    
    func testRandomKeyWhileEncrypt() throws {
        let raw = AESRawValue("Hello, world!")
        var key = AESKey()
        var iv = AESIV()
        XCTAssert(key.isEmpty)
        XCTAssert(iv.isEmpty)
        
        let encrypted = try raw.encrypt(randomKey: &key, randomIV: &iv)
        let decrypted = try encrypted.decrypt(key: key, iv: iv)
        XCTAssert(!key.isEmpty)
        XCTAssert(!iv.isEmpty)
        XCTAssert(raw == decrypted)
    }
    
    func testAESEncrypt() throws {
        let key = try AES.generateRandomKey()
        let iv = try AES.generateRandomIV()
        let raw = AESRawValue("Hello, world!")
        let encrypted = try raw.encrypt(key: key, iv: iv)
        let decrypted = try encrypted.decrypt(key: key, iv: iv)
        XCTAssert(raw == decrypted)
    }
}

extension RSAPrivateKey: Equatable {
    public static func == (lhs: RSAPrivateKey, rhs: RSAPrivateKey) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension RSAPublicKey: Equatable {
    public static func == (lhs: RSAPublicKey, rhs: RSAPublicKey) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension AESKey: Equatable {
    public static func == (lhs: AESKey, rhs: AESKey) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension AESRawValue: Equatable {
    public static func == (lhs: AESRawValue, rhs: AESRawValue) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
