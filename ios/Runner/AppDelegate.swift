import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    AudioPlayerHandler.register(with: self.registrar(forPlugin: "audio_player")!)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
