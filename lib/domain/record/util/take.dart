import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/modal/release_note.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> effectAfterTaken({
  required BuildContext context,
  required Future<void>? taken,
  required RecordPageStore store,
}) async {
  final _taken = taken;
  if (_taken == null) {
    return;
  }
  try {
    await _taken;
    FlutterAppBadger.removeBadge();
    _requestInAppReview();
    await showReleaseNotePreDialog(context);
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
    store.handleException(exception);
  }
}

_requestInAppReview() {
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
  required PillSheetService pillSheetService,
  required PillSheetModifiedHistoryService pillSheetModifiedHistoryService,
  required PillSheetGroupService pillSheetGroupService,
}) async {
  if (activedPillSheet.todayPillNumber ==
      activedPillSheet.lastTakenPillNumber) {
    return null;
  }

  final batch = batchFactory.batch();

  final updatedPillSheets = pillSheetGroup.pillSheets.where((pillSheet) {
    if (pillSheet.groupIndex > activedPillSheet.groupIndex) {
      return false;
    }
    if (pillSheet.isFill) {
      return false;
    }
    return true;
  }).map((pillSheet) {
    final scheduledLastTakenDate = pillSheet.beginingDate
        .add(Duration(days: pillSheet.pillSheetType.totalCount - 1));
    if (takenDate.isAfter(scheduledLastTakenDate)) {
      return pillSheet.copyWith(lastTakenDate: scheduledLastTakenDate);
    } else {
      return pillSheet.copyWith(lastTakenDate: takenDate);
    }
  }).toList();
  if (updatedPillSheets.isEmpty) {
    return null;
  }

  final history =
      PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
    pillSheetGroupID: pillSheetGroup.id,
    before: activedPillSheet,
    after: updatedPillSheets.last,
  );
  pillSheetModifiedHistoryService.add(batch, history);

  final updatedPillSheetGroup =
      pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
  pillSheetGroupService.update(batch, updatedPillSheetGroup);

  await batch.commit();
}
