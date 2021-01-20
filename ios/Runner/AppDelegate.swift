import UIKit
import ObjectiveC
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    swizzleNotificationCenterDelegateMethod()
    configureNotificationActionableButtons()
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["repeat_notification_for_taken_pill", "remind_notification_for_taken_pill"])
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["repeat_notification_for_taken_pill", "remind_notification_for_taken_pill"])
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


// MARK: - Notification
extension AppDelegate {
    private func swizzleNotificationCenterDelegateMethod() {
        guard let fromMethod = class_getInstanceMethod(type(of: self), #selector(AppDelegate.userNotificationCenter(_:didReceive:withCompletionHandler:))) else {
            fatalError()
        }
        guard let toMethod = class_getInstanceMethod(type(of: self), #selector(AppDelegate.userNotificationCenter_methodSwizzling(_:didReceive:withCompletionHandler:))) else {
            fatalError()
        }
        
        method_exchangeImplementations(fromMethod, toMethod)
    }

    private func configureNotificationActionableButtons() {
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
            userNotificationCenter_methodSwizzling(center, didReceive: response, withCompletionHandler: completionHandlerWrapper)
            if !isCompleted {
                completionHandler()
            }
        }
        switch extractCategory(userInfo: response.notification.request.content.userInfo) {
        case nil:
            return
        case .pillReminder:
            switch response.actionIdentifier {
            case "RECORD_PILL":
                // NOTE: call flutter record function
                print(response.actionIdentifier)
                break
            default:
                break
            }
        }
    }
   
    enum Category: String {
        case pillReminder = "PILL_REMINDER"
    }

    private func extractCategory(userInfo: [AnyHashable: Any]) -> Category? {
        guard let apns = userInfo["apns"] as? [String: Any], let category = apns["category"] as? String else {
            return nil
        }
        return Category(rawValue: category)
    }
}
