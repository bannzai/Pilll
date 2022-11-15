import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:riverpod/riverpod.dart';

PillSheetGroup? _filter(QuerySnapshot<PillSheetGroup> snapshot) {
  if (snapshot.docs.isEmpty) return null;
  if (!snapshot.docs.last.exists) return null;
  return snapshot.docs.last.data();
}

final latestPillSheetGroupProvider = StreamProvider((ref) => ref
    .watch(databaseProvider)
    .pillSheetGroupsReference()
    .orderBy(PillSheetGroupFirestoreKeys.createdAt)
    .limitToLast(1)
    .snapshots()
    .map(((event) => _filter(event))));

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
