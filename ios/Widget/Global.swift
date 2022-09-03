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
