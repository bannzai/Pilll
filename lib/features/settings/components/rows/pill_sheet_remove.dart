import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/app.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/delete_pill_sheet.dart';
import 'package:pilll/utils/local_notification.dart';

class PillSheetRemoveRow extends HookConsumerWidget {
  final PillSheetGroup latestPillSheetGroup;
  final PillSheet activePillSheet;

  const PillSheetRemoveRow({
    super.key,
    required this.latestPillSheetGroup,
    required this.activePillSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletePillSheetGroup = ref.watch(deletePillSheetGroupProvider);
    final cancelReminderLocalNotification = ref.watch(
      cancelReminderLocalNotificationProvider,
    );
    return ListTile(
      title: Text(
        L.discardAllPillSheets,
        style: const TextStyle(
          fontFamily: FontFamily.roboto,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      onTap: () {
        analytics.logEvent(name: 'did_select_remove_pill_sheet');
        showDialog(
          context: context,
          builder: (_) {
            return DiscardDialog(
              title: L.areYouSureDoing(L.discardAllPillSheets),
              message: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    // TODO: [Localizations]
                    TextSpan(
                      text: L.currentlyDisplayed,
                      style: const TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: TextColor.main,
                      ),
                    ),
                    TextSpan(
                      text: L.allPillSheets,
                      style: const TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: TextColor.main,
                      ),
                    ),
                    TextSpan(
                      text: L.willBeDiscarded,
                      style: const TextStyle(
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
                      await deletePillSheetGroup(
                        latestPillSheetGroup: latestPillSheetGroup,
                        activePillSheet: activePillSheet,
                      );
                      await cancelReminderLocalNotification();
                      navigatorKey.currentState?.pop();
                      ScaffoldMessenger.of(
                        navigatorKey.currentContext!,
                      ).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(L.pillSheetDiscarded),
                        ),
                      );
                    } catch (error) {
                      showErrorAlert(navigatorKey.currentContext, error);
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
