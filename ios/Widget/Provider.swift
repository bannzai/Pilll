import Foundation
import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> Entry {
    .init(date: .now)
  }

  func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
    completion(placeholder(in: context))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let intervalMinute = 15
    let oneDayLoopCount = 24 * (4 * intervalMinute)
    let entries: [Entry] = .init(repeating: .init(date: .now.addingTimeInterval(TimeInterval(intervalMinute * 60))), count: oneDayLoopCount)
    let nextTimelineSchedule = Calendar.current.date(byAdding: .minute, value: intervalMinute, to: .now)!
    let timeline = Timeline(entries: entries, policy: .after(nextTimelineSchedule))
    completion(timeline)
  }
}

