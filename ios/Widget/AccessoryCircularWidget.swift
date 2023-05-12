import SwiftUI
import Foundation

struct AccessoryCircularWidget: WidgetView {
  let entry: Entry

  var body: some View {
    if #available(iOSApplicationExtension 16.0, *) {
      switch entry.status {
      case let .pill(todayPillNumber, alreadyTaken):
        VStack(spacing: 4) {
          Image("pilll-widget-icon")
            .resizable()
            .scaledToFit()
            .frame(height: 16)

          if let todayPillNumber {
            if alreadyTaken {
              Image("check-icon-on")
                .resizable()
                .frame(width: 18, height: 18)
            } else {
              Text(displayTodayPillNumber(todayPillNumber: todayPillNumber, appearanceMode: entry.settingPillSheetAppearanceMode))
                .bold()
            }
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
      case .userIsNotPremiumOrTrial:
        VStack(spacing: 4) {
          Image("pilll-widget-icon")
            .resizable()
            .scaledToFit()
            .frame(height: 16)


          Image(systemName: "xmark")
            .font(.system(size: 13))
            .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
  }
}
}

