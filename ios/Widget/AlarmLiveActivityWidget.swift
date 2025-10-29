import ActivityKit
#if canImport(AlarmKit)
import AlarmKit
#endif
import AppIntents
import SwiftUI
import WidgetKit

@available(iOS 26.0, *)
struct AlarmLiveActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: AlarmAttributes<AppAlarmMetadata>.self) { context in
      // The Lock Screen presentation.
      // NOTE: 現在はロック画面にも出ない。また、DynamicIslandにもどのViewの定義も出ない。時間になったら表示されるのは、AlartPresentationで設定した内容を使用してでいているみたい
      LockScreen(attributes: context.attributes, state: context.state)
    } dynamicIsland: { context in
      // The presentations that appear in the Dynamic Island.
      DynamicIsland {
        // The expanded Dynamic Island presentation.
        DynamicIslandExpandedRegion(.leading) {
          EmptyView()
        }
        DynamicIslandExpandedRegion(.trailing) {
          EmptyView()
        }
        DynamicIslandExpandedRegion(.bottom) {
          EmptyView()
        }
      } compactLeading: {
        EmptyView()
      } compactTrailing: {
        EmptyView()
      } minimal: {
        EmptyView()
      }
      .keylineTint(context.attributes.tintColor)
    }
  }

  func LockScreen(attributes: AlarmAttributes<AppAlarmMetadata>, state: AlarmPresentationState) -> some View {
    VStack(alignment: .leading) {
      Text(attributes.metadata?.title ?? "服薬時刻です")
        .font(.body)
        .fontWeight(.semibold)
        .padding(.leading, 6)

      Spacer()

      HStack {
        Countdown(state: state)
        Spacer()
        StopButton(state: state, attributes: attributes)
      }
    }
    .padding(.all, 12)
  }

  func Countdown(state: AlarmPresentationState) -> some View {
    Group {
      switch state.mode {
      case .countdown(let countdown):
        Text(timerInterval: Date.now ... countdown.fireDate, countsDown: true)
      case .paused(let state):
        let remaining = Duration.seconds(state.totalCountdownDuration - state.previouslyElapsedDuration)
        let pattern: Duration.TimeFormatStyle.Pattern = remaining > .seconds(60 * 60) ? .hourMinuteSecond : .minuteSecond
        Text(remaining.formatted(.time(pattern: pattern)))
      default:
        EmptyView()
      }
    }
    .monospacedDigit()
    .lineLimit(1)
    .minimumScaleFactor(0.6)
    .frame(maxWidth: 150, alignment: .leading)
    .font(.system(size: 40, design: .rounded))
  }

}

@available(iOS 26.0, *)
struct StopButton: View {
  var state: AlarmPresentationState
  var attributes: AlarmAttributes<AppAlarmMetadata>

  var body: some View {
    Button(intent: OpenAlarmAppIntent(alarmID: state.alarmID.uuidString)) {
      Label("服薬する", systemImage: "pill")
        .lineLimit(1)
    }
    .tint(Color(.appPrimary))
    .buttonStyle(.borderedProminent)
    .frame(width: 96, height: 30)
  }
}

