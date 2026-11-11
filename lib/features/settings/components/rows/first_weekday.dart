import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/first_weekday.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

/// カレンダーと生理タブの週の行を月曜日から始めるかを切り替える設定行。
class FirstWeekdayRow extends ConsumerWidget {
  const FirstWeekdayRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: Text(
        L.startWeekOnMonday,
        style: const TextStyle(
          fontFamily: FontFamily.roboto,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      activeThumbColor: AppColors.secondary,
      onChanged: (bool value) async {
        analytics.logEvent(name: 'toggle_start_week_on_monday', parameters: {'value': value});
        await ref.read(boolSharedPreferencesProvider(BoolKey.isFirstWeekdayMonday).notifier).set(value);
      },
      value: ref.watch(firstWeekdayProvider) == Weekday.Monday,
      // toggle_reminder_notification.dart の SwitchListTile と同じ余白にして、設定画面のスイッチの位置を揃える
      contentPadding: const EdgeInsets.fromLTRB(14, 4, 6, 0),
    );
  }
}
