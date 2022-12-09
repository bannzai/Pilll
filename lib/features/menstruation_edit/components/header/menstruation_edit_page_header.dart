import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/provider/menstruation.dart';

class MenstruationEditPageHeader extends HookConsumerWidget {
  final Menstruation? initialMenstruation;
  final ValueNotifier<DateRange?> editingDateRange;
  final Function() onDeleted;
  final Function(Menstruation) onSaved;

  const MenstruationEditPageHeader({
    Key? key,
    required this.initialMenstruation,
    required this.editingDateRange,
    required this.onDeleted,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialMenstruation = this.initialMenstruation;
    final editingDateRangeValue = editingDateRange.value;
    final deleteMenstruation = ref.watch(deleteMenstruationProvider);
    final setMenstruation = ref.watch(setMenstruationProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(_title,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: TextColor.main,
            )),
        const Spacer(),
        AlertButton(
          onPressed: () async {
            analytics.logEvent(name: "pressed_saving_menstruation_edit");
            if (initialMenstruation != null && editingDateRangeValue == null) {
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
                        await deleteMenstruation(initialMenstruation);
                        onDeleted();
                        analytics.logEvent(name: "pressed_delete_menstruation");
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            } else if (editingDateRangeValue == null) {
              Navigator.of(context).pop();
            } else {
              if (initialMenstruation == null) {
                final menstruation = Menstruation(beginDate: editingDateRangeValue.begin, endDate: editingDateRangeValue.end, createdAt: now());
                onSaved(await setMenstruation(menstruation));
              } else {
                final menstruation = initialMenstruation.copyWith(beginDate: editingDateRangeValue.begin, endDate: editingDateRangeValue.end);
                onSaved(await setMenstruation(menstruation));
              }
            }
          },
          text: "保存",
        )
      ],
    );
  }

  String get _title => initialMenstruation == null ? "生理開始日を選択" : "生理期間の編集";
}
