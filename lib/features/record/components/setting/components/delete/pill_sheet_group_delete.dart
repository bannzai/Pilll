import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/delete_pill_sheet.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/local_notification.dart';

class PillSheetGroupDelete extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;
  const PillSheetGroupDelete({
    super.key,
    required this.pillSheetGroup,
    required this.activePillSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletePillSheetGroup = ref.watch(deletePillSheetGroupProvider);
    final cancelReminderLocalNotification = ref.watch(cancelReminderLocalNotificationProvider);
    return ListTile(
      leading: const Icon(Icons.delete, color: PilllColors.red),
      title: const Text(
        "ピルシートをすべて破棄",
        style: TextStyle(color: PilllColors.red),
      ),
      onTap: () {
        analytics.logEvent(
          name: "did_select_delete_pill_sheet",
        );
        showDialog(
          context: context,
          builder: (_) {
            return DiscardDialog(
              title: "ピルシートをすべて破棄しますか？",
              message: RichText(
                textAlign: TextAlign.start,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "現在表示されている",
                      style: TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: TextColor.main,
                      ),
                    ),
                    TextSpan(
                      text: "すべてのピルシート",
                      style: TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: TextColor.main,
                      ),
                    ),
                    TextSpan(
                      text: "が破棄されます",
                      style: TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: TextColor.main,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                AlertButton(
                  text: "キャンセル",
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                AlertButton(
                  text: "破棄する",
                  onPressed: () async {
                    try {
                      await deletePillSheetGroup(latestPillSheetGroup: pillSheetGroup, activePillSheet: activePillSheet);
                      await cancelReminderLocalNotification();
                      if (context.mounted) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text("ピルシートを破棄しました"),
                          ),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        showErrorAlert(context, error);
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
