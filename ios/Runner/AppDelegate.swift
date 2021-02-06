import UIKit
import ObjectiveC
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let channelName = "method.channel.MizukiOhashi.Pilll"
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.migrateFrom_1_3_2()
        }
        swizzleNotificationCenterDelegateMethod()
        configureNotificationActionableButtons()
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["repeat_notification_for_taken_pill", "remind_notification_for_taken_pill"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["repeat_notification_for_taken_pill", "remind_notification_for_taken_pill"])
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

// MARK: - Internal
extension AppDelegate {
    func call(method: String, arguments: [String: Any]?) {
        let viewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "method.channel.MizukiOhashi.Pilll",
            binaryMessenger: viewController.binaryMessenger
        )
        channel.invokeMethod(method, arguments: arguments)
    }
}


// MARK: - Notification
extension AppDelegate {
    func migrateFrom_1_3_2() {
        if let salvagedValue = UserDefaults.standard.string(forKey: "startSavedDate"), let lastTakenDate = UserDefaults.standard.string(forKey: "savedDate") {
            call(method: "salvagedOldStartTakenDate", arguments: ["salvagedOldStartTakenDate": salvagedValue, "salvagedOldLastTakenDate": lastTakenDate])
        }
    }
    func swizzleNotificationCenterDelegateMethod() {
        guard let fromMethod = class_getInstanceMethod(type(of: self), #selector(AppDelegate.userNotificationCenter(_:didReceive:withCompletionHandler:))) else {
            fatalError()
        }
        guard let toMethod = class_getInstanceMethod(type(of: self), #selector(AppDelegate.userNotificationCenter_methodSwizzling(_:didReceive:withCompletionHandler:))) else {
            fatalError()
        }
        
        method_exchangeImplementations(fromMethod, toMethod)
    }

    func configureNotificationActionableButtons() {
        let recordAction = UNNotificationAction(identifier: "RECORD_PILL",
                                                title: "飲んだ",
                                                options: UNNotificationActionOptions(rawValue: 0))
        let category =
            UNNotificationCategory(identifier: Category.pillReminder.rawValue,
                                   actions: [recordAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([category])
    }

    @objc func userNotificationCenter_methodSwizzling(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer {
            var isCompleted: Bool = false
            let completionHandlerWrapper = {
                isCompleted = true
                completionHandler()
            }
            // NOTE: すぐにcallbackした場合、Flutterからfirestoreにリクエストを送っている途中でプロセスが終了している疑惑がある。
            // それで、雑だけど10秒くらいあとにcompletionHandlerを呼ぶことにした
            // ちなみにリミットは30秒以内にcompletionを呼ぶ:  https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/pushing_background_updates_to_your_app
            // なおバッジはすぐに消しても良いと判断して消した
            UIApplication.shared.applicationIconBadgeNumber = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.userNotificationCenter_methodSwizzling(center, didReceive: response, withCompletionHandler: completionHandlerWrapper)
                if !isCompleted {
                    completionHandlerWrapper()
                }
            }
        }
        switch extractCategory(userInfo: response.notification.request.content.userInfo) {
        case nil:
            return
        case .pillReminder:
            switch response.actionIdentifier {
            case "RECORD_PILL":
                call(method: "recordPill", arguments: nil)
                break
            default:
                break
            }
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
