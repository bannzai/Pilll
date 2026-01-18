import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';

class ExplainPillNumber extends HookConsumerWidget {
  final String today;

  const ExplainPillNumber({super.key, required this.today});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(initialSettingStateNotifierProvider);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: () {
          final todayPillNumber = state.todayPillNumber;
          if (todayPillNumber == null) {
            return <Widget>[
              const Text(
                '',
                style: TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w500, fontSize: 34, color: TextColor.main),
              ),
            ];
          }
          return <Widget>[
            Text(
              L.pillForToday(today),
              style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w400, fontSize: 12, color: TextColor.main),
            ),
            Text(
              '${todayPillNumber.pillNumberInPillSheet}',
              style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w500, fontSize: 34, color: TextColor.main),
            ),
            Text(
              L.number,
              style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w400, fontSize: 12, color: TextColor.main),
            ),
          ];
        }(),
      ),
    );
  }
}
