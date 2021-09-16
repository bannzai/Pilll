import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetServiceProvider = Provider<PillSheetService>(
    (ref) => PillSheetService(ref.watch(databaseProvider)));

class PillSheetService {
  final DatabaseConnection _database;

  PillSheetService(this._database);

  // Return new PillSheet document id
  List<PillSheet> register(WriteBatch batch, List<PillSheet> pillSheets) {
    final List<PillSheet> newPillSheets = [];
    pillSheets.forEach((pillSheet) {
      if (pillSheet.createdAt != null) throw PillSheetAlreadyExists();
      if (pillSheet.deletedAt != null) throw PillSheetAlreadyDeleted();
      final copied = pillSheet.copyWith(createdAt: DateTime.now());

      final document = _database.pillSheetsReference().doc();
      var json = copied.toJson();
      batch.set(document, json, SetOptions(merge: true));

      newPillSheets.add(copied.copyWith(id: document.id));
    });
    return newPillSheets;
  }

  PillSheet delete(WriteBatch batch, PillSheet pillSheet) {
    final updated = pillSheet.copyWith(deletedAt: DateTime.now());
    batch.set(_database.pillSheetReference(pillSheet.documentID!),
        updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  update(WriteBatch batch, PillSheet pillSheet) {
    var json = pillSheet.toJson();
    batch.update(_database.pillSheetReference(pillSheet.documentID!), json);
  }
}

class PillSheetIsNotExists extends Error {
  @override
  toString() {
    return "ピルシートが存在しません。";
  }
}

class PillSheetAlreadyExists extends Error {
  @override
  toString() {
    return "ピルシートがすでに存在しています。";
  }
}

class PillSheetAlreadyDeleted extends Error {
  @override
  String toString() {
    return "ピルシートはすでに削除されています。";
  }
}
