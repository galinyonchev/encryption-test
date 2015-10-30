//
//  ViewController.swift
//  EncryptionTest
//
//  Created by Galin Yonchev on 10/30/15.
//  Copyright © 2015 Galin Yonchev. All rights reserved.
//

import UIKit
import CryptoSwift
import RNCryptor

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let password = "A12345678Z"
        let seed = "HeanpyftAkWilfUd"
        
        // CryptoJS -> https://github.com/etienne-martin/CryptoJS.swift
        print("CryptoJS: \(CryptoJS.AES().encrypt(password, secretKey: seed))\n")
        
        // RNCryptor -> https://github.com/RNCryptor/RNCryptor
        let salt = seed.dataUsingEncoding(NSUTF8StringEncoding)
        let key = RNCryptor.FormatV3.keyForPassword(password, salt: salt!)
        print("RNCryptor: \(key.toHexString())\n")
        
        // PBKDF2+Base64 -> investigate PBDKF2.m for more info
        let data = PBKDF2.pbkdf2(password, salt: seed, count: 1, kLen: 64)
        print("PBKDF2+Base64: \(data.toHexString())\n")
        
        // AESCrypt
        let result = AESCrypt.encrypt(password, password: seed)
        print("AESCrypt: \(result)\n")
        
        // Soidum -> https://github.com/jedisct1/swift-sodium
        // FAILED TO INSTALL
        
        // AeroGearCrypto -> https://github.com/aerogear/aerogear-crypto-ios
        // FAILED TO INSTALL
    }
 
}

internal extension NSData {
    convenience init(bytes: [UInt8]) {
        self.init(bytes: bytes, length: bytes.count)
    }
    
    func hexString() -> NSString {
        let str = NSMutableString()
        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(self.bytes), count:self.length)
        for byte in bytes {
            str.appendFormat("%02hhx", byte)
        }
        return str
    }
}

internal extension String {
    var dataFromHexEncoding: NSData? {
        let strip = [Character]([" ", "<", ">", "\n", "\t"])
        let input = characters.filter { c in !strip.contains(c)}
        
        guard input.count % 2 == 0 else { return nil }
        
        let data = NSMutableData()
        for i in 0.stride(to: input.count, by: 2) {
            guard var value = UInt8(String(input[i...i+1]), radix: 16) else { return nil }
            data.appendBytes(&value, length:1)
        }
        
        return data
    }
}