import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/features/record/components/pill_sheet/components/record_page_rest_duration_dialog.dart';
import 'package:pilll/features/record/components/supports/components/rest_duration/invalid_already_taken_pill_dialog.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/pill_sheet.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/day.dart';

class BeginManualRestDurationButton extends HookConsumerWidget {
  final PillSheetAppearanceMode appearanceMode;
  final PillSheet activedPillSheet;
  final PillSheetGroup pillSheetGroup;
  final VoidCallback didBeginRestDuration;

  const BeginManualRestDurationButton({
    Key? key,
    required this.appearanceMode,
    required this.activedPillSheet,
    required this.pillSheetGroup,
    required this.didBeginRestDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchFactory = ref.watch(batchFactoryProvider);
    final batchSetPillSheets = ref.watch(batchSetPillSheetsProvider);
    final batchSetPillSheetGroup = ref.watch(batchSetPillSheetGroupProvider);
    final batchSetPillSheetModifiedHistory = ref.watch(batchSetPillSheetModifiedHistoryProvider);

    return SizedBox(
      width: 80,
      child: SmallAppOutlinedButton(
        text: "休薬する",
        onPressed: () async {
          analytics.logEvent(name: "begin_manual_rest_duration_pressed", parameters: {"pill_sheet_id": activedPillSheet.id});

          if (activedPillSheet.todayPillIsAlreadyTaken) {
            showInvalidAlreadyTakenPillDialog(context);
          } else {
            showRecordPageRestDurationDialog(
              context,
              appearanceMode: appearanceMode,
              pillSheetGroup: pillSheetGroup,
              activedPillSheet: activedPillSheet,
              onDone: () async {
                analytics.logEvent(name: "done_rest_duration");
                // NOTE: batch.commit でリモートのDBに書き込む時間がかかるので事前にバッジを0にする
                FlutterAppBadger.removeBadge();
                await _beginRestDuration(
                  batchFactory,
                  batchSetPillSheets: batchSetPillSheets,
                  batchSetPillSheetGroup: batchSetPillSheetGroup,
                  batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
                );
                didBeginRestDuration();
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _beginRestDuration(
    BatchFactory batchFactory, {
    required BatchSetPillSheets batchSetPillSheets,
    required BatchSetPillSheetGroup batchSetPillSheetGroup,
    required BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory,
  }) async {
    final batch = batchFactory.batch();

    final restDuration = RestDuration(
      beginDate: now(),
      createdDate: now(),
    );
    final updatedPillSheet = activedPillSheet.copyWith(
      restDurations: [...activedPillSheet.restDurations, restDuration],
    );
    final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);
    batchSetPillSheets(batch, updatedPillSheetGroup.pillSheets);
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        pillSheetGroupID: pillSheetGroup.id,
        before: activedPillSheet,
        after: updatedPillSheet,
        restDuration: restDuration,
      ),
    );

    await batch.commit();
  }
}
