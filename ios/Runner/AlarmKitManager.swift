import Foundation
import AppIntents
#if canImport(AlarmKit)
import AlarmKit
#endif
import SwiftUI

/// AlarmKit機能へのアクセスを提供するマネージャークラス
///
/// iOS 26+でのみ利用可能なAlarmKitの機能をネイティブ側で管理します。
/// Pilllアプリの服薬リマインダーをサイレントモード・フォーカスモード時でも確実に表示するために使用します。
class AlarmKitManager {
  static let shared = AlarmKitManager()
  private init() {}

  @available(iOS 26.0, *)
  typealias AlarmConfiguration = AlarmManager.AlarmConfiguration<AppAlarmMetadata>

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

  /// AlarmKitの認証状態を取得する
  ///
  /// 現在のAlarmKitの認証状態を確認します。
  /// UI表示に応じて適切な状態を返します。
  ///
  /// Returns: 現在の認証状態（"authorized", "denied", "notDetermined", "notAvailable"）
  func getAuthorizationStatus() -> String {
    guard #available(iOS 26.0, *) else {
      return "notAvailable"
    }

    switch AlarmManager.shared.authorizationState {
    case .authorized:
      return "authorized"
    case .denied:
      return "denied"
    case .notDetermined:
      return "notDetermined"
    @unknown default:
      return "notDetermined"
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
  func scheduleMedicationAlarm(
    localNotificationID: String,
    title: String,
    scheduledTime: Date
  ) async throws {
    guard #available(iOS 26.0, *) else {
      throw AlarmKitError.notAvailable
    }

    let alarmID = UUID()
    let alertContent = AlarmPresentation.Alert(
      title: LocalizedStringResource(stringLiteral: title),
      stopButton: .openAppButton,
      secondaryButton: nil,
      secondaryButtonBehavior: nil,
    )
//    let countdownContent = AlarmPresentation.Countdown(title: "Pilll:服薬時間です", pauseButton: .pauseButton)
//    let pausedContent = AlarmPresentation.Paused(title: "一時停止中", resumeButton: .resumeButton)
    let alarmPresentation = AlarmPresentation(alert: alertContent)

    let attributes = AlarmAttributes(
      presentation: alarmPresentation,
      metadata: AppAlarmMetadata(localNotificationID: localNotificationID, title: title),
      tintColor: Color(.appSecondary),
    )

    let configuration = AlarmConfiguration.alarm(
      schedule: .fixed(scheduledTime),
      attributes: attributes,
      stopIntent: OpenAlarmAppIntent(alarmID: alarmID.uuidString),
    )

    _ = try await AlarmManager.shared.schedule(id: alarmID, configuration: configuration)
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

    for alarm in try AlarmManager.shared.alarms {
      try AlarmManager.shared.cancel(id: alarm.id)
    }
  }

  /// すべてのアラームを停止する
  ///
  /// 現在鳴っているすべてのAlarmKitアラームを停止します。
  /// アラーム音を止めたい場合に使用します。
  ///
  /// - Throws: アラーム停止に失敗した場合Exception
  func stopAllAlarms() async throws {
    guard #available(iOS 26.0, *) else {
      throw AlarmKitError.notAvailable
    }

    for alarm in try AlarmManager.shared.alarms {
      try AlarmManager.shared.stop(id: alarm.id)
    }
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

@available(iOS 26.0, *)
extension AlarmButton {
  static var openAppButton: Self {
    AlarmButton(text: "Pilllを開く", textColor: Color(.appPrimary), systemImageName: "pill")
  }
}

@available(iOS 26.0, *)
struct AppAlarmMetadata: AlarmMetadata {
  let localNotificationID: String
  let title: String
}
