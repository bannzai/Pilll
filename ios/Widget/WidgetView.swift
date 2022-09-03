import SwiftUI

protocol WidgetView: View {
  var entry: Entry { get }
}

extension WidgetView {
  var weekday: String {
    dateFormater.weekdaySymbols[calendar.component(.weekday, from: entry.date) - 1]
  }

  var day: Int {
    calendar.component(.day, from: entry.date)
  }

  var alreadyTaken: Bool {
    guard let pillSheetLastTakenDate = entry.pillSheetLastTakenDate else {
      return false
    }
    return calendar.isDate(entry.date, inSameDayAs: pillSheetLastTakenDate)
  }

  func displayTodayPillNumber(todayPillNumber: Int, appearanceMode: Entry.SettingPillSheetAppearanceMode) -> String {
    switch appearanceMode {
    case .number:
      return "\(todayPillNumber)番"
    case .date:
      return "\(todayPillNumber)番"
    case .sequential:
      return "\(todayPillNumber)日目"
    case _:
      return ""
    }
  }
}

