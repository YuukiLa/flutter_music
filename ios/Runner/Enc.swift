//
//  Enc.swift
//  Runner
//
//  Created by 陈尼玛 on 2022/4/5.
//

import Foundation
import CryptoSwift
import BigInt

class Enc:NSObject{
    static let instance = Enc()
    
    public func neteaseAesEnc(text: String, secKey: String) -> String{
        do {
            let aes = try AES(key: Array(secKey.utf8),  blockMode: CBC(iv: Array("0102030405060708".utf8)), padding: .pkcs7)
            let ciphertext = try! aes.encrypt(text.utf8.map({$0}))
            return String.init(data: Data.init(ciphertext).base64EncodedData(), encoding: .utf8) ?? ""
        } catch {

        }
        return ""

    }

      public func neteaseRsaEnc(text: String, pubKey: String, modulus: String) -> String{
          let revertText = String(text.reversed())
          let diStr = hexlify(revertText.data(using: .utf8)!)
          let di = BigUInt(diStr, radix: 16)
          let exponent = BigUInt(pubKey, radix: 16)
          let modulus = BigUInt(modulus, radix: 16)
          let ret = di!.power(exponent!, modulus: modulus!)
          let res = String.init(ret, radix: 16, uppercase: false)
          return zfill(str: res,minimunLength: 256)
      }
    public func hexlify(_ data:Data) -> String {
        
        // similar to hexlify() in Python's binascii module
        // https://docs.python.org/2/library/binascii.html
        
        var s = String()
        var byte: UInt8 = 0
        
        for i in 0 ..< data.count {
            (data as NSData).getBytes(&byte, range: NSMakeRange(i, 1))
            s = s.appendingFormat("%02x", byte)
        }
        
        return s as String
    }
    func zfill(str:String,minimunLength: Int) -> String {
            var ret = str
            if str.count < minimunLength {
                for _ in 0 ..< minimunLength - str.count {
                    ret = "0" + ret
                }
            }
            return ret
        }
}
