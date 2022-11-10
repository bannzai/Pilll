import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:riverpod/riverpod.dart';

final batchSetPillSheetGroupProvider = Provider((ref) => BatchSetPillSheetGroup(ref.watch(databaseProvider)));

class BatchSetPillSheetGroup {
  final DatabaseConnection databaseConnection;
  BatchSetPillSheetGroup(this.databaseConnection);

  void call(WriteBatch batch, {required PillSheetGroup pillSheetGroup}) async {
    batch.set(databaseConnection.pillSheetGroupReference(pillSheetGroup.id), pillSheetGroup, SetOptions(merge: true));
  }
}

final setPillSheetGroupProvider = Provider((ref) => SetPillSheetGroup(ref.watch(databaseProvider)));

class SetPillSheetGroup {
  final DatabaseConnection databaseConnection;
  SetPillSheetGroup(this.databaseConnection);

  Future<void> call(PillSheetGroup pillSheetGroup) async {
    await databaseConnection.pillSheetGroupReference(pillSheetGroup.id).set(pillSheetGroup, SetOptions(merge: true));
  }
}
