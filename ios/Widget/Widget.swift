import WidgetKit
import SwiftUI
import Intents

fileprivate var calendar: Calendar {
  var calendar = Calendar(identifier: .gregorian)
  calendar.locale = .autoupdatingCurrent
  calendar.timeZone = .autoupdatingCurrent
  return calendar
}

fileprivate var dateFormater: DateFormatter {
  let dateFormater = DateFormatter()
  dateFormater.locale = .autoupdatingCurrent
  dateFormater.timeZone = .autoupdatingCurrent
  return dateFormater
}

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

struct Entry: TimelineEntry {
  // Timeline Entry required property
  let date: Date

  // PillSheet property
  let pillSheetTodayPillNumber: Int?
  let pillSheetGroupTodayPillNumber: Int?
  let pillSheetEndDisplayPillNumber: Int?
  let pillSheetLastTakenDate: Date?

  // Setting property
  var settingPillSheetAppearanceMode: String = "number"

  // Timestamp
  let pillSheetValueLastUpdateDateTime: Date?

  init(date: Date) {
    self.date = date

    func contains(_ key: String) -> Bool {
      UserDefaults(suiteName: Plist.appGroupKey)?.dictionaryRepresentation().keys.contains(key) == true
    }

    if contains(Const.pillSheetTodayPillNumber), let pillSheetTodayPillNumber = UserDefaults(suiteName: Plist.appGroupKey)?.integer(forKey: Const.pillSheetTodayPillNumber) {
      self.pillSheetTodayPillNumber = pillSheetTodayPillNumber
    } else {
      self.pillSheetTodayPillNumber = nil
    }

    if contains(Const.pillSheetGroupTodayPillNumber), let pillSheetGroupTodayPillNumber = UserDefaults(suiteName: Plist.appGroupKey)?.integer(forKey: Const.pillSheetGroupTodayPillNumber) {
      self.pillSheetGroupTodayPillNumber = pillSheetGroupTodayPillNumber
    } else {
      self.pillSheetGroupTodayPillNumber = nil
    }

    if contains(Const.pillSheetEndDisplayPillNumber), let pillSheetEndDisplayPillNumber = UserDefaults(suiteName: Plist.appGroupKey)?.integer(forKey: Const.pillSheetEndDisplayPillNumber) {
      self.pillSheetEndDisplayPillNumber = pillSheetEndDisplayPillNumber
    } else {
      self.pillSheetEndDisplayPillNumber = nil
    }

    if contains(Const.pillSheetLastTakenDate), let pillSheetLastTakenDateEpochMilliSecond = UserDefaults(suiteName: Plist.appGroupKey)?.integer(forKey: Const.pillSheetLastTakenDate) {
      self.pillSheetLastTakenDate = Date(timeIntervalSince1970: TimeInterval(pillSheetLastTakenDateEpochMilliSecond / 1000))
    } else {
      self.pillSheetLastTakenDate = nil
    }

    if contains(Const.settingPillSheetAppearanceMode), let settingPillSheetAppearanceMode = UserDefaults(suiteName: Plist.appGroupKey)?.string(forKey: Const.settingPillSheetAppearanceMode) {
      self.settingPillSheetAppearanceMode = settingPillSheetAppearanceMode
    }

    if contains(Const.pillSheetValueLastUpdateDateTime), let pillSheetValueLastUpdateDateTimeEpochMilliSecond = UserDefaults(suiteName: Plist.appGroupKey)?.integer(forKey: Const.pillSheetValueLastUpdateDateTime) {
      self.pillSheetValueLastUpdateDateTime = Date(timeIntervalSince1970: TimeInterval(pillSheetValueLastUpdateDateTimeEpochMilliSecond / 1000))
    } else {
      self.pillSheetValueLastUpdateDateTime = nil
    }
  }

  var todayPillNumber: Int? {
    guard
      let recordedpillSheetGroupTodayPillNumber = pillSheetGroupTodayPillNumber,
      let pillSheetValueLastUpdateDateTime = pillSheetValueLastUpdateDateTime else {
      return nil
    }
    guard let diff = calendar.dateComponents([.day], from: date, to: pillSheetValueLastUpdateDateTime).day else {
      return recordedpillSheetGroupTodayPillNumber
    }
    let todayPillNumber = recordedpillSheetGroupTodayPillNumber + diff

    if let pillSheetEndDisplayPillNumber = pillSheetEndDisplayPillNumber, todayPillNumber > pillSheetEndDisplayPillNumber {
      // 更新されるまで常に1で良い
      return 1
    } else {
      return todayPillNumber
    }
  }

}

struct WidgetEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    if UserDefaults(suiteName: Plist.appGroupKey)?.bool(forKey: Const.userIsPremiumOrTrial) == true {
      VStack {
        HStack(alignment: .top) {
          VStack(spacing: 0) {
            Text(weekday)
              .foregroundColor(.mainText)
              .font(.system(size: 12))
              .fontWeight(.medium)

            Text("\(day)")
              .foregroundColor(.black)
              .font(.system(size: 36))
              .fontWeight(.regular)
          }

          Spacer()

          Image("pilll-widget-icon")
            .frame(width: 11, height: 16)
        }

        Spacer()

        if let todayPillNumber = entry.todayPillNumber {
          HStack {
            HStack(spacing: 6) {
              Divider()
                .frame(width: 4)
                .overlay(Color.primary)
                .cornerRadius(2)

              VStack(alignment: .leading, spacing: 2) {
                Text(displayTodayPillNumber(todayPillNumber: todayPillNumber, appearanceMode: entry.settingPillSheetAppearanceMode))
                  .foregroundColor(.mainText)
                  .font(.system(size: 15))
                  .fontWeight(.semibold)

                if alreadyTaken {
                  Text("服用済み")
                    .foregroundColor(.mainText)
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                }
              }
            }

            Spacer()

            if alreadyTaken {
              Image("check-icon-on")
                .frame(width: 32, height: 32)
                .shadow(color: Color(red: 78 / 255, green: 98 / 255, blue: 135 / 255, opacity: 0.4), radius: 5, x: 0, y: 2)
            }
          }
          .frame(maxHeight: 40)
        } else {
          HStack {
            HStack(spacing: 6) {
              Divider()
                .frame(width: 4)
                .overlay(Color(red: 190 / 255, green: 192 / 255, blue: 194 / 255))
                .cornerRadius(2)

              VStack(alignment: .leading, spacing: 2) {
                Text("シートがありません")
                  .foregroundColor(.orange)
                  .font(.system(size: 12))
                  .fontWeight(.medium)
                  .background(Color(red: 230 / 255, green: 94 / 255, blue: 90 / 255, opacity: 0.1))
              }
            }

            Spacer()
          }
          .frame(maxHeight: 40)
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 15)
      .background(Color.white)
    } else {
      VStack {
        HStack {
          Spacer()
          Image("pilll-widget-icon")
            .frame(width: 11, height: 16, alignment: .topTrailing)
            .padding(.horizontal, 8)
        }
        Spacer()
        Text("プレミアムユーザーのみご利用できます")
          .foregroundColor(.gray)

        Spacer()
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 15)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.white)
    }
  }

  private var weekday: String {
    dateFormater.weekdaySymbols[calendar.component(.weekday, from: entry.date) - 1]
  }

  private var day: Int {
    calendar.component(.day, from: entry.date)
  }

  private var alreadyTaken: Bool {
    guard let pillSheetLastTakenDate = entry.pillSheetLastTakenDate else {
      return false
    }
    return calendar.isDate(entry.date, inSameDayAs: pillSheetLastTakenDate)
  }

  private func displayTodayPillNumber(todayPillNumber: Int, appearanceMode: String) -> String {
    switch appearanceMode {
    case "number":
      return "\(todayPillNumber)番"
    case "date":
      return "\(todayPillNumber)番"
    case "sequential":
      return "\(todayPillNumber)日目"
    case _:
      return ""
    }
  }
}

extension Color {
  static let primary: Color = .init(red: 78 / 255, green: 98 / 255, blue: 135 / 255)
  static let orange: Color = .init(red: 229 / 255, green: 106 / 255, blue: 69 / 255)
  static let mainText: Color = .init(red: 41 / 255, green: 48 / 255, blue: 77 / 255, opacity: 0.87)
}

@main
struct Entrypoint: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: Const.widgetKind, provider: Provider()) { entry in
      WidgetEntryView(entry: entry)
    }
    .supportedFamilies([.systemSmall])
    .configurationDisplayName("今日飲むピルが一目でわかる")
    .description("This is a Pilll widget")
  }
}

struct Widget_Previews: PreviewProvider {
  static var previews: some View {
    WidgetEntryView(entry: .init(date: .now))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}

