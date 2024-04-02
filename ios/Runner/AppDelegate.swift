import UIKit
import ObjectiveC
import Flutter
import HealthKit
import WidgetKit
import flutter_local_notifications

private var channel: FlutterMethodChannel?
@UIApplicationMain
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
        channel?.setMethodCallHandler({ call, _completionHandler in
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
            case "syncUserStatus":
                guard let arguments = call.arguments as? Dictionary<String, Any> else {
                    fatalError()
                }

                let userIsPremiumOrTrial = arguments[Const.userIsPremiumOrTrial] as? Bool
                UserDefaults(suiteName: Plist.appGroupKey)?.set(userIsPremiumOrTrial, forKey: Const.userIsPremiumOrTrial)

                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadTimelines(ofKind: Const.widgetKind)
                } else {
                    // Fallback on earlier versions
                }

                completionHandler(["result": "success"])
            case "syncSetting":
                guard let arguments = call.arguments as? Dictionary<String, Any> else {
                    fatalError()
                }

                let settingPillSheetAppearanceMode = arguments[Const.settingPillSheetAppearanceMode] as? String
                UserDefaults(suiteName: Plist.appGroupKey)?.set(settingPillSheetAppearanceMode, forKey: Const.settingPillSheetAppearanceMode)

                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadTimelines(ofKind: Const.widgetKind)
                } else {
                    // Fallback on earlier versions
                }

                completionHandler(["result": "success"])
            case "syncActivePillSheetValue":
                guard let arguments = call.arguments as? Dictionary<String, Any> else {
                    fatalError()
                }

                let pillSheetValueLastUpdateDateTime = arguments[Const.pillSheetValueLastUpdateDateTime] as? Int
                UserDefaults(suiteName: Plist.appGroupKey)?.set(pillSheetValueLastUpdateDateTime, forKey: Const.pillSheetValueLastUpdateDateTime)

                let pillSheetLastTakenDate = arguments[Const.pillSheetLastTakenDate] as? Int
                UserDefaults(suiteName: Plist.appGroupKey)?.set(pillSheetLastTakenDate, forKey: Const.pillSheetLastTakenDate)

                let pillSheetGroupTodayPillNumber = arguments[Const.pillSheetGroupTodayPillNumber] as? Int
                UserDefaults(suiteName: Plist.appGroupKey)?.set(pillSheetGroupTodayPillNumber, forKey: Const.pillSheetGroupTodayPillNumber)

                let pillSheetTodayPillNumber = arguments[Const.pillSheetTodayPillNumber] as? Int
                UserDefaults(suiteName: Plist.appGroupKey)?.set(pillSheetTodayPillNumber, forKey: Const.pillSheetTodayPillNumber)

                let pillSheetEndDisplayPillNumber = arguments[Const.pillSheetEndDisplayPillNumber] as? Int
                UserDefaults(suiteName: Plist.appGroupKey)?.set(pillSheetEndDisplayPillNumber, forKey: Const.pillSheetEndDisplayPillNumber)

                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadTimelines(ofKind: Const.widgetKind)
                } else {
                    // Fallback on earlier versions
                }

                completionHandler(["result": "success"])
            case _:
                return
            }
        })

        // Await established channel
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.migrateFrom_1_3_2()

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

// MARK: - Notification
extension AppDelegate {
    func migrateFrom_1_3_2() {
        if let salvagedValue = UserDefaults.standard.string(forKey: "startSavedDate"), let lastTakenDate = UserDefaults.standard.string(forKey: "savedDate") {
            channel?.invokeMethod("salvagedOldStartTakenDate", arguments: ["salvagedOldStartTakenDate": salvagedValue, "salvagedOldLastTakenDate": lastTakenDate])
        }
    }
}
