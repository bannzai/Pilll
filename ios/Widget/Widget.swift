import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    typealias Entry = PillSheetEntry

    func placeholder(in context: Context) -> Entry {
        .init(date: .now, pillSheetBeginDate: .now, pillSheetLastTakenDate: nil, pillSheetCurrentStatus: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [PillSheetEntry] = [.init(date: .now, pillSheetBeginDate: .now, pillSheetLastTakenDate: nil, pillSheetCurrentStatus: "")]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct PillSheetEntry: TimelineEntry {
    // Timeline Entry required property
    let date: Date

    // PillSheet property
    let pillSheetBeginDate: Date
    let pillSheetLastTakenDate: Date?
    let pillSheetCurrentStatus: String
}

struct WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("Hello")
    }
}

@main
struct Entrypoint: Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .description("This is an Pilll widget")
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: .init(date: .now, pillSheetBeginDate: .now, pillSheetLastTakenDate: nil, pillSheetCurrentStatus: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

