import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:riverpod/riverpod.dart';

final batchSetPillSheetsProvider = Provider((ref) => BatchSetPillSheets(ref.watch(databaseProvider)));

class BatchSetPillSheets {
  final DatabaseConnection databaseConnection;
  BatchSetPillSheets(this.databaseConnection);

  List<PillSheet> call(WriteBatch batch, List<PillSheet> pillSheets) {
    final List<PillSheet> pillSheets = [];
    for (var pillSheet in pillSheets) {
      final doc = databaseConnection.pillSheetReference(pillSheet.id);
      batch.set(doc, pillSheet, SetOptions(merge: true));
      pillSheets.add(pillSheet.copyWith(id: doc.id));
    }
    return pillSheets;
  }
}
