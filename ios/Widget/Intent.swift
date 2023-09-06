import SwiftUI
import AppIntents

struct SampleIntent: AppIntent {
  static var title: LocalizedStringResource = "Intent Name"

  func perform() async throws -> some IntentResult {
    return .result()
  }
}
