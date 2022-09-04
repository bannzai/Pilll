import Foundation
import SwiftUI

struct AccessoryRectanglerWidget: WidgetView {
  let entry: Entry

  var body: some View {
    Group {
      switch entry.status {
      case let .pill(todayPillNumber, alreadyTaken):
        VStack(alignment: .leading) {
          Image("pilll-widget-icon")

          if let todayPillNumber {
            HStack {
              Text(displayTodayPillNumber(todayPillNumber: todayPillNumber, appearanceMode: .number))

              Spacer()

              if alreadyTaken {
                Image("check-icon-on")
                  .resizable()
                  .frame(width: 18, height: 18)
              }
            }
          }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
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
