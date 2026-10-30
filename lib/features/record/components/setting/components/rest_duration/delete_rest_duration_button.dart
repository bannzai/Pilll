import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/provider.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/local_notification.dart';

/// 服用お休み期間の行に置く削除ボタン。確認ダイアログで承諾されたら [restDuration] を [pillSheetGroup] から削除する
class DeleteRestDurationButton extends HookConsumerWidget {
  final RestDuration restDuration;
  final PillSheetGroup pillSheetGroup;

  /// 削除が完了した後に呼ばれる
  /// 削除後の画面の扱い (ボトムシートを閉じる・前回のピルシートグループを再取得する) が置き場所ごとに異なるため、コールバックで受け取る
  final VoidCallback onDeleted;

  const DeleteRestDurationButton({
    super.key,
    required this.restDuration,
    required this.pillSheetGroup,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteRestDuration = ref.watch(deleteRestDurationProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    return IconButton(
      icon: const Icon(Icons.delete_outline, color: AppColors.red),
      tooltip: L.deletePausePeriod,
      onPressed: () {
        analytics.logEvent(
          name: 'did_select_delete_rest_duration',
          parameters: {'rest_duration_id': restDuration.id},
        );
        showDiscardDialog(
          context,
          title: L.areYouSureDoing(L.deletePausePeriod),
          message: L.deletePausePeriodConfirmMessage,
          actions: [
            AlertButton(
              text: L.cancel,
              onPressed: () async {
                analytics.logEvent(
                  name: 'cancel_delete_rest_duration',
                  parameters: {'rest_duration_id': restDuration.id},
                );
                Navigator.of(context).pop();
              },
            ),
            AlertButton(
              text: L.delete,
              onPressed: () async {
                analytics.logEvent(
                  name: 'delete_rest_duration',
                  parameters: {'rest_duration_id': restDuration.id},
                );
                try {
                  await deleteRestDuration(restDuration: restDuration, pillSheetGroup: pillSheetGroup);
                  // 服用お休みの有無・期間でリマインドを登録する日が変わるため、削除後の状態で登録しなおす
                  await registerReminderLocalNotification();
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(duration: const Duration(seconds: 2), content: Text(L.deletedPausePeriod)),
                  );
                  onDeleted();
                } catch (e) {
                  debugPrint(e.toString());
                  if (context.mounted) {
                    showErrorAlert(context, e);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
