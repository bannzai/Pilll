import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/modal/release_note.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> effectAfterTakenPillAction({
  required BuildContext context,
  required Future<void> taken,
  required RecordPageStateNotifier store,
}) async {
  try {
    await taken;
    FlutterAppBadger.removeBadge();
    _requestInAppReview();
    await showReleaseNotePreDialog(context);
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
    showErrorAlert(context, message: exception.toString());
  }
}

void _requestInAppReview() {
  SharedPreferences.getInstance().then((store) async {
    final key = IntKey.totalCountOfActionForTakenPill;
    int? value = store.getInt(key);
    if (value == null) {
      value = 0;
    }
    value += 1;
    store.setInt(key, value);
    if (value % 7 != 0) {
      return;
    }
    if (await InAppReview.instance.isAvailable()) {
      await InAppReview.instance.requestReview();
    }
  });
}

Future<PillSheetGroup?> take({
  required DateTime takenDate,
  required PillSheetGroup pillSheetGroup,
  required PillSheet activedPillSheet,
  required BatchFactory batchFactory,
  required PillSheetDatastore pillSheetDatastore,
  required PillSheetModifiedHistoryDatastore pillSheetModifiedHistoryDatastore,
  required PillSheetGroupDatastore pillSheetGroupDatastore,
  required bool isQuickRecord,
}) async {
  if (activedPillSheet.todayPillIsAlreadyTaken) {
    return null;
  }

  final batch = batchFactory.batch();

  final updatedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
    if (pillSheet.groupIndex > activedPillSheet.groupIndex) {
      return pillSheet;
    }
    if (pillSheet.isEnded) {
      return pillSheet;
    }

    // takenDateよりも予測するピルシートの最終服用日よりじも大きい場合はactivedPillSheetじゃないPillSheetと判断。
    // そのピルシートの最終日で予測する最終服用日を記録する
    if (takenDate.isAfter(pillSheet.estimatedEndTakenDate)) {
      return pillSheet.copyWith(lastTakenDate: pillSheet.estimatedEndTakenDate);
    } else {
      return pillSheet.copyWith(lastTakenDate: takenDate);
    }
  }).toList();

  final updatedPillSheetGroup =
      pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
  final updatedIndexses = pillSheetGroup.pillSheets.asMap().keys.where(
        (index) =>
            pillSheetGroup.pillSheets[index] !=
            updatedPillSheetGroup.pillSheets[index],
      );

  if (updatedIndexses.isEmpty) {
    return null;
  }

  pillSheetDatastore.update(
    batch,
    updatedPillSheets,
  );
  pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup);

  final before = pillSheetGroup.pillSheets[updatedIndexses.first];
  final after = updatedPillSheetGroup.pillSheets[updatedIndexses.last];
  final history =
      PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
    pillSheetGroupID: pillSheetGroup.id,
    before: before,
    after: after,
    isQuickRecord: isQuickRecord,
  );
  pillSheetModifiedHistoryDatastore.add(batch, history);

  await batch.commit();

  return updatedPillSheetGroup;
}
