import ActivityKit
import AlarmKit
import AppIntents
import SwiftUI
import WidgetKit

@available(iOS 26.0, *)
struct AlarmLiveActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: AlarmAttributes<AppAlarmMetadata>.self) { context in
      // The Lock Screen presentation.
      lockScreenView(attributes: context.attributes, state: context.state)
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

  func lockScreenView(attributes: AlarmAttributes<AppAlarmMetadata>, state: AlarmPresentationState) -> some View {
    VStack {
      HStack(alignment: .top) {
        alarmTitle(attributes: attributes, state: state)
        Spacer()
        cookingMethod(metadata: attributes.metadata)
      }

      bottomView(attributes: attributes, state: state)
    }
    .padding(.all, 12)
  }
}

@available(iOS 26.0, *)
struct AlarmProgressView: View {
  var mode: AlarmPresentationState.Mode
  var tint: Color

  var body: some View {
    Group {
      switch mode {
      case .countdown(let countdown):
        ProgressView(
          timerInterval: Date.now ... countdown.fireDate,
          countsDown: true,
          label: { EmptyView() },
          currentValueLabel: {
            Image(systemName: cookingMethod?.rawValue ?? "")
              .scaleEffect(0.9)
          })
      case .paused(let pausedState):
        let remaining = pausedState.totalCountdownDuration - pausedState.previouslyElapsedDuration
        ProgressView(value: remaining,
                     total: pausedState.totalCountdownDuration,
                     label: { EmptyView() },
                     currentValueLabel: {
          Image(systemName: "pause.fill")
            .scaleEffect(0.8)
        })
      default:
        EmptyView()
      }
    }
    .progressViewStyle(.circular)
    .foregroundStyle(tint)
    .tint(tint)
  }
}

struct AlarmControls: View {
  var presentation: AlarmPresentation
  var state: AlarmPresentationState

  var body: some View {
    HStack(spacing: 4) {
      switch state.mode {
      case .countdown:
        ButtonView(config: presentation.countdown?.pauseButton, intent: PauseIntent(alarmID: state.alarmID.uuidString), tint: .orange)
      case .paused:
        ButtonView(config: presentation.paused?.resumeButton, intent: ResumeIntent(alarmID: state.alarmID.uuidString), tint: .orange)
      default:
        EmptyView()
      }

      ButtonView(config: presentation.alert.stopButton, intent: StopIntent(alarmID: state.alarmID.uuidString), tint: .red)
    }
  }
}

struct ButtonView<I>: View where I: AppIntent {
  var config: AlarmButton
  var intent: I
  var tint: Color

  init?(config: AlarmButton?, intent: I, tint: Color) {
    guard let config else { return nil }
    self.config = config
    self.intent = intent
    self.tint = tint
  }

  var body: some View {
    Button(intent: intent) {
      Label(config.text, systemImage: config.systemImageName)
        .lineLimit(1)
    }
    .tint(tint)
    .buttonStyle(.borderedProminent)
    .frame(width: 96, height: 30)
  }
}
