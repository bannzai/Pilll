import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';

class BatchSetPillSheet {
  final DatabaseConnection databaseConnection;
  BatchSetPillSheet(this.databaseConnection);

  void call(WriteBatch batch, {required PillSheet pillSheet}) async {
    batch.set(databaseConnection.pillSheetReference(pillSheet.id), pillSheet, SetOptions(merge: true));
  }
}
