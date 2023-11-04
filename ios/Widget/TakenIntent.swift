import SwiftUI
import AppIntents

@available(iOS 17, *)
public struct TakenIntent: AppIntent {
  static public var title: LocalizedStringResource = "服用済みにする"

  @Parameter(title: "Widget URI")
  var url: URL?

  @Parameter(title: "AppGroup")
  var appGroup: String?

  public init() {}

  public init(url: URL?, appGroup: String?) {
    self.url = url
    self.appGroup = appGroup
  }

  public func perform() async throws -> some IntentResult {
    HomeWidgetBackgroundWorker.run(url: url, appGroup: appGroup)
    try? await Task.sleep(nanoseconds: 5 * 100_000_000)

    return .result()
  }
}


/// This is required if you want to have the widget be interactive even when the app is fully suspended.
/// Note that this will launch your App so on the Flutter side you should check for the current Lifecycle State before doing heavy tasks
@available(iOS 17, *)
@available(iOSApplicationExtension, unavailable)
extension TakenIntent: ForegroundContinuableIntent {}
