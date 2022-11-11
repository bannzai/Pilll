import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:riverpod/riverpod.dart';

final batchSetPillSheetsProvider = Provider((ref) => BatchSetPillSheets(ref.watch(databaseProvider)));

class BatchSetPillSheets {
  final DatabaseConnection databaseConnection;
  BatchSetPillSheets(this.databaseConnection);

  void call(WriteBatch batch, List<PillSheet> pillSheets) async {
    for (var pillSheet in pillSheets) {
      batch.set(databaseConnection.pillSheetReference(pillSheet.id), pillSheet, SetOptions(merge: true));
    }
  }
}
