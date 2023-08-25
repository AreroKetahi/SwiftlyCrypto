//
//  AESError.swift
//  
//
//  Created by Akivili Collindort on 2023/8/25.
//

import Foundation

/// Error that may occur in AES cipher
enum AESError: Error {
    case unmatchedLength(Int), unexpectedHexString(String)
    case invaildGeneration
}
