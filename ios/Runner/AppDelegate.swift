import UIKit
import ObjectiveC
import Flutter
import HealthKit
import WidgetKit
import flutter_local_notifications

private var channel: FlutterMethodChannel?
@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let viewController = window?.rootViewController as! FlutterViewController
    channel = FlutterMethodChannel(
      name: "method.channel.MizukiOhashi.Pilll",
      binaryMessenger: viewController.binaryMessenger
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
        case _:
          return
        }
      })

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

    GeneratedPluginRegistrant.register(with: self)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
      // NOTE: [LOCAL_NOTIFICATION] Flutter local notificationの構造体をロギングしている
      if let dic = UserDefaults.standard.object(forKey: "flutter_local_notifications_presentation_options") as? [String: Any] {
        analytics(name: "fln_debug", parameters: dic)
      }
    }

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

        // application(_:didFinishLaunchingWithOptions:)が終了してからFlutterのmainの開始は非同期的でFlutterのmainの完了までラグがある
        // 特にアプリのプロセスがKillされている状態では、先にuserNotificationCenter(_:didReceive:withCompletionHandler:)の処理が走り
        // Flutter側でのMethodChannelが確立される前にQuickRecordの呼び出しをおこなってしまう。この場合次にChanelが確立するまでFlutter側の処理の実行は遅延される。これは次のアプリの起動時まで遅延されるとほぼ同義になる
        // よって対処療法的ではあるが、5秒待つことでほぼ間違いなくmain(の中でもMethodChanelの確立までは)の処理はすべて終えているとしてここではdelayを設けている。
        // ちなみに通常は1秒前後あれば十分であるが念のためくらいの間を持たせている
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
          channel?.invokeMethod("recordPill", arguments: nil, result: { result in
            end()
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
