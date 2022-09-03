import WidgetKit
import SwiftUI
import Intents

struct WidgetEntryView : WidgetView {
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
}

@main
struct Entrypoint: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: Const.widgetKind, provider: Provider()) { entry in
      WidgetEntryView(entry: entry)
    }
    .supportedFamilies(supportedFamilies)
    .configurationDisplayName("今日飲むピルが一目でわかる")
    .description("This is a Pilll widget")
  }

  private var supportedFamilies: [WidgetFamily] {
    if #available(iOSApplicationExtension 16.0, *) {
      return [.systemSmall, .accessoryCircular]
    } else {
      return [.systemSmall]
    }
  }
}

struct Widget_Previews: PreviewProvider {
  static var previews: some View {
    WidgetEntryView(entry: .init(date: .now))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}

