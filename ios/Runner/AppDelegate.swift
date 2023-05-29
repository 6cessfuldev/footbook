import UIKit
import Flutter
import FlutterDotEnv

FlutterDotEnv().load()

guard let apiKey = FlutterDotEnv.env()["GMS_API_KEY"] as? String else {
    fatalError("API 키를 찾을 수 없습니다.")
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey(apiKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
