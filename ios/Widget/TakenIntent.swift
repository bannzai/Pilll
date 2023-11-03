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
    await HomeWidgetBackgroundWorker.run(url: url, appGroup: appGroup!)

    return .result()
  }
}
