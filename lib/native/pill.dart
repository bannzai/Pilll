import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/database.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';

Future<PillSheetGroup?> quickRecordTakePill() async {
  // 通知からの起動の時に、FirebaseAuth.instanceを参照すると、まだinitializeされてないよ．的なエラーが出る
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) {
    return null;
  }

  final database = DatabaseConnection(firebaseUser.uid);
  final pillSheetGroup = await latestPillSheetGroup(database);
  if (pillSheetGroup == null) {
    return null;
  }
  final activedPillSheet = pillSheetGroup.activedPillSheet;
  if (activedPillSheet == null) {
    return pillSheetGroup;
  }
  if (activedPillSheet.todayPillsAreAlreadyTaken) {
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
    activedPillSheet: activedPillSheet,
    isQuickRecord: true,
  );

  // NOTE: iOSではAppDelegate.swiftの方で先にバッジのカウントはクリアしている
  FlutterAppBadger.removeBadge();

  // NOTE: Firebase initializeが成功しているかが定かでは無いので一番最後にログを送る
  analytics.logEvent(name: "quick_recorded");

  return updatedPillSheetGroup;
}
