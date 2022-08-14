import UIKit
import ObjectiveC
import Flutter
import HealthKit
import FirebaseAuth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var channel: FlutterMethodChannel?

    private let teamID = "TQPN82UBBY"
    private var keychainAccessGroup: String { "\(teamID).\(Bundle.main.bundleIdentifier!)" }

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
            case "isAuthorizedReadAndShareToHealthKitData":
                isAuthorizedReadAndShareToHealthKitData { result in
                    switch result {
                    case .success(let isAuthorized):
                        completionHandler([
                            "result": "success",
                            "isAuthorizedReadAndShareToHealthKitData": isAuthorized
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
            case "isMigratedSharedKeychain":
                do {
                    let appGroupUser = try Auth.auth().getStoredUser(forAccessGroup: self.keychainAccessGroup)
                    completionHandler(["result": "success", "isMigratedSharedKeychain": true])
                } catch {
                    fatalError("get user from access group \(error)")
                }
            case "iOSKeychainMigrateToSharedKeychain":
                self.migrateToSharedKeychain(_completionHandler: completionHandler)
            case _:
                return
            }
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.migrateFrom_1_3_2()
        }
        configureNotificationActionableButtons()
        UNUserNotificationCenter.current().swizzle()
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["repeat_notification_for_taken_pill", "remind_notification_for_taken_pill"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["repeat_notification_for_taken_pill", "remind_notification_for_taken_pill"])
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


// MARK: - Keychain migration
private extension AppDelegate {
    // ref: https://firebase.google.com/docs/auth/ios/single-sign-on
    func migrateToSharedKeychain(_completionHandler: @escaping (Dictionary<String, Any>) -> Void) {
        // 調査用
        enum Const {
            static let startMigrateionCurrentUserID = "startMigrateionCurrentUserID"
            static let errorUpdateCurrentUserID = "errorUpdateCurrentUserID"
            static let errorUpdateCurrentUserError = "errorUpdateCurrentUserError"
        }
        let completionHandler: (Bool) -> Void = { isMigrated in
            if isMigrated {
                _completionHandler(["result": "success", "iOSKeychainMigrateToSharedKeychain": true])
                UserDefaults.standard.removeObject(forKey: Const.startMigrateionCurrentUserID)
                UserDefaults.standard.removeObject(forKey: Const.errorUpdateCurrentUserID)
                UserDefaults.standard.removeObject(forKey: Const.errorUpdateCurrentUserError)
            } else {
                _completionHandler(["result": "failure", "iOSKeychainMigrateToSharedKeychain": false])
            }
        }

        // 未ログインユーザーやupdateCurrentUserが異常終了した場合はcurrentUserはnilになる
        let currentUser = Auth.auth().currentUser
        if UserDefaults.standard.string(forKey: Const.startMigrateionCurrentUserID) == nil {
            UserDefaults.standard.set(currentUser?.uid, forKey: Const.startMigrateionCurrentUserID)
        }

        let appGroupUser: User?
        do {
            appGroupUser = try Auth.auth().getStoredUser(forAccessGroup: keychainAccessGroup)
        } catch {
            fatalError("get user from access group \(error)")
        }

        switch (currentUser, appGroupUser) {
        case (let currentUser?, let appGroupUser?):
            // すでに移行済み
            completionHandler(true)
        case (nil, let appGroupUser?):
            // 移行済みではあるが、何かしらの理由でcurrentUserが取得できない状態。Flutterの方でログイン状態の監視を行なっているので成功にして処理を進める
            completionHandler(true)
        case (nil, nil):
            // 初期ユーザー。ここではuserAccessGroupの設定だけ行いログインはFlutter側に任せる
            do {
                try Auth.auth().useUserAccessGroup(keychainAccessGroup)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        case (let currentUser?, nil):
            // 古いユーザーからの移行
            do {
                try Auth.auth().useUserAccessGroup(keychainAccessGroup)
            } catch {
                fatalError("Error changing user access group: \(error)")
            }

            Auth.auth().updateCurrentUser(currentUser) { error in
                if error != nil {
                    // ここではfatalErrorにしない。 再起動後にcase (nil, nil) の状態になり新しいユーザーでFlutter側でログインされてしまうため
                    UserDefaults.standard.set(currentUser.uid, forKey: Const.errorUpdateCurrentUserID)
                    UserDefaults.standard.set(error?.localizedDescription, forKey: Const.errorUpdateCurrentUserError)
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            }
        }
    }
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
    func migrateFrom_1_3_2() {
        if let salvagedValue = UserDefaults.standard.string(forKey: "startSavedDate"), let lastTakenDate = UserDefaults.standard.string(forKey: "savedDate") {
            channel?.invokeMethod("salvagedOldStartTakenDate", arguments: ["salvagedOldStartTakenDate": salvagedValue, "salvagedOldLastTakenDate": lastTakenDate])
        }
    }

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

        switch extractCategory(userInfo: response.notification.request.content.userInfo) {
        case nil:
            return
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
