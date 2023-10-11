import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pill_sheet_group.g.dart';

// この変数にtrueを入れることでMetadata.hasPendingWritesがfalseの場合=リモートDBに書き込まれた場合にStreamの値を流すように制御できる。
// Pilllではアプリを開いている時に複数箇所からのDB書き込みが無いので(ごくまれにBackendで書き込みと被る可能性はある)単純なフラグ制御を採用している
// TODO: [UseLocalNotification-Beta] 2023-11 服用通知での問題は解決するし一回消す
bool awaitsPillSheetGroupRemoteDBDataChanged = false;
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
  }).map(((event) => _filter(event)));
}

// 一つ前のピルシートグループを取得する。破棄されたピルシートグループは現在めないようにしているが含めるようにしても良い。インデックスを作成する必要があるので避けている
@Riverpod(dependencies: [database])
Future<PillSheetGroup?> beforePillSheetGroup(BeforePillSheetGroupRef ref) async {
  final database = ref.watch(databaseProvider);
  // 後述するwhereでdeletedAt is nullの場合の物を抽出する。とりあえず5件くらい取得すればどれかはdeletedAtはnullだろうと予想している
  // PillSheetGroupのidをDBに保存していなかったので、PillSheetModifiedHistory.afterPillSheetGroup.id指定でのDBからの取得ができなかった(入れ子になっている構造体のIDで取得できる可動かは要確認が必要。未確認)
  // この時の問題点が続けてdeleteしたPillSheetGroupがあると日付がPillSheetModifiedHistoryを取得する際の日付指定が被ってしまい関係のないピルシートグループの履歴まで取得できてしまう点にある
  // なので、致し方なくdeletedAt is nullの条件を追加して連続で削除しても履歴取得の際には日付が被らないようにしている。
  // TODO: [PillSheetModifiedHistory-V2] 2024-05-01 ここでの取得をPillSheetModifiedHistory.afterPillSheetGroup.id指定でのDBからの取得に変更する
  // PillSheetGroupのidをDBに保存していなかったので、PillSheetModifiedHistory.afterPillSheetGroup.id指定でのDBからの取得ができなかった(入れ子になっている構造体のIDで取得できる可動かは要確認が必要。未確認)
  final snapshot = await database.pillSheetGroupsReference().orderBy(PillSheetGroupFirestoreKeys.createdAt).limitToLast(5).get();

  if (snapshot.docs.isEmpty) {
    return null;
  }

  // 前回のピルシートグループが存在する場合で、まだ今回のピルシートグループを作っていない状態が発生する
  // なので、今回のピルシートグループが存在しないかどうかをチェックして、存在しない場合は前回のピルシートグループを返す
  if (snapshot.docs.length == 1) {
    return snapshot.docs.first.data();
  }

  return snapshot.docs.map((e) => e.data()).where((element) => element.deletedAt == null).lastOrNull;
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
