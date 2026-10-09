import UIKit
import ObjectiveC
import Flutter
import HealthKit
import WidgetKit
import flutter_local_notifications
import AlarmKit

private var channel: FlutterMethodChannel?
/// 画面を開かない通知アクション (アプリ終了状態からのクイックレコード) のために起動する Flutter エンジン。
/// UIScene では画面を開かない起動で scene が接続されず、storyboard の FlutterViewController が作る暗黙のエンジンが
/// 初期化されないため、必要になった時だけ起動し、画面のエンジンが初期化されて実行中の処理が無くなったら破棄する
private var headlessEngine: FlutterEngine?
/// headless エンジンで実行中の通知アクションの処理の数。実行中に破棄すると Dart 側の服用記録が途中で失われるため、0 になるまで破棄を待つ
private var headlessEngineInFlightCount = 0
/// 画面のエンジン (storyboard の FlutterViewController の暗黙のエンジン) が初期化済みか。初期化済みなら headless のエンジンは役目を終える
private var implicitEngineInitialized = false
/// アプリの UIApplicationDelegate。Flutter エンジンの初期化後の plugin とメソッドチャネルの登録、通知の設定を担う
@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  /// UIScene ライフサイクル (iOS 27 SDK でビルドしたアプリに必須) では application(_:didFinishLaunchingWithOptions:) の時点で
  /// window と FlutterViewController が無いため、Flutter エンジンの初期化後に plugin とメソッドチャネルを登録する。
  /// 移行手順: https://docs.flutter.dev/release/breaking-changes/uiscenedelegate
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    implicitEngineInitialized = true
    // 画面を開かない起動で先に headless のエンジンを起動していた場合は、Dart のアプリが 2 つ動き続けないよう画面のエンジンに一本化する
    destroyHeadlessEngineIfIdle()
    setUpMethodChannel(binaryMessenger: engineBridge.applicationRegistrar.messenger())
  }

  /// 画面のエンジンが初期化済みで、headless エンジンで実行中の処理が無ければ headless エンジンを破棄する。
  /// 通知アクションの処理中は破棄せず、その処理の完了時に改めて呼ぶ
  private func destroyHeadlessEngineIfIdle() {
    guard implicitEngineInitialized, headlessEngineInFlightCount == 0, let engine = headlessEngine else {
      return
    }
    engine.destroyContext()
    headlessEngine = nil
  }

  /// 画面を開かない通知アクションの処理で、まだ Flutter エンジンが無ければ headless で起動してメソッドチャネルを用意する。
  /// UIScene 移行前は storyboard の FlutterViewController が起動時に必ず作られ、終了状態からの通知アクションでも Dart 側の
  /// recordPill が動いていた。その経路を保つためのもの
  private func startHeadlessEngineIfNeeded() {
    if channel != nil {
      return
    }
    let engine = FlutterEngine(name: "headless")
    engine.run()
    GeneratedPluginRegistrant.register(with: engine)
    headlessEngine = engine
    setUpMethodChannel(binaryMessenger: engine.binaryMessenger)
  }

  /// Dart 側 (lib/native/channel.dart) とのメソッドチャネルを作り、ネイティブ側の処理を登録する
  private func setUpMethodChannel(binaryMessenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(
      name: "method.channel.MizukiOhashi.Pilll",
      binaryMessenger: binaryMessenger
    )
    // DO NOT OVERRIDE
    channel?.setMethodCallHandler(
      {
        call,
        _completionHandler in
        let completionHandler: (Dictionary<String, Any>) -> Void = {
          _completionHandler($0)
        }

        switch call.method {
        case "isHealthDataAvailable":
          completionHandler([
            "result": "success",
            "isHealthDataAvailable": HKHealthStore.isHealthDataAvailable()
          ])
        case "healthKitRequestAuthorizationIsUnnecessary":
          healthKitRequestAuthorizationIsUnnecessary { result in
            switch result {
            case .success(let isAuthorized):
              completionHandler([
                "result": "success",
                "healthKitRequestAuthorizationIsUnnecessary": isAuthorized
              ])
            case .failure(let failure):
              completionHandler(failure.toDictionary())
            }
          }
        case "healthKitAuthorizationStatusIsSharingAuthorized":
          healthKitAuthorizationStatusIsSharingAuthorized { result in
            switch result {
            case .success(let isAuthorized):
              completionHandler([
                "result": "success",
                "healthKitAuthorizationStatusIsSharingAuthorized": isAuthorized
              ])
            case .failure(let failure):
              completionHandler(failure.toDictionary())
            }
          }
        case "shouldRequestForAccessToHealthKitData":
          shouldRequestForAccessToHealthKitData { result in
            switch result {
            case .success(let shouldRequest):
              completionHandler([
                "result": "success",
                "shouldRequestForAccessToHealthKitData": shouldRequest
              ])
            case .failure(let failure):
              completionHandler(failure.toDictionary())
            }
          }
        case "requestWriteMenstrualFlowHealthKitDataPermission":
          requestWriteMenstrualFlowHealthKitDataPermission { result in
            switch result {
            case .success(let isSuccess):
              completionHandler(
                ["result": "success", "isSuccess": isSuccess]
              )
            case .failure(let error):
              completionHandler(error.toDictionary())
            }
          }
        case "addMenstruationFlowHealthKitData":
          addMenstruationFlowHealthKitData(arguments: call.arguments) { result in
            switch result {
            case .success(let success):
              completionHandler(success.toDictionary())
            case .failure(let failure):
              completionHandler(failure.toDictionary())
            }
          }
        case "updateOrAddMenstruationFlowHealthKitData":
          updateOrAddMenstruationFlowHealthKitData(arguments: call.arguments) { result in
            switch result {
            case .success(let success):
              completionHandler(success.toDictionary())
            case .failure(let failure):
              completionHandler(failure.toDictionary())
            }
          }
        case "deleteMenstrualFlowHealthKitData":
          deleteMenstrualFlowHealthKitData(arguments: call.arguments) { deleteResult in
            switch deleteResult {
            case .success(let success):
              completionHandler(success.toDictionary())
            case .failure(let failure):
              completionHandler(failure.toDictionary())
            }
          }
        case "reloadWidget":
          if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: Const.widgetKind)
          } else {
            // Fallback on earlier versions
          }
          completionHandler(["result": "success"])
        case "removeWidgetData":
          // home_widget の saveWidgetData に null を渡すと、iOS 27.1 では NSUserDefaults が NSNull を拒否して
          // NSInvalidArgumentException でアプリが落ちるため、Widget 用の値の削除は plugin を経由せずここで行う (lib/native/widget.dart)
          if let arguments = call.arguments as? [String: Any],
             let key = arguments["key"] as? String {
            UserDefaults(suiteName: Plist.appGroupKey)?.removeObject(forKey: key)
            completionHandler(["result": "success"])
          } else {
            completionHandler(["result": "failure", "message": "Invalid arguments for removeWidgetData"])
          }
        case "requestAppTrackingTransparency":
          requestAppTrackingTransparency(completion: completionHandler)
        case "presentShareToSNSForPremiumTrialReward":
          if let arguments = call.arguments as? [String: Any],
             let shareToSNSKindRawValue = arguments["shareToSNSKind"] as? String,
             let shareToSNSKind = ShareToSNSKind(rawValue: shareToSNSKindRawValue) {
            presentShareToSNSForPremiumTrialReward(kind: shareToSNSKind, completionHandler: completionHandler)
          } else {
            completionHandler(["result": "failure", "message": "不明なエラーが発生しました"])
          }
        case "isAlarmKitAvailable":
          completionHandler([
            "result": "success",
            "isAlarmKitAvailable": AlarmKitManager.shared.isAvailableForCurrentOS()
          ])
        case "getAlarmKitAuthorizationStatus":
          let authStatus = AlarmKitManager.shared.getAuthorizationStatus()
          completionHandler([
            "result": "success",
            "authorizationStatus": authStatus
          ])
        case "requestAlarmKitPermission":
          if #available(iOS 26.0, *) {
            Task {
              let authorized = await AlarmKitManager.shared.requestPermission()
              await MainActor.run {
                completionHandler([
                  "result": "success",
                  "authorized": authorized
                ])
              }
            }
          } else {
            completionHandler([
              "result": "failure",
              "message": "AlarmKit is not available on this OS version"
            ])
          }
        case "scheduleAlarmKitReminder":
          if let arguments = call.arguments as? [String: Any],
             let localNotificationID = arguments["localNotificationID"] as? String,
             let title = arguments["title"] as? String,
             let scheduledTimeMs = arguments["scheduledTimeMs"] as? NSNumber {

            if #available(iOS 26.0, *) {
              let scheduledTime = dartTypeDate(nsNumber: scheduledTimeMs)
              Task {
                do {
                  try await AlarmKitManager.shared.scheduleMedicationAlarm(
                    localNotificationID: localNotificationID,
                    title: title,
                    scheduledTime: scheduledTime
                  )
                  await MainActor.run {
                    completionHandler(["result": "success"])
                  }
                } catch {
                  await MainActor.run {
                    completionHandler([
                      "result": "failure",
                      "message": error.localizedDescription
                    ])
                  }
                }
              }
            } else {
              completionHandler([
                "result": "failure",
                "message": "AlarmKit is not available on this OS version"
              ])
            }
          } else {
            completionHandler([
              "result": "failure",
              "message": "Invalid arguments for scheduleAlarmKitReminder"
            ])
          }
        case "cancelAllAlarmKitReminders":
          if #available(iOS 26.0, *) {
            Task {
              do {
                try await AlarmKitManager.shared.cancelAllMedicationAlarms()
                await MainActor.run {
                  completionHandler(["result": "success"])
                }
              } catch {
                await MainActor.run {
                  completionHandler([
                    "result": "failure",
                    "message": error.localizedDescription
                  ])
                }
              }
            }
          } else {
            completionHandler([
              "result": "failure",
              "message": "AlarmKit is not available on this OS version"
            ])
          }
        case "stopAllAlarmKitAlarms":
          if #available(iOS 26.0, *) {
            Task {
              do {
                try await AlarmKitManager.shared.stopAllAlarms()
                await MainActor.run {
                  completionHandler(["result": "success"])
                }
              } catch {
                await MainActor.run {
                  completionHandler([
                    "result": "failure",
                    "message": error.localizedDescription
                  ])
                }
              }
            }
          } else {
            completionHandler([
              "result": "failure",
              "message": "AlarmKit is not available on this OS version"
            ])
          }
        case _:
          return
        }
      })
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
      // NOTE: [LOCAL_NOTIFICATION] Flutter local notificationの構造体をロギングしている
      if let dic = UserDefaults.standard.object(forKey: "flutter_local_notifications_presentation_options") as? [String: Any] {
        analytics(name: "fln_debug", parameters: dic)
      }
    }
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Await established channel
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      if #available(iOS 14.0, *) {
        WidgetCenter.shared.getCurrentConfigurations { result in
          do {
            let userConfiguredFamilies = try result.get().map(\.family)
            if !userConfiguredFamilies.isEmpty {
              if #available(iOS 16.0, *) {
                analytics(name: "user_configured_ios_widget", parameters: [
                  "systemSmall": userConfiguredFamilies.contains(.systemSmall),
                  "accessoryCircular": userConfiguredFamilies.contains(.accessoryCircular)
                ])
              } else {
                analytics(name: "user_configured_ios_widget", parameters: [
                  "systemSmall": userConfiguredFamilies.contains(.systemSmall),
                ])
              }
            }
          } catch {
            // Ignore error
          }
        }
      }
    }
    configureNotificationActionableButtons()
    UNUserNotificationCenter.current().swizzle()
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["repeat_notification_for_taken_pill", "remind_notification_for_taken_pill"])
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["repeat_notification_for_taken_pill", "remind_notification_for_taken_pill"])
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }
    // NOTE: [LOCAL_NOTIFICATION] Flutter Local NotificationのExamplesではFlutterLocalNotificationsPlugin.setPluginRegistrantCallbackのあとにDelegateをセットしている
    // 通知が来ない問題があり再現しないため原因は不明だがこの順番を守る
    UNUserNotificationCenter.current().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}

private func analytics(name: String, parameters: [String: Any]? = nil, function: StaticString = #function) {
  print(function, name, parameters ?? [:])
  channel?.invokeMethod("analytics", arguments: ["name": name, "parameters": parameters ?? [:]])
}

// MARK: - Avoid bug for flutter app badger
// ref: https://github.com/g123k/flutter_app_badger/pull/52
extension UNUserNotificationCenter {
  func swizzle() {
    guard let fromMethod = class_getInstanceMethod(type(of: self), #selector(UNUserNotificationCenter.setNotificationCategories(_:))) else {
      fatalError()
    }
    guard let toMethod = class_getInstanceMethod(type(of: self), #selector(UNUserNotificationCenter.setNotificationCategories_methodSwizzle(_:))) else {
      fatalError()
    }

    method_exchangeImplementations(fromMethod, toMethod)
  }

  @objc func setNotificationCategories_methodSwizzle(_ categories: Set<UNNotificationCategory>) {
    if categories.isEmpty {
      return
    }
    setNotificationCategories_methodSwizzle(categories)
  }
}

// MARK: - Notification
extension AppDelegate {
  func configureNotificationActionableButtons() {
    let recordAction = UNNotificationAction(identifier: "RECORD_PILL",
                                            title: "飲んだ")
    let category =
    UNNotificationCategory(identifier: Category.pillReminder.rawValue,
                           actions: [recordAction],
                           intentIdentifiers: [],
                           hiddenPreviewsBodyPlaceholder: "",
                           options: .customDismissAction)
    UNUserNotificationCenter.current().setNotificationCategories([category])
  }

  // NOTE: [LOCAL_NOTIFICATION] async/await版のメソッドは使わない。
  // FlutterPluginAppLifeCycleDelegateから呼び出しているのがwithCompletionHandler付きのものなので合わせる
  // https://chromium.googlesource.com/external/github.com/flutter/engine/+/refs/heads/flutter-2.5-candidate.8/shell/platform/darwin/ios/framework/Source/FlutterPluginAppLifeCycleDelegate.mm#283

  // NOTE: このメソッドをoverrideすることでplugin側の処理は呼ばれないことに注意する。
  // 常に一緒な結果をcompletionHandlerで実行すれば良いのでoverrideしても問題はない
  override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    if #available(iOS 15.0, *) {
      analytics(name: "will_present", parameters: ["notification_id" : notification.request.identifier, "content_title": notification.request.content.title, "content_body": notification.request.content.body, "content_interruptionLevel": notification.request.content.interruptionLevel.rawValue])
    } else {
      // Fallback on earlier versions
    }
    UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
      analytics(name: "pending_notifications", parameters: ["length": requests.count])
    })
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .list, .sound, .badge])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    func end() {
      var isCompleted: Bool = false
      let completionHandlerWrapper = {
        isCompleted = true
        completionHandler()
      }

      super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandlerWrapper)

      if !isCompleted {
        completionHandlerWrapper()
      }
    }

    switch extractCategory(userInfo: response.notification.request.content.userInfo) ?? Category(rawValue: response.notification.request.content.categoryIdentifier) {
    case .pillReminder:
      switch response.actionIdentifier {
      case "RECORD_PILL":
        // 先にバッジをクリアしてしまう。後述の理由でQuickRecordが多少遅延するため操作に違和感が出る。この部分は楽観的UIとして更新してしまう
        UIApplication.shared.applicationIconBadgeNumber = 0

        // UIScene では画面を開かないこのアクションで scene が接続されず画面のエンジンが起動しないため、終了状態からの起動では headless で起動する
        startHeadlessEngineIfNeeded()
        // 5 秒待つ間に画面のエンジンが初期化されて channel が差し替わっても、Dart の main を走らせ始めたエンジンへ送るため、
        // 送り先のチャネルはここで確定させる。headless エンジンへ送る時は、処理が終わるまで破棄されないよう実行中として数える
        let recordChannel = channel
        let usesHeadlessEngine = headlessEngine != nil
        if usesHeadlessEngine {
          headlessEngineInFlightCount += 1
        }

        // application(_:didFinishLaunchingWithOptions:)が終了してからFlutterのmainの開始は非同期的でFlutterのmainの完了までラグがある
        // 特にアプリのプロセスがKillされている状態では、先にuserNotificationCenter(_:didReceive:withCompletionHandler:)の処理が走り
        // Flutter側でのMethodChannelが確立される前にQuickRecordの呼び出しをおこなってしまう。この場合次にChanelが確立するまでFlutter側の処理の実行は遅延される。これは次のアプリの起動時まで遅延されるとほぼ同義になる
        // よって対処療法的ではあるが、5秒待つことでほぼ間違いなくmain(の中でもMethodChanelの確立までは)の処理はすべて終えているとしてここではdelayを設けている。
        // ちなみに通常は1秒前後あれば十分であるが念のためくらいの間を持たせている
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
          recordChannel?.invokeMethod("recordPill", arguments: nil, result: { result in
            end()
            if usesHeadlessEngine {
              headlessEngineInFlightCount -= 1
              destroyHeadlessEngineIfIdle()
            }
          })
        }
      default:
        end()
      }
    case nil:
      return
    }
  }

  enum Category: String {
    case pillReminder = "PILL_REMINDER"
  }

  func extractCategory(userInfo: [AnyHashable: Any]) -> Category? {
    guard let apns = userInfo["aps"] as? [String: Any], let category = apns["category"] as? String else {
      return nil
    }
    return Category(rawValue: category)
  }
}
