import WidgetKit
import SwiftUI
import Intents

struct HomeWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: Const.widgetKind, provider: Provider()) { entry in
      WidgetEntryView(entry: entry)
    }
    .supportedFamilies(supportedFamilies)
    .configurationDisplayName("今日飲むピルが一目でわかる")
    .description("This is a Pilll widget")
    .contentMarginsDisabled()
  }

  private var supportedFamilies: [WidgetFamily] {
    if #available(iOSApplicationExtension 16.0, *) {
      return [.systemSmall, .accessoryCircular]
    } else {
      return [.systemSmall]
    }
  }
}

struct WidgetEntryView : View {
  @Environment(\.widgetFamily) var widgetFamily

  var entry: Provider.Entry

  var body: some View {
    Group {
      switch widgetFamily {
      case .systemSmall:
        SmallWidget(entry: entry)
      case .accessoryCircular:
        AccessoryCircularWidget(entry: entry)
      case _:
        fatalError()
      }
    }
    .widgetBackground(Color.white)
  }
}

struct Widget_Previews: PreviewProvider {
  static var previews: some View {
    WidgetEntryView(entry: .init(date: .now))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}

