import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'pill_sheet.codegen.g.dart';
part 'pill_sheet.codegen.freezed.dart';

/// Firestoreのピルシートドキュメントで使用されるフィールドキーの定数を管理するクラス
/// データベースアクセス時のタイポを防ぎ、フィールド名の一元管理を行う
class PillSheetFirestoreKey {
  /// ピルシートの種類情報フィールドキー
  static const String typeInfo = 'typeInfo';

  /// 作成日時フィールドキー
  static const String createdAt = 'createdAt';

  /// 削除日時フィールドキー
  static const String deletedAt = 'deletedAt';

  /// 最終服用日フィールドキー
  static const String lastTakenDate = 'lastTakenDate';

  /// 開始日フィールドキー
  static const String beginingDate = 'beginingDate';
}

/// ピルシートの種類に関する情報を格納するクラス
/// 28日型、21日型など異なるピルシートの種類ごとの設定情報を保持
/// Firestoreドキュメントとして保存される基本的なピル情報
@freezed
class PillSheetTypeInfo with _$PillSheetTypeInfo {
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetTypeInfo({
    /// ピルシート種類の参照パス（Firestore参照）
    /// 具体的なピルシート設定情報への参照を保持
    required String pillSheetTypeReferencePath,

    /// ピルシート名（例：「マーベロン28」）
    /// ユーザーに表示される商品名
    required String name,

    /// ピルシート内の総ピル数
    /// 21錠、28錠など、シートに含まれる全てのピル数
    required int totalCount,

    /// 服用期間（実薬期間）の日数
    /// 偽薬を除いた実際に効果のあるピルの服用日数
    required int dosingPeriod,
  }) = _PillSheetTypeInfo;

  factory PillSheetTypeInfo.fromJson(Map<String, dynamic> json) => _$PillSheetTypeInfoFromJson(json);
}

/// ピル服用の休薬期間を表現するクラス
/// ユーザーが一時的にピル服用を停止した期間の記録を管理
/// 服用スケジュールの再計算に使用される
@freezed
class RestDuration with _$RestDuration {
  @JsonSerializable(explicitToJson: true)
  const factory RestDuration({
    // from: 2024-03-28の実装時に追加。調査しやすいようにuuidを入れておく
    /// 休薬期間の一意識別子
    /// デバッグや調査時の追跡のためのUUID
    required String? id,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )

    /// 休薬開始日
    /// ユーザーがピル服用を停止した日付
    required DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )

    /// 休薬終了日（継続中の場合はnull）
    /// 服用を再開した日付、まだ再開していない場合はnull
    DateTime? endDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )

    /// 休薬期間レコードの作成日時
    /// このデータが作成された日時（ユーザーが休薬を開始した日とは異なる場合がある）
    required DateTime createdDate,
  }) = _RestDuration;
  const RestDuration._();

  factory RestDuration.fromJson(Map<String, dynamic> json) => _$RestDurationFromJson(json);

  /// 休薬期間のDateTimeRange表現
  /// endDateがnullの場合（継続中）はnullを返す
  DateTimeRange? get dateTimeRange => endDate == null ? null : DateTimeRange(start: beginDate, end: endDate!);
}

/// ピルシートのメインエンティティクラス
/// 個々のピルシートの服用状況、開始日、休薬期間などの情報を管理
/// Firestoreのピルシートドキュメントと1対1で対応する
/// ピル服用管理アプリの中核となるデータ構造
///
/// v1: 従来の1錠飲みユーザー向け
/// v2: 2錠飲み対応（pills, pillTakenCount フィールドを持つ）
@freezed
sealed class PillSheet with _$PillSheet {
  const PillSheet._();

  /// v1: 従来の1錠飲みユーザー向け
  @JsonSerializable(explicitToJson: true)
  const factory PillSheet.v1({
    /// FirestoreドキュメントID
    /// データベース保存時に自動生成される一意識別子
    @JsonKey(includeIfNull: false) required String? id,

    /// ピルシートの種類情報
    /// シート名、総数、服用期間などの基本設定
    @JsonKey() required PillSheetTypeInfo typeInfo,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )

    /// ピルシート開始日
    /// このシートでピル服用を開始した日付
    required DateTime beginingDate,

    // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )

    /// 最後にピルを服用した日付
    /// まだ一度も服用していない場合はnull
    required DateTime? lastTakenDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )

    /// ピルシートの作成日時
    /// このデータがFirestoreに作成された日時
    required DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )

    /// ピルシートの削除日時
    /// 削除されていない場合はnull
    DateTime? deletedAt,

    /// グループインデックス
    /// 複数のピルシートをグループ化する際の順序番号
    @Default(0) int groupIndex,

    /// 休薬期間のリスト
    /// このピルシート期間中の全ての休薬期間記録
    @Default([]) List<RestDuration> restDurations,

    /// バージョン識別子
    @Default('v1') String version,
  }) = PillSheetV1;

  /// v2: 2錠飲み対応
  @JsonSerializable(explicitToJson: true)
  const factory PillSheet.v2({
    /// FirestoreドキュメントID
    /// データベース保存時に自動生成される一意識別子
    @JsonKey(includeIfNull: false) required String? id,

    /// ピルシートの種類情報
    /// シート名、総数、服用期間などの基本設定
    @JsonKey() required PillSheetTypeInfo typeInfo,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )

    /// ピルシート開始日
    /// このシートでピル服用を開始した日付
    required DateTime beginingDate,

    // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )

    /// 最後にピルを服用した日付
    /// まだ一度も服用していない場合はnull
    required DateTime? lastTakenDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )

    /// ピルシートの作成日時
    /// このデータがFirestoreに作成された日時
    required DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )

    /// ピルシートの削除日時
    /// 削除されていない場合はnull
    DateTime? deletedAt,

    /// グループインデックス
    /// 複数のピルシートをグループ化する際の順序番号
    @Default(0) int groupIndex,

    /// 休薬期間のリスト
    /// このピルシート期間中の全ての休薬期間記録
    @Default([]) List<RestDuration> restDurations,

    /// 1回の服用で飲むピルの錠数
    /// 2錠飲みの場合は2がセットされる
    required int pillTakenCount,

    /// 各ピルの詳細情報リスト
    /// 2錠飲み対応のため、各ピルごとの服用記録を管理
    required List<Pill> pills,

    /// バージョン識別子
    @Default('v2') String version,
  }) = PillSheetV2;

  /// テスト用のピルシート作成ファクトリメソッド
  /// pillTakenCount > 1 の場合は v2、それ以外は v1 を返す
  @visibleForTesting
  factory PillSheet.create(
    PillSheetType type, {
    required DateTime beginDate,
    required DateTime? lastTakenDate,
    int? pillTakenCount,
  }) {
    final count = pillTakenCount ?? 1;
    if (count > 1) {
      return PillSheet.v2(
        id: firestoreIDGenerator(),
        typeInfo: type.typeInfo,
        beginingDate: beginDate,
        lastTakenDate: lastTakenDate,
        createdAt: now(),
        pillTakenCount: count,
        pills: Pill.generateAndFillTo(
          pillSheetType: type,
          fromDate: beginDate,
          lastTakenDate: lastTakenDate,
          pillTakenCount: count,
        ),
      );
    }
    return PillSheet.v1(
      id: firestoreIDGenerator(),
      typeInfo: type.typeInfo,
      beginingDate: beginDate,
      lastTakenDate: lastTakenDate,
      createdAt: now(),
    );
  }

  /// カスタム fromJson で version フィールドを見て分岐
  factory PillSheet.fromJson(Map<String, dynamic> json) {
    final version = json['version'] as String?;
    if (version == 'v2') {
      return PillSheetV2.fromJson(json);
    }
    return PillSheetV1.fromJson(json);
  }

  /// 各 variant の toJson を呼び出す
  Map<String, dynamic> toJson() {
    switch (this) {
      case PillSheetV1():
        return (this as PillSheetV1).toJson();
      case PillSheetV2():
        return (this as PillSheetV2).toJson();
    }
  }

  /// ピルシートの種類オブジェクト
  PillSheetType get pillSheetType => PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  /// 今日服用すべきピルの番号（1始まり）
  int get todayPillNumber {
    return pillNumberFor(targetDate: today());
  }

  /// 今日服用すべきピルのインデックス（0始まり）
  int get todayPillIndex {
    return todayPillNumber - 1;
  }

  /// 最後に服用したピルの番号（0または1以上）
  int get lastTakenOrZeroPillNumber {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return 0;
    }

    // NOTE: [PillSheet:OLD_Calc_LastTakenPillNumber] 服用日が開始日より前の場合がある
    if (lastTakenDate.date().isBefore(beginingDate.date())) {
      return 0;
    }

    return pillNumberFor(targetDate: lastTakenDate);
  }

  /// 最後に服用したピルの番号（nullable）
  int? get lastTakenPillNumber {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return null;
    }

    if (lastTakenDate.isBefore(beginingDate)) {
      return null;
    }

    return pillNumberFor(targetDate: lastTakenDate);
  }

  /// 今日のピルがすでに服用済みかどうか（v1用）
  bool get todayPillIsAlreadyTaken {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return false;
    }
    return lastTakenDate.isAfter(today()) || isSameDay(lastTakenDate, today());
  }

  /// ピルシートの全てのピルを服用完了したかどうか
  bool get isTakenAll => typeInfo.totalCount == lastTakenOrZeroPillNumber;

  /// ピルシートの服用が開始されているかどうか
  bool get isBegan => beginingDate.date().toUtc().millisecondsSinceEpoch < now().toUtc().millisecondsSinceEpoch;

  /// 現在が休薬期間中かどうか
  bool get inNotTakenDuration => todayPillNumber > typeInfo.dosingPeriod;

  /// ピルシートが休薬期間または偽薬期間を持つかどうか
  bool get pillSheetHasRestOrFakeDuration => pillSheetType.hasRestOrFakeDuration;

  /// ピルシートが現在アクティブ（有効）かどうか
  bool get isActive => isActiveFor(now());

  /// 指定した日付でピルシートがアクティブかどうかを判定
  bool isActiveFor(DateTime date) {
    return DateRange(beginingDate.date(), estimatedEndTakenDate).inRange(date);
  }

  /// ピルシートの予想服用完了日
  DateTime get estimatedEndTakenDate => beginingDate
      .addDays(pillSheetType.totalCount - 1)
      .addDays(summarizedRestDuration(restDurations: restDurations, upperDate: today()))
      .date()
      .add(const Duration(days: 1))
      .subtract(const Duration(seconds: 1));

  /// 現在アクティブな休薬期間
  RestDuration? get activeRestDuration {
    if (restDurations.isEmpty) {
      return null;
    } else {
      if (restDurations.last.endDate == null && !restDurations.last.beginDate.date().isAfter(today())) {
        return restDurations.last;
      } else {
        return null;
      }
    }
  }

  /// 指定したピル番号の服用予定日を取得
  DateTime displayPillTakeDate(int pillNumberInPillSheet) {
    return dates[pillNumberInPillSheet - 1];
  }

  /// 指定した日付に対応するピル番号を計算
  int pillNumberFor({required DateTime targetDate}) {
    return max(daysBetween(beginingDate.date(), targetDate) - summarizedRestDuration(restDurations: restDurations, upperDate: targetDate) + 1, 1);
  }

  /// ピルシート内の各ピルの服用予定日リスト
  late final List<DateTime> dates = buildDates();

  /// ピルシートの各ピルの服用予定日を構築
  List<DateTime> buildDates({DateTime? estimatedEventCausingDate}) {
    final List<DateTime> dates = [];
    var offset = 0;
    for (int index = 0; index < typeInfo.totalCount; index++) {
      var date = beginingDate.addDays(index + offset).date();

      for (final restDuration in restDurations) {
        if (restDuration.beginDate.isBefore(date) || isSameDay(restDuration.beginDate, date)) {
          final upperDate = estimatedEventCausingDate ?? today().date();
          final restDurationEndDateOrUpperDate = restDuration.endDate ?? upperDate;
          if (restDurationEndDateOrUpperDate.isAfter(date)) {
            final diff = daysBetween(date, restDurationEndDateOrUpperDate);
            date = date.addDays(diff);
            offset += diff;
          }
        }
      }

      dates.add(date);
    }
    return dates;
  }

  /// ピルシートが終了したかどうか
  /// v1: lastTakenOrZeroPillNumber で判定
  /// v2: lastCompletedPillNumber で判定
  bool get isEnded {
    switch (this) {
      case PillSheetV1():
        return typeInfo.totalCount == lastTakenOrZeroPillNumber;
      case PillSheetV2(:final pills, :final pillTakenCount):
        final lastCompletedPill = pills.lastWhereOrNull((element) => element.pillTakens.length == pillTakenCount);
        if (lastCompletedPill == null) {
          return false;
        }
        final estimatedLastTakenDate = beginingDate.add(Duration(days: lastCompletedPill.index)).date();
        final lastCompletedPillNumber = pillNumberFor(targetDate: estimatedLastTakenDate);
        return typeInfo.totalCount == lastCompletedPillNumber;
    }
  }
}

/// v2専用のプロパティ・メソッド
extension PillSheetV2Extension on PillSheetV2 {
  /// 最後に服用完了したピルの番号（0または1以上）
  /// pillTakenCount回すべて服用したピルの番号を返す
  int get lastCompletedPillNumber {
    final lastCompletedPill = pills.lastWhereOrNull((element) => element.pillTakens.length == pillTakenCount);
    if (lastCompletedPill == null) {
      return 0;
    }

    final estimatedLastTakenDate = beginingDate.add(Duration(days: lastCompletedPill.index)).date();
    return pillNumberFor(targetDate: estimatedLastTakenDate);
  }

  /// 今日のピルがすべて服用完了したかどうか
  bool get todayPillsAreAlreadyTaken {
    return lastCompletedPillNumber == todayPillNumber;
  }

  /// 今日のピルがいずれか服用済みかどうか
  bool get anyTodayPillsAreAlreadyTaken {
    if (todayPillIndex < 0 || todayPillIndex >= pills.length) {
      return false;
    }
    return pills[todayPillIndex].pillTakens.isNotEmpty;
  }

  /// pillsリストの一部を置き換えたリストを返す
  List<Pill> replacedPills({required List<Pill> newPills}) {
    if (newPills.isEmpty) {
      return pills;
    }
    return [...pills]..replaceRange(newPills.first.index, newPills.last.index + 1, newPills);
  }
}

/// 指定日までの総休薬日数を計算
int summarizedRestDuration({
  required List<RestDuration> restDurations,
  required DateTime upperDate,
}) {
  if (restDurations.isEmpty) {
    return 0;
  }
  return restDurations.map((e) {
    if (!e.beginDate.isBefore(upperDate)) {
      return 0;
    }

    final endDate = e.endDate;
    if (endDate == null) {
      return daysBetween(e.beginDate, upperDate);
    }

    return daysBetween(e.beginDate, endDate);
  }).reduce((value, element) => value + element);
}
