import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let deviceInfoChannel = FlutterMethodChannel(name: "com.juda.savepass/device_info", binaryMessenger: controller.binaryMessenger)

        deviceInfoChannel.setMethodCallHandler { (call, result) in
            if call.method == "getIosIdentifierForVendor" {
                if let identifier = UIDevice.current.identifierForVendor?.uuidString {
                    result(identifier)
                } else {
                    result(FlutterError(code: "UNAVAILABLE", message: "Unable to find identifierForVendor", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
