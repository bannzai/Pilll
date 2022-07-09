import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/settings/setting_page_state.codegen.dart';
import 'package:pilll/domain/settings/setting_page_state_notifier.dart';
import 'package:pilll/error/error_alert.dart';

class TimezoneSettingDialog extends StatelessWidget {
  final SettingState state;
  final SettingStateNotifier stateNotifier;
  final Function(String) onDone;

  const TimezoneSettingDialog({
    Key? key,
    required this.state,
    required this.stateNotifier,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding:
          const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 20),
      actionsPadding: const EdgeInsets.only(left: 24, right: 24),
      title: Text(
        "端末のタイムゾーン(${state.deviceTimezoneName})と同期しますか？",
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: TextColor.main,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            "現在設定されているタイムゾーン",
            style: TextStyle(
              fontFamily: FontFamily.japanese,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TextColor.main,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.setting.timezoneDatabaseName ?? "Asia/Tokyo",
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: TextColor.main,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        AppOutlinedButton(
          onPressed: () async {
            analytics.logEvent(
              name: "pressed_timezone_yes",
              parameters: {
                "user_timezone": state.setting.timezoneDatabaseName,
                "device_timezone": state.deviceTimezoneName,
              },
            );
            try {
              await stateNotifier.asyncAction.updateTimezoneDatabaseName(
                  setting: state.setting,
                  timezoneDatabaseName: state.deviceTimezoneName);
              onDone(state.deviceTimezoneName);
            } catch (error) {
              showErrorAlert(context, message: error.toString());
            }

            Navigator.of(context).pop();
          },
          text: "はい",
        ),
        Center(
          child: AlertButton(
            text: "いいえ",
            onPressed: () async {
              analytics.logEvent(
                name: "pressed_timezone_no",
                parameters: {
                  "user_timezone": state.setting.timezoneDatabaseName,
                  "device_timezone": state.deviceTimezoneName,
                },
              );
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
