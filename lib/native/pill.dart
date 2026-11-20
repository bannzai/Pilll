import 'dart:async';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/customer_info.dart';
import 'package:pilll/provider/database.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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

  /// 服用お休み中のため、記録しなかった
  restDuration,

  /// 記録を端末に書き込んだが、サーバーへの保存の完了を待ち時間の内に確かめられなかった
  pendingSync,

  /// ログインしていない・ユーザーの情報が無いため、記録しなかった
  notSignedIn,

  /// 記録の途中で失敗した
  failed,
}

/// App Intent (Siri・ショートカット) から今日の服用を記録し、結果を返す。例外は投げず、失敗は failed として返して errorLogger に記録する。
/// 通知からのクイックレコードと同じくプレミアムの機能のため、プレミアムでもトライアル中でもない user では記録しない。
/// プレミアム・トライアルの判定の正は RevenueCat の CustomerInfo で、fetchCustomerInfo で取得する。取得に失敗した時は、課金していない状態を作って判定せずに failed を返す。
/// 記録した時だけ、記録後の PillSheetGroup で syncAfterRecord (ウィジェットと通知の更新) を呼ぶ。
/// syncAfterRecord が失敗しても、記録は済んでいるため recorded を返す。
/// user・CustomerInfo・PillSheetGroup の取得と記録後の更新を関数で受け取るのは、Firestore・RevenueCat と通知の plugin を使わずにテストするため。
/// 服用お休み中は、アプリの記録画面が「飲んだ」ボタンを出さない (RecordPageButton) のに合わせて記録しない。
/// TakePill が takePillTimeout の内に終わらない時は pendingSync を返す。返した後に TakePill が記録を終えた時は、その時点で syncAfterRecord を呼ぶ (返答は待たない)。
/// Firestore の書き込みは、オフラインの間は端末に書き込まれた後もサーバーが受け付けるまで完了しないため、待ち続けると返答を返せない。
/// 冪等ではない (1 日に複数回服用する設定では、呼ぶたびに未服用の 1 回分を記録するため)
Future<AppIntentRecordPillResult> recordPillFromAppIntent({
  required Future<User?> Function() fetchUser,
  required Future<CustomerInfo> Function() fetchCustomerInfo,
  required Future<PillSheetGroup?> Function() fetchPillSheetGroup,
  required TakePill takePill,
  required Duration takePillTimeout,
  required Future<void> Function(PillSheetGroup pillSheetGroup) syncAfterRecord,
}) async {
  final PillSheetGroup updatedPillSheetGroup;
  try {
    final user = await fetchUser();
    if (user == null) {
      return AppIntentRecordPillResult.notSignedIn;
    }
    if (!(await fetchCustomerInfo()).premiumOrTrial(user: user)) {
      return AppIntentRecordPillResult.notPremiumOrTrial;
    }
    final pillSheetGroup = await fetchPillSheetGroup();
    final activePillSheet = pillSheetGroup?.activePillSheet;
    if (pillSheetGroup == null || activePillSheet == null) {
      return AppIntentRecordPillResult.noActivePillSheet;
    }
    if (pillSheetGroup.lastActiveRestDuration != null) {
      return AppIntentRecordPillResult.restDuration;
    }
    if (shouldSkipQuickRecord(activePillSheet)) {
      return AppIntentRecordPillResult.alreadyTaken;
    }

    final PillSheetGroup? takenPillSheetGroup;
    // 保留として返すのは、記録の書き込みを待った時だけにする (user や PillSheetGroup の取得が投げた TimeoutException は、何も書き込んでいないため failed にする)
    final takingPillSheetGroup = _takePillNowAsQuickRecord(
      takePill: takePill,
      pillSheetGroup: pillSheetGroup,
      activePillSheet: activePillSheet,
    );
    try {
      takenPillSheetGroup = await takingPillSheetGroup.timeout(takePillTimeout);
    } on TimeoutException {
      // 保留として返した後に書き込みが終わった時も、服用済みの分の通知が届かないように syncAfterRecord を呼ぶ。
      // 書き込みと syncAfterRecord の失敗は、返答では伝えられないため errorLogger に残す
      unawaited(
        takingPillSheetGroup.then<void>((lateTakenPillSheetGroup) async {
          if (lateTakenPillSheetGroup != null) {
            await syncAfterRecord(lateTakenPillSheetGroup);
          }
        }).catchError(
          (Object e, StackTrace st) => errorLogger.recordError(e, st),
        ),
      );
      return AppIntentRecordPillResult.pendingSync;
    }
    if (takenPillSheetGroup == null) {
      return AppIntentRecordPillResult.failed;
    }
    updatedPillSheetGroup = takenPillSheetGroup;
  } catch (e, st) {
    errorLogger.recordError(e, st);
    return AppIntentRecordPillResult.failed;
  }

  try {
    await syncAfterRecord(updatedPillSheetGroup);
  } catch (e, st) {
    errorLogger.recordError(e, st);
  }
  return AppIntentRecordPillResult.recorded;
}
