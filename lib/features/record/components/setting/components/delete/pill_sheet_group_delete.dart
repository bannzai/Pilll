import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/delete_pill_sheet.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/local_notification.dart';

class PillSheetGroupDelete extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;
  const PillSheetGroupDelete({super.key, required this.pillSheetGroup, required this.activePillSheet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletePillSheetGroup = ref.watch(deletePillSheetGroupProvider);
    final cancelReminderLocalNotification = ref.watch(cancelReminderLocalNotificationProvider);
    return ListTile(
      leading: const Icon(Icons.delete_outline, color: AppColors.red),
      title: Text(L.discardAllPillSheets, style: const TextStyle(color: AppColors.red)),
      onTap: () {
        analytics.logEvent(name: 'did_select_delete_pill_sheet');
        showDialog(
          context: context,
          builder: (_) {
            return DiscardDialog(
              title: L.areYouSureDoing(L.discardAllPillSheets),
              message: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: L.currentlyDisplayed,
                      style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w300, fontSize: 14, color: TextColor.main),
                    ),
                    // TODO: [Localizations]
                    TextSpan(
                      text: L.allPillSheets,
                      style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w600, fontSize: 14, color: TextColor.main),
                    ),
                    TextSpan(
                      text: L.willBeDiscarded,
                      style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w300, fontSize: 14, color: TextColor.main),
                    ),
                  ],
                ),
              ),
              actions: [
                AlertButton(
                  text: L.cancel,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                AlertButton(
                  text: L.discard,
                  onPressed: () async {
                    try {
                      // NOTE: リモートのDBに書き込む時間がかかるので事前にバッジを0にする。楽観的UI更新
                      FlutterAppBadger.removeBadge();
                      await deletePillSheetGroup(latestPillSheetGroup: pillSheetGroup, activePillSheet: activePillSheet);
                      await cancelReminderLocalNotification();
                      if (context.mounted) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(duration: const Duration(seconds: 2), content: Text(L.pillSheetDiscarded)));
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
