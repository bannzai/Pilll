#if canImport(AlarmKit)
import AlarmKit
#endif
import AppIntents

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
    try AlarmManager.shared.stop(id: UUID(uuidString: alarmID)!)
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
    try AlarmManager.shared.countdown(id: UUID(uuidString: alarmID)!)
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
