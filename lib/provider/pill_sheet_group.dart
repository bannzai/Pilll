import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:riverpod/riverpod.dart';

// この変数にtrueを入れることでMetadata.hasPendingWritesがfalseの場合=リモートDBに書き込まれた場合にStreamの値を流すように制御できる。
// Pilllではアプリを開いている時に複数箇所からのDB書き込みが無いので(ごくまれにBackendで書き込みと被る可能性はある)単純なフラグ制御を採用している
bool awaitsPillSheetGroupRemoteDBDataChanged = false;
PillSheetGroup? _filter(QuerySnapshot<PillSheetGroup> snapshot) {
  if (snapshot.docs.isEmpty) return null;
  if (!snapshot.docs.last.exists) return null;

  return snapshot.docs.last.data();
}

Future<PillSheetGroup?> latestPillSheetGroup(DatabaseConnection databaseConnection) async {
  return (await databaseConnection.pillSheetGroupsReference().orderBy(PillSheetGroupFirestoreKeys.createdAt).limitToLast(1).get())
      .docs
      .lastOrNull
      ?.data();
}

final activePillSheetProvider = Provider((ref) {
  return ref.watch(latestPillSheetGroupProvider).whenData((value) => value?.activedPillSheet);
});

final latestPillSheetGroupProvider = StreamProvider((ref) => ref
        .watch(databaseProvider)
        .pillSheetGroupsReference()
        .orderBy(PillSheetGroupFirestoreKeys.createdAt)
        .limitToLast(1)
        .snapshots(includeMetadataChanges: true)
        .skipWhile((snapshot) {
      if (awaitsPillSheetGroupRemoteDBDataChanged) {
        if (snapshot.metadata.hasPendingWrites) {
          debugPrint("[DEBUG] hasPendingWrites: true");
          return true;
        } else {
          debugPrint("[DEBUG] hasPendingWrites: false");
          // Clear flag and continue to last statement
          awaitsPillSheetGroupRemoteDBDataChanged = false;
        }
      }
      return false;
    }).map(((event) => _filter(event))));

final beforePillSheetGroupProvider = FutureProvider<PillSheetGroup?>((ref) async {
  final database = ref.watch(databaseProvider);
  final snapshot = await database.pillSheetGroupsReference().orderBy(PillSheetGroupFirestoreKeys.createdAt).limitToLast(2).get();
  if (snapshot.docs.length <= 1) {
    return null;
  }
  return snapshot.docs[0].data();
});

final batchSetPillSheetGroupProvider = Provider((ref) => BatchSetPillSheetGroup(ref.watch(databaseProvider)));

class BatchSetPillSheetGroup {
  final DatabaseConnection databaseConnection;
  BatchSetPillSheetGroup(this.databaseConnection);

  PillSheetGroup call(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    final doc = databaseConnection.pillSheetGroupReference(pillSheetGroup.id);
    batch.set(doc, pillSheetGroup, SetOptions(merge: true));
    return pillSheetGroup.copyWith(id: doc.id);
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
