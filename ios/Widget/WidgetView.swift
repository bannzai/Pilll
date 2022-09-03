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
}
