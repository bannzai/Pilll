import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/database.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';

Future<PillSheetGroup?> quickRecordTakePill(DatabaseConnection database) async {
  final pillSheetGroup = await fetchLatestPillSheetGroup(database);
  if (pillSheetGroup == null) {
    return null;
  }
  final activePillSheet = pillSheetGroup.activePillSheet;
  if (activePillSheet == null) {
    return pillSheetGroup;
  }
  if (activePillSheet.todayPillIsAlreadyTaken) {
    return pillSheetGroup;
  }

  final takenDate = now();
  final batchFactory = BatchFactory(database);

  final takePill = TakePill(
    batchFactory: batchFactory,
    batchSetPillSheetModifiedHistory: BatchSetPillSheetModifiedHistory(database),
    batchSetPillSheetGroup: BatchSetPillSheetGroup(database),
  );
  final updatedPillSheetGroup = await takePill(
    takenDate: takenDate,
    pillSheetGroup: pillSheetGroup,
    activePillSheet: activePillSheet,
    isQuickRecord: true,
  );

  // NOTE: iOSではAppDelegate.swiftの方で先にバッジのカウントはクリアしている
  FlutterAppBadger.removeBadge();

  // NOTE: Firebase initializeが成功しているかが定かでは無いので一番最後にログを送る
  analytics.logEvent(name: "quick_recorded");

  return updatedPillSheetGroup;
}
