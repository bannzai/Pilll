import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/day.dart';

Future<void> recordPill() async {
  // 通知からの起動の時に、FirebaseAuth.instanceを参照すると、まだinitializeされてないよ．的なエラーが出る
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) {
    return;
  }

  final database = DatabaseConnection(firebaseUser.uid);
  final pillSheetDatastore = PillSheetDatastore(database);
  final pillSheetModifiedHistoryDatastore =
      PillSheetModifiedHistoryDatastore(database);
  final pillSheetGroupDatastore = PillSheetGroupDatastore(database);
  final pillSheetGroup = await pillSheetGroupDatastore.fetchLatest();
  if (pillSheetGroup == null) {
    return Future.value();
  }
  final activedPillSheet = pillSheetGroup.activedPillSheet;
  if (activedPillSheet == null) {
    return Future.value();
  }
  if (activedPillSheet.todayPillIsAlreadyTaken) {
    return Future.value();
  }

  final takenDate = now();
  final batchFactory = BatchFactory(database);

  await takePill(
    takenDate: takenDate,
    pillSheetGroup: pillSheetGroup,
    activedPillSheet: activedPillSheet,
    batchFactory: batchFactory,
    pillSheetDatastore: pillSheetDatastore,
    pillSheetModifiedHistoryDatastore: pillSheetModifiedHistoryDatastore,
    pillSheetGroupDatastore: pillSheetGroupDatastore,
    isQuickRecord: true,
  );

  FlutterAppBadger.removeBadge();
  // NOTE: Firebase initializeが成功しているかが定かでは無いので一番最後にログを送る
  analytics.logEvent(name: "quick_recorded");
}
