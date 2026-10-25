import AlarmKit
import AppIntents
// このファイルは Widget の target でもコンパイルされる。Widget の target には Firebase の Pod が無いため、Runner の target だけで import する
#if canImport(FirebaseCrashlytics)
import FirebaseCore
import FirebaseCrashlytics
#endif

/// AlarmKit の AppIntent の `alarmID` が UUID として読めなかったことを Crashlytics の non-fatal として記録する。
/// 空の `alarmID` の intent が実行される経路を後から調べるために、`alarmID` の値と intent の型名を残す。
/// Widget の target と、Flutter の plugin の登録で FirebaseApp が設定される前に呼ばれた時は記録しない
/// (FirebaseApp の設定前に Crashlytics を呼ぶと例外で落ちるため)
private func recordInvalidAlarmID(alarmID: String, intentTypeName: String) {
#if canImport(FirebaseCrashlytics)
  guard FirebaseApp.app() != nil else {
    return
  }
  Crashlytics.crashlytics().record(
    error: NSError(
      domain: "\(intentTypeName).invalidAlarmID",
      code: 0,
      userInfo: ["alarmID": alarmID]
    )
  )
#endif
}

@available(iOS 26.0, *)
struct MedicationReminderIntent: AppIntent, LiveActivityIntent {
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

@available(iOS 26.0, *)
struct OpenAlarmAppIntent: LiveActivityIntent {
  func perform() throws -> some IntentResult {
    guard let alarmUUID = UUID(uuidString: alarmID) else {
      recordInvalidAlarmID(alarmID: alarmID, intentTypeName: "OpenAlarmAppIntent")
      return .result()
    }
    try AlarmManager.shared.stop(id: alarmUUID)
    return .result()
  }

  static var title: LocalizedStringResource = "Open Pilll"
  static var description = IntentDescription("Opens the Pilll")
  static var openAppWhenRun = true

  @Parameter(title: "alarmID")
  var alarmID: String

  init(alarmID: String) {
    self.alarmID = alarmID
  }

  init() {
    self.alarmID = ""
  }
}


@available(iOS 26.0, *)
struct RepeatIntent: LiveActivityIntent {
  func perform() throws -> some IntentResult {
    guard let alarmUUID = UUID(uuidString: alarmID) else {
      recordInvalidAlarmID(alarmID: alarmID, intentTypeName: "RepeatIntent")
      return .result()
    }
    try AlarmManager.shared.countdown(id: alarmUUID)
    return .result()
  }

  static var title: LocalizedStringResource = "繰り返す"
  static var description = IntentDescription("カウントダウンを繰り返す")

  @Parameter(title: "alarmID")
  var alarmID: String

  init(alarmID: String) {
    self.alarmID = alarmID
  }

  init() {
    self.alarmID = ""
  }
}
