import Flutter
import Foundation
import Swift

@available(iOS 17, *)
public struct HomeWidgetBackgroundWorker {
  static let dispatcherKey: String = "home_widget.interactive.dispatcher"
  static let callbackKey: String = "home_widget.interactive.callback"

  static var isSetupCompleted: Bool = false
  static var engine: FlutterEngine?
  static var channel: FlutterMethodChannel?
  static var queue: [(URL?, String)] = []

  private static var registerPlugins: FlutterPluginRegistrantCallback?

  public static func setPluginRegistrantCallback(registerPlugins: FlutterPluginRegistrantCallback) {
    self.registerPlugins = registerPlugins
  }

  /// Call this method to invoke the callback registered in your Flutter App.
  /// The url you provide will be used as arguments in the callback function in dart
  /// The AppGroup is necessary to retrieve the dart callbacks
  static public func run(url: URL?, appGroup: String?) async {
//    let userDefaults = UserDefaults(suiteName: Plist.appGroupKey)
//    let dispatcher = userDefaults?.object(forKey: dispatcherKey) as! Int64
//    setupEngine(dispatcher: dispatcher)

    if isSetupCompleted {
      queue.append((url, Plist.appGroupKey))
    } else {
      await sendEvent(url: url, appGroup: Plist.appGroupKey)
    }
  }

  static func setupEngine(dispatcher: Int64) {
    engine = FlutterEngine(
      name: "home_widget_background", project: nil, allowHeadlessExecution: true)

    channel = FlutterMethodChannel(
      name: "pilll/home_widget/background", binaryMessenger: engine!.binaryMessenger,
      codec: FlutterStandardMethodCodec.sharedInstance()
    )
    let flutterCallbackInfo = FlutterCallbackCache.lookupCallbackInformation(dispatcher)
    let started = engine?.run(
      withEntrypoint: flutterCallbackInfo?.callbackName,
      libraryURI: flutterCallbackInfo?.callbackLibraryPath)
    if registerPlugins != nil {
      registerPlugins?(engine!)
    } else {
//      HomeWidgetPlugin.register(with: engine!.registrar(forPlugin: "home_widget")!)
    }

    channel?.setMethodCallHandler(handle)
  }

  public static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "HomeWidget.backgroundInitialized":
      while !queue.isEmpty {
        isSetupCompleted = true
        let entry = queue.removeFirst()
        Task {
          await sendEvent(url: entry.0, appGroup: entry.1)
        }
      }
      result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  static func sendEvent(url: URL?, appGroup: String) async {
    let preferences = UserDefaults(suiteName: appGroup)
    let callback = preferences?.object(forKey: callbackKey) as! Int64

    channel?.invokeMethod(
      "",
      arguments: [
        callback,
      ])
  }
}

