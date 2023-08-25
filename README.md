# SwiftlyCrypto

![GitHub](https://img.shields.io/github/license/AreroKetahi/SwiftlyCrypto)
![GitHub release (with filter)](https://img.shields.io/github/v/release/AreroKetahi/SwiftlyCrypto)

![Static Badge](https://img.shields.io/badge/Swift_Package_Manager-compatible-default?logo=swift&logoColor=white)

Encrypt your data like using other Swift APIs

SwiftlyCrypto is based on [SwCrypt](https://github.com/soyersoyer/SwCrypt) from [@soyersoyer](https://github.com/soyersoyer)

## Why SwiftlyCrypto? 

SwiftlyCrypto is a non-abstract crypto library. Developers can benefit from SwiftlyCrypto's figurative API.

SwiftlyCrypto will never define a type as its original value. (Like `Data` or `String`.) This feature can be very useful in large projects, because it makes the code more readable.

SwiftlyCrypto is repackaged from SwCryt. Thanks [@soyersoyer](https://github.com/soyersoyer)'s project [SwCrypt](https://github.com/soyersoyer/SwCrypt)!

# Quick Tutorial

You should import SwiftlyCrypto to your code at the beginning.

```swift
import SwiftlyCrypto
```

## RSA

### Generate key pair

```swift
let (privateKey, publicKey) = RSA.generateKeyPair()
```

### Get PEM format keys

```swift
let pemPrivateKey = privateKey.toPKCS1()
let pemPublicKey = publicKey.toPKCS8()
```

### Encrypt & decrypt private key

```swift
let encryptedPrivateKey = try privateKey.encryptedKey("password")
let decryptedPrivateKey = try RSAPrivateKey(encryptedPrivateKey, password: "password")
```

### Get public key from private key

```swift
let publicKey = try privateKey.getPublicKey()
```

### Encrypt & Decrypt

```swift
let text = "Hello, world!"
let raw = RSARawValue(text)
let encrypted = try raw.encrypt(publicKey: publicKey)
let decrypted = try encrypted.decrypt(privateKey: privateKey)
```

### Sign & Verify

```swift
let text = "Hello, world!"
let raw = RSARawValue(text)
let signed = try raw.sign(privateKey: privateKey)
let verifyResult = try signed.verify(message: raw, publicKey: publicKey) // true for success, otherwise false
```

## AES

### Generate random Key & IV

```swift
let randomKey = AES.generateRandomKey()
let randomIV = AES.generateRandomIV()
```

### Set your own Key & IV

```swift
let key = AESKey("password")
let iv = try AESIV(fromHexString: "12345678901234567890123456789012")
```

### Encrypt & Decrypt

```swift
let text = "Hello, world!"
let raw = AESRawValue(text)
let encrypted = try raw.encrypt(key: key, iv: iv)
let decrypted = try encrypted.decrypt(key: key, iv: iv)
```

### Encrypt with random generation

```swift
// generate both key and iv
let raw = AESRawValue("Hello, world!")
let key = AESKey()
let iv = AESIV()
let encrypted = try raw.encrypt(randomKey: &key, randomIV: &iv)
```

```swift
// generate key
let raw = AESRawValue("Hello, world!")
let key = AESKey()
let iv = try AESIV(fromHexString: "12345678901234567890123456789012")
let encrypted = try raw.encrypt(randomKey: &key, iv: iv)
```

```swift
// generate iv
let raw = AESRawValue("Hello, world!")
let key = AESKey("password")
let iv = AESIV()
let encrypted = try raw.encrypt(key: key, randomIV: &iv)
```

### Check whether the key or IV is empty

```swift
// true for empty, otherwise false
key.isEmpty
iv.isEmpty
```
