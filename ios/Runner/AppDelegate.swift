import UIKit
import Flutter

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
      if ("neteaseAesEnc" == call.method) {
          self.neteaseAesEnc(result: result);
        }else {
             result(FlutterMethodNotImplemented);
           }
    });
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  private func neteaseAesEnc(result: FlutterResult) {
      result("yuuki");

  }
}
