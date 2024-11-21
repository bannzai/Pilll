import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pill_sheet_group.g.dart';

PillSheetGroup? _filter(QuerySnapshot<PillSheetGroup> snapshot) {
  if (snapshot.docs.isEmpty) return null;
  if (!snapshot.docs.last.exists) return null;

  return snapshot.docs.last.data();
}

// 最新のピルシートグループを取得する。ピルシートグループが初期設定で作られないパターンもあるのでNullable
Future<PillSheetGroup?> fetchLatestPillSheetGroup(DatabaseConnection databaseConnection) async {
  return (await databaseConnection.pillSheetGroupsReference().orderBy(PillSheetGroupFirestoreKeys.createdAt).limitToLast(1).get())
      .docs
      .lastOrNull
      ?.data();
}

// 最新のピルシートグループの.activePillSheetを取得する。
@Riverpod(dependencies: [latestPillSheetGroup])
AsyncValue<PillSheet?> activePillSheet(ActivePillSheetRef ref) {
  return ref.watch(latestPillSheetGroupProvider).whenData((value) => value?.activePillSheet);
}

@Riverpod(dependencies: [database])
Stream<PillSheetGroup?> latestPillSheetGroup(LatestPillSheetGroupRef ref) {
// 最新のピルシートグループを取得する。ピルシートグループが初期設定で作られないパターンもあるのでNullable
  return ref
      .watch(databaseProvider)
      .pillSheetGroupsReference()
      .orderBy(PillSheetGroupFirestoreKeys.createdAt)
      .limitToLast(1)
      .snapshots(includeMetadataChanges: true)
      .map(((event) => _filter(event)));
}

// 一つ前のピルシートグループを取得する。破棄されたピルシートグループは現在含んでいるが含めないようにしても良い。インデックスを作成する必要があるので避けている
@Riverpod(dependencies: [database])
Future<PillSheetGroup?> beforePillSheetGroup(BeforePillSheetGroupRef ref) async {
  final database = ref.watch(databaseProvider);
  final snapshot = await database.pillSheetGroupsReference().orderBy(PillSheetGroupFirestoreKeys.createdAt).limitToLast(2).get();

  if (snapshot.docs.isEmpty) {
    return null;
  }

  // 前回のピルシートグループが存在する場合で、まだ今回のピルシートグループを作っていない状態が発生する
  // なので、今回のピルシートグループが存在しないかどうかをチェックして、存在しない場合は前回のピルシートグループを返す
  if (snapshot.docs.length == 1) {
    return snapshot.docs.first.data();
  }

  return snapshot.docs.last.data();
}

@Riverpod(dependencies: [database])
BatchSetPillSheetGroup batchSetPillSheetGroup(BatchSetPillSheetGroupRef ref) {
  return BatchSetPillSheetGroup(ref.watch(databaseProvider));
}

class BatchSetPillSheetGroup {
  final DatabaseConnection databaseConnection;
  BatchSetPillSheetGroup(this.databaseConnection);

  PillSheetGroup call(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    final doc = databaseConnection.pillSheetGroupReference(pillSheetGroup.id);
    batch.set(doc, pillSheetGroup, SetOptions(merge: true));
    return pillSheetGroup.copyWith(id: doc.id);
  }
}

@Riverpod(dependencies: [database])
SetPillSheetGroup setPillSheetGroup(SetPillSheetGroupRef ref) {
  return SetPillSheetGroup(ref.watch(databaseProvider));
}

class SetPillSheetGroup {
  final DatabaseConnection databaseConnection;
  SetPillSheetGroup(this.databaseConnection);

  Future<void> call(PillSheetGroup pillSheetGroup) async {
    await databaseConnection.pillSheetGroupReference(pillSheetGroup.id).set(pillSheetGroup, SetOptions(merge: true));
  }
}
