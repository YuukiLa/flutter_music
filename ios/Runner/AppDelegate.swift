import UIKit
import Foundation
//import CryptoSwift
import Flutter
//import CryptoSwift

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    let channel = FlutterMethodChannel.init(name: "unknown/neteaseEnc",
                                                   binaryMessenger: controller.binaryMessenger);
    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
        let dic = call.arguments as! Dictionary<String, Any>
        if ("neteaseAesEnc" == call.method) {
          
          let text:String = dic["text"] as! String
          let secKey:String = dic["key"] as! String
          result(Enc.instance.neteaseAesEnc(text: text, secKey: secKey))
      }else if ("neteaseRsaEnc" == call.method) {
//          print(call.arguments)
          let text:String = dic["text"] as! String
          let pubKey:String = dic["pubKey"] as! String
          let modulus:String = dic["modulus"] as! String
          result(Enc.instance.neteaseRsaEnc(text: text, pubKey: pubKey, modulus: modulus))
      }else {
         result(FlutterMethodNotImplemented);
      }
    });
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
//  private func neteaseAesEnc(text: String, secKey: String) -> String{
//      do {
//          let aes = try AES(key: Array(secKey.utf8),  blockMode: CBC(iv: Array("0102030405060708".utf8)), padding: .pkcs7)
//          let ciphertext = try! aes.encrypt(text.utf8.map({$0}))
//          return String.init(data: Data.init(ciphertext).base64EncodedData(), encoding: .utf8) ?? ""
//      } catch {
//
//      }
//      return ""
//
//  }
//
//    private func neteaseRsaEnc(text: String, pubKey: String, modulus: String) -> String{
//        let revertText = String(text.reversed())
//        let diStr = hexlify(revertText.data(using: .utf8)!)
//        let di = BigUInt(diStr, radix: 16)
//        let exponent = BigUInt(pubKey, radix: 16)
//        let modulus = BigUInt(modulus, radix: 16)
//        let ret = di!.power(exponent!, modulus: modulus!)
//        let res = String.init(ret, radix: 16, uppercase: false)
//        return res.zfill(minimunLength: 256)
//    }
}
