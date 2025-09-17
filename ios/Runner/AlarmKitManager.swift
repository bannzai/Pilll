import Foundation
import AlarmKit

/// AlarmKit機能へのアクセスを提供するマネージャークラス
///
/// iOS 26+でのみ利用可能なAlarmKitの機能をネイティブ側で管理します。
/// Pilllアプリの服薬リマインダーをサイレントモード・フォーカスモード時でも確実に表示するために使用します。
class AlarmKitManager {
    static let shared = AlarmKitManager()
    private init() {}
    
    /// AlarmKitが現在のOS版で利用可能かどうかを確認する
    ///
    /// Returns: iOS 26+でtrueを返します。それ以外のバージョンではfalseです。
    func isAvailableForCurrentOS() -> Bool {
        if #available(iOS 26.0, *) {
            return true
        } else {
            return false
        }
    }
    
    /// AlarmKitの権限をリクエストする
    ///
    /// iOS 26+でAlarmKitの使用許可をユーザーに求めます。
    /// アラーム機能を初めて使用する際に呼び出す必要があります。
    ///
    /// Returns: 権限が許可された場合true、拒否された場合false
    func requestPermission() async -> Bool {
        guard #available(iOS 26.0, *) else {
            return false
        }
        
        do {
            let authorization = try await AlarmManager.shared.requestAuthorization()
            return authorization == .authorized
        } catch {
            print("AlarmKit permission request error: \(error)")
            return false
        }
    }
    
    /// 服薬リマインダーアラームを登録する
    ///
    /// AlarmKitを使用して指定時刻に服薬リマインダーを表示します。
    /// サイレントモード・フォーカスモード時でも確実に表示されます。
    ///
    /// - Parameters:
    ///   - id: アラームの一意識別子（通知IDと同じ形式）
    ///   - title: アラームに表示するタイトル
    ///   - scheduledTime: アラームを表示する日時
    ///
    /// - Throws: アラーム登録に失敗した場合Exception
    func scheduleMedicationAlarm(id: String, title: String, scheduledTime: Date) async throws {
        guard #available(iOS 26.0, *) else {
            throw AlarmKitError.notAvailable
        }
        
        let configuration = AlarmConfiguration(
            id: id,
            scheduledTime: scheduledTime,
            title: title,
            intent: MedicationReminderIntent(id: id, title: title)
        )
        
        try await AlarmManager.shared.schedule(configuration)
    }
    
    /// すべての服薬リマインダーアラームを解除する
    ///
    /// 現在登録されているすべてのAlarmKitアラームを解除します。
    /// LocalNotificationと同様に全解除してから新規登録する方式で使用します。
    ///
    /// - Throws: アラーム解除に失敗した場合Exception
    func cancelAllMedicationAlarms() async throws {
        guard #available(iOS 26.0, *) else {
            throw AlarmKitError.notAvailable
        }
        
        let alarms = await AlarmManager.shared.alarms
        for alarm in alarms {
            try await AlarmManager.shared.cancel(id: alarm.id)
        }
    }
    
    /// アラームを停止する
    ///
    /// 現在表示されているアラームを停止します。
    /// アラーム画面の停止ボタンから呼び出される処理です。
    ///
    /// - Parameter id: 停止するアラームの識別子
    func stopAlarm(id: String) async throws {
        guard #available(iOS 26.0, *) else {
            throw AlarmKitError.notAvailable
        }
        
        try await AlarmManager.shared.stop(id: id)
    }
}

/// AlarmKit関連のエラー
enum AlarmKitError: Error, LocalizedError {
    case notAvailable
    case permissionDenied
    case schedulingFailed(String)
    case cancellationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "AlarmKit is not available on this OS version"
        case .permissionDenied:
            return "AlarmKit permission was denied"
        case .schedulingFailed(let reason):
            return "Failed to schedule alarm: \(reason)"
        case .cancellationFailed(let reason):
            return "Failed to cancel alarm: \(reason)"
        }
    }
}

/// 服薬リマインダーのApp Intent
@available(iOS 26.0, *)
struct MedicationReminderIntent: AppIntent {
    static var title: LocalizedStringResource = "Medication Reminder"
    static var description = IntentDescription("Reminds you to take your medication")
    
    @Parameter(title: "Alarm ID")
    var id: String
    
    @Parameter(title: "Title")
    var title: String
    
    init() {
        self.id = ""
        self.title = ""
    }
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    func perform() async throws -> some IntentResult {
        // アラームが鳴った時の処理
        // 必要に応じてアプリを開くなどの処理を追加
        return .result()
    }
}
