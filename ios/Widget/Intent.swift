import SwiftUI
import AppIntents

@available(iOSApplicationExtension 17, *)
struct SampleIntent: AppIntent {
  static var title: LocalizedStringResource = "Intent Name"

  func perform() async throws -> some IntentResult {
    return .result()
  }
}
