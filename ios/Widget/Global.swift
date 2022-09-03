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

extension Color {
  static let primary: Color = .init(red: 78 / 255, green: 98 / 255, blue: 135 / 255)
  static let orange: Color = .init(red: 229 / 255, green: 106 / 255, blue: 69 / 255)
  static let mainText: Color = .init(red: 41 / 255, green: 48 / 255, blue: 77 / 255, opacity: 0.87)
}

