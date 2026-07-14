import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// 記録操作時点でまだ届いていない当日の通知時刻を返す
///
/// 通知時刻が0:00-2:00内(例: 1:00)に設定されているユーザーがその時刻より後に記録した場合、
/// 通知は既に届いているため「届かない」対象から除外する
List<ReminderTime> midnightTakenWarningRemainingReminderTimes({
  required List<ReminderTime> reminderTimes,
  required DateTime recordedAt,
}) {
  return reminderTimes
      .where(
          (reminderTime) => reminderTime.hour > recordedAt.hour || (reminderTime.hour == recordedAt.hour && reminderTime.minute > recordedAt.minute))
      .toList();
}

/// 深夜(0:00-2:00)服用記録の注意ダイアログを表示すべきかどうかを判定する
///
/// 日を跨いだことに気づかず服用記録をすると当日分まで記録され、
/// 当日の通知が届かなくなる問い合わせへの対策として、30日に1回まで注意ダイアログを表示する
bool shouldShowMidnightTakenWarningDialog({
  required SharedPreferences sharedPreferences,
  required DateTime takenDate,
  required DateTime recordedAt,
  required List<ReminderTime> reminderTimes,
}) {
  // 0:00〜1:59の記録操作のみ対象
  if (recordedAt.hour >= 2) {
    return false;
  }
  // 当日分まで服用記録された場合のみ対象。過去のピル番号タップ等、当日分が記録されない場合は当日の通知は届く
  if (takenDate.date() != recordedAt.date()) {
    return false;
  }
  // 記録時点でこれから届く予定の当日通知がなければ「通知が届かない」という注意自体が成立しない
  if (midnightTakenWarningRemainingReminderTimes(reminderTimes: reminderTimes, recordedAt: recordedAt).isEmpty) {
    return false;
  }
  // キーは「二度と表示しない」押下時にのみ保存されるため、未保存(null)は未押下として扱う
  if (sharedPreferences.getBool(BoolKey.midnightTakenWarningDialogNeverShowAgain) ?? false) {
    return false;
  }
  final lastShownMilliseconds = sharedPreferences.getDouble(DoubleKey.midnightTakenWarningDialogLastShownDateTime);
  // 30日に1回まで: 前回表示から30日未満の場合は表示しない。未表示(null)なら無条件で表示する
  if (lastShownMilliseconds != null && daysBetween(DateTime.fromMillisecondsSinceEpoch(lastShownMilliseconds.toInt()), recordedAt) < 30) {
    return false;
  }
  return true;
}

/// 深夜(0:00-2:00)服用記録の注意ダイアログが表示中かどうか
///
/// 「飲んだ」ボタンとピルシートの番号タップの複数経路から短時間に呼ばれた場合に、
/// 表示記録(SharedPreferences)の保存前に両方が表示可能と判定して二重表示されるのを防ぐ
bool _midnightTakenWarningDialogIsShowing = false;

/// 深夜(0:00-2:00)にアプリ上で服用記録をした場合に、当日分まで服用記録されたことを知らせる注意ダイアログを表示する
///
/// [takenDate] は服用記録された最後の日、[recordedAt] は記録操作を行った日時。
/// 服用記録(takePill)の完了を待たずに呼び出してよい
void showMidnightTakenWarningDialogIfNeeded({
  required BuildContext context,
  required DateTime takenDate,
  required DateTime recordedAt,
  required Setting setting,
}) async {
  if (_midnightTakenWarningDialogIsShowing) {
    return;
  }
  _midnightTakenWarningDialogIsShowing = true;
  try {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (!shouldShowMidnightTakenWarningDialog(
      sharedPreferences: sharedPreferences,
      takenDate: takenDate,
      recordedAt: recordedAt,
      reminderTimes: setting.reminderTimes,
    )) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    analytics.logScreenView(screenName: 'MidnightTakenWarningDialog');
    await showDialog(
      context: context,
      // 「閉じる」でSharedPreferencesに表示記録を残すため、ボタン以外で閉じられないようにする
      barrierDismissible: false,
      builder: (context) => MidnightTakenWarningDialog(
        takenDate: takenDate,
        reminderTimes: midnightTakenWarningRemainingReminderTimes(reminderTimes: setting.reminderTimes, recordedAt: recordedAt),
        // 2回目以降(過去に「閉じる」で表示日時が保存済み)の表示でのみ「二度と表示しない」を出す
        showsNeverShowAgainButton: sharedPreferences.containsKey(DoubleKey.midnightTakenWarningDialogLastShownDateTime),
      ),
    );
  } finally {
    // ダイアログが閉じた時点で表示記録は保存済みのため、フラグ解除後の再表示は30日条件で防がれる
    _midnightTakenWarningDialogIsShowing = false;
  }
}

/// 深夜(0:00-2:00)の服用記録で当日分まで記録されたことを知らせる注意ダイアログ
class MidnightTakenWarningDialog extends StatelessWidget {
  /// 服用記録をした日時。本文の日付(例: 7/11)の表示に使う
  final DateTime takenDate;

  /// 記録時点でまだ届いていない当日の通知時刻。本文の通知時刻(例: 19:00)の表示に使う
  final List<ReminderTime> reminderTimes;

  /// 「二度と表示しない」ボタンを表示するかどうか。2回目以降の表示でtrue
  final bool showsNeverShowAgainButton;

  const MidnightTakenWarningDialog({
    super.key,
    required this.takenDate,
    required this.reminderTimes,
    required this.showsNeverShowAgainButton,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 4,
        bottom: 24,
      ),
      actionsPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
      titlePadding: const EdgeInsets.only(top: 32),
      title: SvgPicture.asset('images/alert_24.svg', width: 24, height: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            L.midnightTakenWarningDialogTitle,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: TextColor.main,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            L.midnightTakenWarningDialogBody(
              '${takenDate.month}/${takenDate.day}',
              reminderTimes.map((reminderTime) => DateTimeFormatter.militaryTime(reminderTime.dateTime())).join(', '),
            ),
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w300,
              fontSize: 14,
              height: 1.7,
              color: TextColor.main,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        AppOutlinedButton(
          onPressed: () async {
            analytics.logEvent(name: 'midnight_taken_warning_faq');
            launchUrl(
              Uri.parse(
                'https://pilll.notion.site/63c3436e63ea4ba8a1407be40cb5f0e5',
              ),
            );
          },
          text: L.midnightTakenWarningDialogSeeHowToRevert,
        ),
        Center(
          child: AlertButton(
            text: L.close,
            onPressed: () async {
              analytics.logEvent(name: 'midnight_taken_warning_close');
              await (await SharedPreferences.getInstance()).setDouble(
                DoubleKey.midnightTakenWarningDialogLastShownDateTime,
                now().millisecondsSinceEpoch.toDouble(),
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        if (showsNeverShowAgainButton)
          Center(
            child: AlertButton(
              text: L.midnightTakenWarningDialogNeverShowAgain,
              onPressed: () async {
                analytics.logEvent(name: 'midnight_taken_warning_never_show_again');
                await (await SharedPreferences.getInstance()).setBool(
                  BoolKey.midnightTakenWarningDialogNeverShowAgain,
                  true,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
      ],
    );
  }
}
