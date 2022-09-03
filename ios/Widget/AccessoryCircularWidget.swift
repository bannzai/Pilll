import SwiftUI
import Foundation

struct AccessoryCircularWidget: WidgetView {
  let entry: Entry

  var body: some View {
    Group {
      switch entry.status {
      case let .pill(todayPillNumber, alreadyTaken):
        VStack {
          Image("pilll-widget-icon")
            .frame(width: 5.5, height: 8)

          if let todayPillNumber {
            HStack {
              if alreadyTaken {
                Image("check-icon-on")
                  .resizable()
                  .frame(width: 16, height: 16)
              } else {
                Text("\(todayPillNumber)")
              }
            }
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
      case .userIsNotPremiumOrTrial:
        VStack {
          Image("pilll-widget-icon")
            .frame(width: 5.5, height: 8)

          Image(systemName: "xmark")
            .font(.system(size: 9))
        }
      }
    }
  }
}
