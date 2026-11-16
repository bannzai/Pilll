import AppIntents
import UIKit

// 文言は開発言語の日本語で書き、英語は Localizable.xcstrings (title・description・返答) と AppShortcuts.xcstrings (発話) に置く。
//
// Siri AI (iOS 27.3 のベータで開発者向けの先行プレビューが始まった新しい Siri) から呼ばれるための @AppIntent(.tool) は付けていない。
// 付けない理由と付けられるようになる条件は documents/siri-app-intents.md に書いている

/// Dart 側 (lib/native/pill.dart) の AppIntentRecordPillResult の name を読むための型。case の意味は Dart 側の定義が正
private enum RecordPillIntentResult: String {
  case recorded
  case alreadyTaken
  case notPremiumOrTrial
  case noActivePillSheet
  case notSignedIn
  case failed
}

/// Siri・ショートカットアプリから、アプリを開かずに今日のピルの服用を記録する App Intent。
/// 記録は通知の「飲んだ」と同じ Dart 側の処理で行い、記録できたかどうかを言葉で返す
@available(iOS 16.0, *)
struct RecordPillIntent: AppIntent {
  static var title: LocalizedStringResource = "今日のピルを記録"
  static var description = IntentDescription("今日のピルを飲んだことを Pilll に記録します")
  static var openAppWhenRun = false
  // 服用記録を書き込むため、通知の「飲んだ」(AppDelegate の RECORD_PILL) と同じく、ロック中の端末では持ち主のロック解除を求める
  static var authenticationPolicy: IntentAuthenticationPolicy = .requiresAuthentication

  /// 今日の分を 1 回分記録し、結果の返答を返す。冪等ではない (1 日に複数回服用する設定では、呼ぶたびに未服用の 1 回分を記録するため)
  @MainActor
  func perform() async throws -> some IntentResult & ProvidesDialog {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return .result(dialog: recordPillIntentDialog(result: .failed))
    }
    // Dart 側に届かなかった時 (nil) と知らない name は、記録できたと言わないよう失敗として返す
    return .result(
      dialog: recordPillIntentDialog(
        result: await withCheckedContinuation { (continuation: CheckedContinuation<String?, Never>) in
          appDelegate.recordPillFromAppIntent { continuation.resume(returning: $0) }
        }.flatMap(RecordPillIntentResult.init(rawValue:)) ?? .failed
      )
    )
  }
}

/// 服用記録の結果を利用者に伝える返答を返す
@available(iOS 16.0, *)
private func recordPillIntentDialog(result: RecordPillIntentResult) -> IntentDialog {
  switch result {
  case .recorded:
    return "今日のピルを記録しました"
  case .alreadyTaken:
    return "今日のピルはすでに記録済みです"
  case .notPremiumOrTrial:
    return "Siri とショートカットからの記録はプレミアムプランの機能です"
  case .noActivePillSheet:
    return "記録できるピルシートがありません。Pilll でピルシートを追加してください"
  case .notSignedIn:
    return "Pilll を開いて初期設定を済ませてください"
  case .failed:
    return "記録できませんでした。Pilll を開いて記録してください"
  }
}

/// Siri とショートカットアプリに、設定なしで使える Pilll の操作と発話を登録する
@available(iOS 16.0, *)
struct PilllAppShortcutsProvider: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: RecordPillIntent(),
      phrases: [
        "\(.applicationName)で今日のピルを記録",
        "\(.applicationName)でピルを記録",
        "\(.applicationName)でピルを飲んだ",
      ],
      shortTitle: "ピルを記録",
      systemImageName: "pills"
    )
  }
}
