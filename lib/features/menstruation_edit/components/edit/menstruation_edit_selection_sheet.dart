import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/menstruation_edit/components/edit/menstruation_date_time_range_picker.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class MenstruationEditSelectionSheet extends HookConsumerWidget {
  final Menstruation menstruation;

  const MenstruationEditSelectionSheet({super.key, required this.menstruation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onDeleted() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("生理期間を削除しました"),
        ),
      );
      Navigator.of(context).pop();
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 20, top: 24, left: 16, right: 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${DateTimeFormatter.yearAndMonthAndDay(menstruation.beginDate)} - ${DateTimeFormatter.yearAndMonthAndDay(menstruation.endDate)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              style: ButtonStyle(alignment: Alignment.centerLeft),
              onPressed: () {
                showMenstruationDateRangePicker(
                  context,
                  ref,
                  initialMenstruation: menstruation,
                );
              },
              child: const Text(
                "生理期間を編集",
                style: TextStyle(
                  color: TextColor.main,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            TextButton(
              style: ButtonStyle(alignment: Alignment.centerLeft),
              child: const Text(
                "削除",
                style: TextStyle(
                  color: TextColor.danger,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                textAlign: TextAlign.start,
              ),
              onPressed: () {
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
                          analytics.logEvent(name: "pressed_delete_menstruation");

                          final navigator = Navigator.of(context);
                          try {
                            await ref.read(deleteMenstruationProvider).call(menstruation);
                          } catch (e) {
                            if (context.mounted) showErrorAlert(context, e);
                          }
                          onDeleted();
                          navigator.pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showMenstruationEditSelectionSheet(BuildContext context, MenstruationEditSelectionSheet menstruationEditSelectionSheet) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return menstruationEditSelectionSheet;
    },
  );
}
