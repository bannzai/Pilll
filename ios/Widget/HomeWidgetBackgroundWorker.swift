import Flutter
import Foundation
import Swift

struct HomeWidgetBackgroundWorker {
  static let dispatcherKey: String = "home_widget.interactive.dispatcher"
  static let callbackKey: String = "home_widget.interactive.callback"

  static var isSetupCompleted = false
  static var isRunBeforeSetupEngine = false
  static var engine: FlutterEngine?
  static var channel: FlutterMethodChannel?

  static var debug: String {
    get {
      UserDefaults(suiteName: Plist.appGroupKey)?.string(forKey: "debug") ?? ""
    }
    set {
      UserDefaults(suiteName: Plist.appGroupKey)?.set(newValue, forKey: "debug")
    }
  }

  private static var registerPlugins: FlutterPluginRegistrantCallback?

  static func setPluginRegistrantCallback(registerPlugins: FlutterPluginRegistrantCallback) {
    self.registerPlugins = registerPlugins
  }

  /// Call this method to invoke the callback registered in your Flutter App.
  static func run() async throws {
    //    let userDefaults = UserDefaults(suiteName: Plist.appGroupKey)
    //    let dispatcher = userDefaults?.object(forKey: dispatcherKey) as! Int64
    //    setupEngine(dispatcher: dispatcher)

    if isSetupCompleted {
      debug += "1:"
      try await sendEvent()
    } else {
      debug += "2:"
      isRunBeforeSetupEngine = true
    }
  }

  static func setupEngine(dispatcher: Int64) {
    engine = FlutterEngine(name: "home_widget_background", project: nil, allowHeadlessExecution: true)
    channel = FlutterMethodChannel(
      name: "pilll/home_widget/background", binaryMessenger: engine!.binaryMessenger,
      codec: FlutterStandardMethodCodec.sharedInstance()
    )
    let flutterCallbackInfo = FlutterCallbackCache.lookupCallbackInformation(dispatcher)
    let started = engine?.run(
      withEntrypoint: flutterCallbackInfo?.callbackName,
      libraryURI: flutterCallbackInfo?.callbackLibraryPath
    )
    print("Flutter background worker engine started: \(String(describing: started))")
    if let registerPlugins {
      // engine initialized begin this function
      registerPlugins(engine!)
    }

    debug += "3:"
    channel?.setMethodCallHandler(handle)
  }

  static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let completionHandler: (Dictionary<String, Any>) -> Void = {
      result($0)
    }

    switch call.method {
    case "HomeWidget.backgroundInitialized":
      debug += "4:"
      if isRunBeforeSetupEngine {
        isRunBeforeSetupEngine = false
        isSetupCompleted = true
        Task { @MainActor in
          try? await sendEvent()
        }
      }
      completionHandler(["result": "success"])
    case "syncActivePillSheetValue":
      syncActivePillSheetValue(call: call, completionHandler: completionHandler)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  static func sendEvent() async throws {
    debug += "6:"
    
    return try await withCheckedThrowingContinuation { continuation in
      channel?.invokeMethod("", arguments: [], result: { result in
        guard let result = result as? Bool else {
          continuation.resume(throwing: NSError(domain: "com.bannzai.Pilll", code: 1000))
          return
        }

        if result {
          continuation.resume()
        } else {
          continuation.resume(throwing: NSError(domain: "com.bannzai.Pilll", code: 1001))
        }
      })
    }
  }
}

