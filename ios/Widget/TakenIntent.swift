import SwiftUI
import AppIntents

@available(iOS 17, *)
struct TakenIntent: AppIntent {
  static public var title: LocalizedStringResource = "服用済みにする"

  let alreadyTaken: Bool
  init() {
    self.alreadyTaken = false
  }
  init(alreadyTaken: Bool) {
    self.alreadyTaken = alreadyTaken
  }

  public func perform() async throws -> some IntentResult {
    if alreadyTaken {
      HomeWidgetBackgroundWorker.debug = ""
    } else {
      try await HomeWidgetBackgroundWorker.run()
      try? await Task.sleep(nanoseconds: 5 * 100_000_000)
    }

    return .result()
  }
}


/// This is required if you want to have the widget be interactive even when the app is fully suspended.
/// Note that this will launch your App so on the Flutter side you should check for the current Lifecycle State before doing heavy tasks
@available(iOS 17, *)
@available(iOSApplicationExtension, unavailable)
extension TakenIntent: ForegroundContinuableIntent {}
