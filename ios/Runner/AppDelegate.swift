import UIKit
import Flutter
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let CHANNEL = "flashlight"
    private var isFlashlightOn = false
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let flashlightChannel = FlutterMethodChannel(name: CHANNEL,
                                                   binaryMessenger: controller.binaryMessenger)
        
        flashlightChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            guard let self = self else { return }
            
            switch call.method {
            case "toggleFlashlight":
                self.toggleFlashlight(result: result)
            case "isFlashlightOn":
                result(self.isFlashlightOn)
            case "isFlashlightAvailable":
                result(self.isFlashlightAvailable())
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func toggleFlashlight(result: @escaping FlutterResult) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            result(FlutterError(code: "NO_CAMERA", 
                              message: "Kamera topilmadi", 
                              details: nil))
            return
        }
        
        guard device.hasTorch else {
            result(FlutterError(code: "NO_FLASHLIGHT", 
                              message: "Bu qurilmada flashlight mavjud emas", 
                              details: nil))
            return
        }
        
        do {
            try device.lockForConfiguration()
            
            if isFlashlightOn {
                // Flashlight o'chirish
                device.torchMode = .off
                isFlashlightOn = false
            } else {
                // Flashlight yoqish
                try device.setTorchModeOn(level: 1.0)
                isFlashlightOn = true
            }
            
            device.unlockForConfiguration()
            result(isFlashlightOn)
            
        } catch {
            device.unlockForConfiguration()
            result(FlutterError(code: "FLASHLIGHT_ERROR", 
                              message: "Flashlight boshqarilmadi: \(error.localizedDescription)", 
                              details: nil))
        }
    }
    
    private func isFlashlightAvailable() -> Bool {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return false
        }
        return device.hasTorch
    }
}