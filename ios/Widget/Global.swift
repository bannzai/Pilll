import Foundation

var calendar: Calendar {
  var calendar = Calendar(identifier: .gregorian)
  calendar.locale = .autoupdatingCurrent
  calendar.timeZone = .autoupdatingCurrent
  return calendar
}

var dateFormater: DateFormatter {
  let dateFormater = DateFormatter()
  dateFormater.locale = .autoupdatingCurrent
  dateFormater.timeZone = .autoupdatingCurrent
  return dateFormater
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
