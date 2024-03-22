import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class MenstruationCalendarPickersSheetSaveButton extends HookConsumerWidget {
  final Menstruation? initialMenstruation;
  final ValueNotifier<DateRange?> editingDateRange;

  const MenstruationCalendarPickersSheetSaveButton({
    Key? key,
    required this.initialMenstruation,
    required this.editingDateRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialMenstruation = this.initialMenstruation;
    final editingDateRangeValue = editingDateRange.value;
    final deleteMenstruation = ref.watch(deleteMenstruationProvider);
    final setMenstruation = ref.watch(setMenstruationProvider);

    void onSaved(Menstruation savedMenstruation) {
      if (initialMenstruation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text("${DateTimeFormatter.monthAndDay(savedMenstruation.beginDate)}から生理開始で記録しました"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("生理期間を編集しました"),
          ),
        );
      }
      Navigator.of(context).pop();
    }

    void onDeleted() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("生理期間を削除しました"),
        ),
      );
      Navigator.of(context).pop();
    }

    return AlertButton(
      onPressed: () async {
        analytics.logEvent(name: "pressed_saving_menstruation_edit");
        if (initialMenstruation != null && editingDateRangeValue == null) {
          // 削除
          showDialog(
            context: context,
            builder: (context) => DiscardDialog(
              title: "生理期間を削除しますか？",
              message: const Text(""),
              actions: [
                AlertButton(
                  text: "キャンセル",
                  onPressed: () async {
                    analytics.logEvent(name: "cancelled_delete_menstruation");
                    Navigator.of(context).pop();
                  },
                ),
                AlertButton(
                  text: "削除する",
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    try {
                      await deleteMenstruation(initialMenstruation);
                    } catch (e) {
                      if (context.mounted) showErrorAlert(context, e);
                    }
                    onDeleted();
                    analytics.logEvent(name: "pressed_delete_menstruation");
                    navigator.pop();
                  },
                ),
              ],
            ),
          );
        } else if (editingDateRangeValue == null) {
          // 変更無し
          Navigator.of(context).pop();
        } else {
          if (initialMenstruation == null) {
            // 新規作成
            final menstruation = Menstruation(beginDate: editingDateRangeValue.begin, endDate: editingDateRangeValue.end, createdAt: now());
            try {
              onSaved(await setMenstruation(menstruation));
            } catch (e) {
              if (context.mounted) showErrorAlert(context, e);
            }
          } else {
            // 編集
            final menstruation = initialMenstruation.copyWith(beginDate: editingDateRangeValue.begin, endDate: editingDateRangeValue.end);
            try {
              onSaved(await setMenstruation(menstruation));
            } catch (e) {
              if (context.mounted) showErrorAlert(context, e);
            }
          }
        }
      },
      text: "保存",
    );
  }
}

// TODO:
// String get _title => initialMenstruation == null ? "生理開始日を選択" : "生理期間の編集";
