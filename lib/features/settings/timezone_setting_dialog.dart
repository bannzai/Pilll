import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/setting.dart';

class TimezoneSettingDialog extends HookConsumerWidget {
  final Setting setting;
  final String deviceTimezoneName;
  final Function(String) onDone;

  const TimezoneSettingDialog({
    Key? key,
    required this.setting,
    required this.deviceTimezoneName,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setSetting = ref.watch(setSettingProvider);
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 20),
      actionsPadding: const EdgeInsets.only(left: 24, right: 24),
      title: Text(
        "端末のタイムゾーン($deviceTimezoneName)と同期しますか？",
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
            setting.timezoneDatabaseName ?? "Asia/Tokyo",
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
                "user_timezone": setting.timezoneDatabaseName,
                "device_timezone": deviceTimezoneName,
              },
            );

            final navigator = Navigator.of(context);
            try {
              await setSetting(setting.copyWith(timezoneDatabaseName: deviceTimezoneName));
              onDone(deviceTimezoneName);
            } catch (error) {
              if (context.mounted) showErrorAlert(context, error);
            }
            navigator.pop();
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
                  "user_timezone": setting.timezoneDatabaseName,
                  "device_timezone": deviceTimezoneName,
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
