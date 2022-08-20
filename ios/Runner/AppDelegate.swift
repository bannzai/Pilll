import UIKit
import ObjectiveC
import Flutter
import HealthKit
import FirebaseAuth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var channel: FlutterMethodChannel?

    private let teamID = "TQPN82UBBY"
    private var keychainAccessGroup: String { "\(teamID).\(Bundle.main.bundleIdentifier!).keychain" }
    private let isMigratedToSharedKeychainUserDefaultsKey = "isMigratedToSharedKeychainUserDefaultsKey"

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
                completionHandler(["result": "success", "isMigratedSharedKeychain": UserDefaults.standard.bool(forKey: "isMigratedToSharedKeychainUserDefaultsKey")])
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

    private func analytics(name: String, parameters: [String: Any]? = nil, function: StaticString = #function) {
        print(function, name, parameters ?? [:])
        channel?.invokeMethod("analytics", arguments: ["name": name, "parameters": parameters ?? [:]])
    }
}


// MARK: - Keychain migration
private extension AppDelegate {
    // ref: https://firebase.google.com/docs/auth/ios/single-sign-on
    func migrateToSharedKeychain(_completionHandler: @escaping (Dictionary<String, Any>) -> Void) {
        analytics(name: "start_migration")

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
                UserDefaults.standard.set(true, forKey: self.isMigratedToSharedKeychainUserDefaultsKey)
                self.analytics(name: "migration_complete", parameters: ["isSuccess": true])
            } else {
                _completionHandler(["result": "failure", "iOSKeychainMigrateToSharedKeychain": false])
                self.analytics(name: "migration_complete", parameters: ["isSuccess": false])
            }
        }

        // 未ログインユーザーや後続のupdateCurrentUserが異常終了した場合はcurrentUserはnilになる想定
        let currentUser = Auth.auth().currentUser
        if UserDefaults.standard.string(forKey: Const.startMigrateionCurrentUserID) == nil {
            UserDefaults.standard.set(currentUser?.uid, forKey: Const.startMigrateionCurrentUserID)
        }

        // まだ移行してない時に try catchをした場合に返ってくるエラーが code:0, domain: `Foundation._GenericObjCError.nilError`, userInfo: [] という具合でcatchする意味もなさそうだった。エラーの場合は未移行として処理をしてしまう
        let appGroupUser = try? Auth.auth().getStoredUser(forAccessGroup: keychainAccessGroup)
        analytics(name: "migration_users", parameters: ["currentUserID": currentUser?.uid ?? "", "appGroupUserID": appGroupUser?.uid ?? ""])

        // NOTE: switch前のこの場所でAuth.auth().useUserAccessGroup(keychainAccessGroup) を呼ぶのもアリだが、try catch をしなきゃいけないので呼ばなくて良いなら呼ばないようにしている
        switch (currentUser, appGroupUser) {
        case (_?, _?):
            analytics(name: "migration_already_end")
            // すでに移行済み
            completionHandler(true)
        case (nil, _?):
            analytics(name: "maybe_migration_already_end")
            // 移行済みではあるが、何かしらの理由でcurrentUserが取得できない状態。Flutterの方でログイン状態の監視を行なっているので成功にして処理を進める
            completionHandler(true)
        case (nil, nil):
            analytics(name: "no_need_migration")
            // 初期ユーザー。ここではuserAccessGroupの設定だけ行いログインはFlutter側に任せる
            do {
                try Auth.auth().useUserAccessGroup(keychainAccessGroup)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        case (let currentUser?, nil):
            analytics(name: "migrate_from_old_version")

            // 古いユーザーからの移行
            do {
                try Auth.auth().useUserAccessGroup(keychainAccessGroup)
            } catch {
                completionHandler(false)
                return
            }

            Auth.auth().updateCurrentUser(currentUser) { error in
                if let error = error {
                    // ここではfatalErrorにしない。 再起動後にcase (nil, nil) の状態になり新しいユーザーでFlutter側でログインされてしまうため
                    UserDefaults.standard.set(currentUser.uid, forKey: Const.errorUpdateCurrentUserID)
                    UserDefaults.standard.set(error.localizedDescription, forKey: Const.errorUpdateCurrentUserError)
                    self.analytics(name: "update_current_user_is_fail", parameters: ["code": error._code, "domain": error._domain, "error": error.localizedDescription])
                    completionHandler(false)
                } else {
                    self.analytics(name: "update_current_user_is_success")
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
                // よって対処療法的ではあるが、~5~ -> 10秒待つことでほぼ間違いなくmain(の中でもMethodChanelの確立までは)の処理はすべて終えているとしてここではdelayを設けている。
                // ちなみに通常は1秒前後あれば十分であるが念のためくらいの間を持たせている
                // 10秒に伸ばしたのはKeychain移行の処理がクイックレコード後にも走ってしまうので伸ばした
                // TODO: Keychain移行が終わったら5秒に戻す
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
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
