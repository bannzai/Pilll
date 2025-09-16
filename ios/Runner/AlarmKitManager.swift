import SwiftUI
import AlarmKit
import AppIntents
import Foundation

// MARK: - AlarmKitManager
class AlarmKitManager {
  static let shared = AlarmKitManager()
  
  private init() {}
  
  // iOS 26+ 判定
  @available(iOS 26.0, *)
  func isAvailable() -> Bool {
    return true
  }
  
  func isAvailableForCurrentOS() -> Bool {
    if #available(iOS 26.0, *) {
      return true
    }
    return false
  }
  
  // 権限リクエスト
  @available(iOS 26.0, *)
  func requestPermission() async -> Bool {
    do {
      let authorized = try await AlarmManager.shared.requestAuthorization()
      return authorized
    } catch {
      print("AlarmKit authorization failed: \(error)")
      return false
    }
  }
  
  // 権限確認
  @available(iOS 26.0, *)
  func checkPermission() async -> Bool {
    let status = await AlarmManager.shared.authorizationStatus()
    return status == .authorized
  }
  
  // 服薬アラーム登録
  @available(iOS 26.0, *)
  func scheduleMedicationAlarm(
    id: String,
    title: String,
    scheduledTime: Date
  ) async throws {
    
    let alarmID = UUID(uuidString: id) ?? UUID()
    
    let attributes = AlarmAttributes(
      presentation: createAlarmPresentation(title: title),
      metadata: MedicationAlarmMetadata(
        alarmID: id,
        title: title,
        scheduledTime: scheduledTime
      ),
      tintColor: Color.blue
    )
    
    let alarmConfiguration = AlarmManager.AlarmConfiguration<MedicationAlarmMetadata>.schedule(
      date: scheduledTime,
      attributes: attributes,
      stopIntent: StopMedicationAlarmIntent(alarmID: id),
      secondaryIntent: OpenPilllAppIntent(alarmID: id)
    )
    
    do {
      let alarm = try await AlarmManager.shared.schedule(
        id: alarmID,
        configuration: alarmConfiguration
      )
      print("Medication alarm scheduled: \(alarm)")
    } catch {
      print("Failed to schedule medication alarm: \(error)")
      throw error
    }
  }
  
  // アラーム解除
  @available(iOS 26.0, *)
  func cancelMedicationAlarm(id: String) async throws {
    guard let alarmID = UUID(uuidString: id) else {
      throw AlarmKitError.invalidID
    }
    
    do {
      try await AlarmManager.shared.remove(id: alarmID)
      print("Medication alarm cancelled: \(id)")
    } catch {
      print("Failed to cancel medication alarm: \(error)")
      throw error
    }
  }
  
  // アラーム停止
  @available(iOS 26.0, *)
  func stopAlarm(id: String) async throws {
    guard let alarmID = UUID(uuidString: id) else {
      throw AlarmKitError.invalidID
    }
    
    do {
      try await AlarmManager.shared.stop(id: alarmID)
      print("Medication alarm stopped: \(id)")
    } catch {
      print("Failed to stop medication alarm: \(error)")
      throw error
    }
  }
  
  // AlarmPresentation作成
  @available(iOS 26.0, *)
  private func createAlarmPresentation(title: String) -> AlarmPresentation {
    let alertContent = AlarmPresentation.Alert(
      title: LocalizedStringResource(stringLiteral: title),
      stopButton: .stopButton,
      secondaryButton: .openAppButton,
      secondaryButtonBehavior: .custom
    )
    
    return AlarmPresentation(alert: alertContent)
  }
}

// MARK: - Metadata
struct MedicationAlarmMetadata: Codable, Hashable {
  let alarmID: String
  let title: String
  let scheduledTime: Date
}

// MARK: - App Intents
@available(iOS 26.0, *)
struct StopMedicationAlarmIntent: LiveActivityIntent {
  static var title: LocalizedStringResource = "Stop Medication Alarm"
  static var description: IntentDescription = "Stops the medication alarm"
  
  @Parameter(title: "Alarm ID")
  var alarmID: String
  
  func perform() async throws -> some IntentResult {
    // アラーム停止処理
    try await AlarmKitManager.shared.stopAlarm(id: alarmID)
    return .result()
  }
}

@available(iOS 26.0, *)
struct OpenPilllAppIntent: LiveActivityIntent {
  static var title: LocalizedStringResource = "Open Pilll App"
  static var description: IntentDescription = "Opens the Pilll app"
  
  @Parameter(title: "Alarm ID")
  var alarmID: String
  
  func perform() async throws -> some IntentResult {
    // アプリを開く処理は自動的に行われる
    return .result()
  }
}

// MARK: - Errors
enum AlarmKitError: Error {
  case invalidID
  case permissionDenied
  case schedulingFailed
  
  var localizedDescription: String {
    switch self {
    case .invalidID:
      return "Invalid alarm ID"
    case .permissionDenied:
      return "AlarmKit permission denied"
    case .schedulingFailed:
      return "Failed to schedule alarm"
    }
  }
}