import WidgetKit
import SwiftUI

@main
struct AlarmLiveActivityBundle: WidgetBundle {
  var body: some Widget {
    HomeWidget()
    if #available(iOS 26.0, *) {
      AlarmLiveActivityWidget()
    }
  }
}
