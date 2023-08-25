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
