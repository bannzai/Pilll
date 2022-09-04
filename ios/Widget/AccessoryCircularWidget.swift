import SwiftUI
import Foundation

struct AccessoryCircularWidget: WidgetView {
  let entry: Entry

  var body: some View {
    Group {
      switch entry.status {
      case let .pill(todayPillNumber, alreadyTaken):
        VStack {
          Spacer().frame(height: 8)

          Image("pilll-widget-icon")

          if let todayPillNumber {
            HStack {
              if alreadyTaken {
                Image("check-icon-on")
                  .resizable()
                  .frame(width: 18, height: 18)
              } else {
                Text(displayTodayPillNumber(todayPillNumber: todayPillNumber, appearanceMode: entry.settingPillSheetAppearanceMode))
              }
            }
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
      case .userIsNotPremiumOrTrial:
        VStack(spacing: 5) {
          Image("pilll-widget-icon")

          Image(systemName: "xmark")
            .font(.system(size: 14))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
      }
    }
  }
}

