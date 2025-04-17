import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    var blurEffectView: UIView?

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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenCaptureChanged),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )

        checkScreenCapture()

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func applicationWillResignActive(_ application: UIApplication) {
        if let window = UIApplication.shared.windows.first {
            let blurEffectView = UIView()
            blurEffectView.backgroundColor = UIColor.black
            blurEffectView.frame = window.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            window.addSubview(blurEffectView)
            self.blurEffectView = blurEffectView
        }
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        checkScreenCapture()
    }

    @objc func handleScreenCaptureChanged() {
        checkScreenCapture()
    }

    func checkScreenCapture() {
        guard let window = UIApplication.shared.windows.first else { return }

        if UIScreen.main.isCaptured {
            if blurEffectView == nil {
                let overlay = UIView(frame: window.bounds)
                overlay.backgroundColor = .black
                overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                window.addSubview(overlay)
                blurEffectView = overlay
            }
        } else {
            blurEffectView?.removeFromSuperview()
            blurEffectView = nil
        }
    }
}
