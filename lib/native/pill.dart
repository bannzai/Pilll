import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/database.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';

/// クイックレコードで服用済みかどうかを判定する
/// v1: 1錠飲みなので todayPillIsAlreadyTaken で判定
/// v2: 2錠飲み対応なので todayPillAllTaken で判定（両方完了している場合のみtrue）
bool shouldSkipQuickRecord(PillSheet activePillSheet) {
  return switch (activePillSheet) {
    PillSheetV1() => activePillSheet.todayPillIsAlreadyTaken,
    PillSheetV2() => activePillSheet.todayPillAllTaken,
  };
}

Future<PillSheetGroup?> quickRecordTakePill(DatabaseConnection database) async {
  final pillSheetGroup = await fetchLatestPillSheetGroup(database);
  if (pillSheetGroup == null) {
    return null;
  }
  final activePillSheet = pillSheetGroup.activePillSheet;
  if (activePillSheet == null) {
    return pillSheetGroup;
  }
  if (shouldSkipQuickRecord(activePillSheet)) {
    return pillSheetGroup;
  }

  return _takePillNowAsQuickRecord(
    takePill: quickRecordTakePillOf(database),
    pillSheetGroup: pillSheetGroup,
    activePillSheet: activePillSheet,
  );
}

/// 画面 (Riverpod の Provider) の外から服用を記録する経路 (通知の「飲んだ」・App Intent) が使う TakePill を返す
TakePill quickRecordTakePillOf(DatabaseConnection database) {
  return TakePill(
    batchFactory: BatchFactory(database),
    batchSetPillSheetModifiedHistory: BatchSetPillSheetModifiedHistory(
      database,
    ),
    batchSetPillSheetGroup: BatchSetPillSheetGroup(database),
  );
}

/// 今の時刻でクイックレコードとして服用を記録し、記録後の PillSheetGroup を返す。
/// TakePill が記録しなかった時 (服用済み・更新するピルシートが無い) は null を返す。
/// TakePill が例外を投げなければ、記録したかどうかにかかわらずアプリのバッジを消し、quick_recorded のイベントを送る
Future<PillSheetGroup?> _takePillNowAsQuickRecord({
  required TakePill takePill,
  required PillSheetGroup pillSheetGroup,
  required PillSheet activePillSheet,
}) async {
  final updatedPillSheetGroup = await takePill(
    takenDate: now(),
    pillSheetGroup: pillSheetGroup,
    activePillSheet: activePillSheet,
    isQuickRecord: true,
  );

  // NOTE: iOSではAppDelegate.swiftの方で先にバッジのカウントはクリアしている
  AppBadgePlus.updateBadge(0);

  // NOTE: Firebase initializeが成功しているかが定かでは無いので一番最後にログを送る
  analytics.logEvent(name: 'quick_recorded');

  return updatedPillSheetGroup;
}

/// App Intent (Siri・ショートカット) からの服用記録の結果。
/// name を iOS 側 (ios/Runner/RecordPillIntent.swift) に返し、iOS 側が返答の文言を出し分ける
enum AppIntentRecordPillResult {
  /// 服用を記録した
  recorded,

  /// 今日の分は服用済みで、記録しなかった
  alreadyTaken,

  /// プレミアムでもトライアル中でもないため、記録しなかった
  notPremiumOrTrial,

  /// 記録する先のピルシートが無く、記録しなかった
  noActivePillSheet,

  /// ログインしていない・ユーザーの情報が無いため、記録しなかった
  notSignedIn,

  /// 記録の途中で失敗した
  failed,
}

/// App Intent (Siri・ショートカット) から今日の服用を記録し、結果と記録後の PillSheetGroup を返す。
/// 通知からのクイックレコードと同じくプレミアムの機能のため、プレミアムでもトライアル中でもない user では記録しない。
/// 記録しなかった時の PillSheetGroup は受け取った値のまま返す
Future<(AppIntentRecordPillResult, PillSheetGroup?)> recordPillFromAppIntent({
  required User user,
  required PillSheetGroup? pillSheetGroup,
  required TakePill takePill,
}) async {
  if (!user.premiumOrTrial) {
    return (AppIntentRecordPillResult.notPremiumOrTrial, pillSheetGroup);
  }
  final activePillSheet = pillSheetGroup?.activePillSheet;
  if (pillSheetGroup == null || activePillSheet == null) {
    return (AppIntentRecordPillResult.noActivePillSheet, pillSheetGroup);
  }
  if (shouldSkipQuickRecord(activePillSheet)) {
    return (AppIntentRecordPillResult.alreadyTaken, pillSheetGroup);
  }

  final updatedPillSheetGroup = await _takePillNowAsQuickRecord(
    takePill: takePill,
    pillSheetGroup: pillSheetGroup,
    activePillSheet: activePillSheet,
  );
  if (updatedPillSheetGroup == null) {
    return (AppIntentRecordPillResult.failed, pillSheetGroup);
  }
  return (AppIntentRecordPillResult.recorded, updatedPillSheetGroup);
}
