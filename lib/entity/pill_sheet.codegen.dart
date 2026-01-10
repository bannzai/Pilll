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
// [PillSheet:v2] from: 2026-01-04. すべてをv2に一括で移行すると既存ユーザーにも不具合が波及する。
// なのでまずは2錠飲みユーザーに対してだけしばらく公開して様子を見ていく。
// 次の段階としては1錠服用のユーザーに対しても公開をしていく。
// ただし、2錠飲みのユーザーがどのくらいいるのかを把握して、明らかに少ない場合はこの限りではない。サポートをやめることも考慮する
@freezed
sealed class PillSheet with _$PillSheet {
  PillSheet._();

  /// v1: 従来の1錠飲みユーザー向け
  @JsonSerializable(explicitToJson: true)
  factory PillSheet.v1({
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
  factory PillSheet.v2({
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
    /// NOTE: DBから簡単に確認するための記録用プロパティ。実際の判定には pills[].takenCount を使用すること
    // required int pillTakenCount,

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
    required int pillTakenCount,
  }) {
    if (pillTakenCount > 1) {
      return PillSheet.v2(
        id: firestoreIDGenerator(),
        typeInfo: type.typeInfo,
        beginingDate: beginDate,
        lastTakenDate: lastTakenDate,
        createdAt: now(),
        // pillTakenCount: pillTakenCount,
        pills: Pill.generateAndFillTo(
          pillSheetType: type,
          fromDate: beginDate,
          lastTakenDate: lastTakenDate,
          pillTakenCount: pillTakenCount,
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
      return _$$PillSheetV2ImplFromJson(json);
    }
    return _$$PillSheetV1ImplFromJson(json);
  }

  /// 各 variant の toJson を呼び出す
  Map<String, dynamic> toJson() {
    return map(
      v1: (value) => _$$PillSheetV1ImplToJson(value as _$PillSheetV1Impl),
      v2: (value) => _$$PillSheetV2ImplToJson(value as _$PillSheetV2Impl),
    );
  }

  /// ピルシートの種類オブジェクト
  /// typeInfoから変換されたPillSheetType列挙値
  PillSheetType get pillSheetType => PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  /// 今日服用すべきピルの番号
  /// 1から始まる連番でピルシート内の位置を示す
  int get todayPillNumber {
    return pillNumberFor(targetDate: today());
  }

  /// 今日服用すべきピルのインデックス（0始まり）
  int get todayPillIndex {
    return todayPillNumber - 1;
  }

  // lastTakenPillNumber は最後に服了したピルの番号を返す
  // あえてnon nullにしている。なぜならよく比較するのでnullableだと不便だから
  // まだpillを飲んでない場合は `0` が変える。飲んでいる場合は 1以上の値が入る
  /// 最後に服用したピルの番号（0または1以上）
  /// まだ服用していない場合は0、服用済みの場合は1以上の値を返す
  /// null安全のため常に数値を返すバージョン
  int get lastTakenOrZeroPillNumber {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return 0;
    }

    // NOTE: [PillSheet:OLD_Calc_LastTakenPillNumber] 服用日が開始日より前の場合がある。服用日数を1つ目の1番目のピルシートに調整した時
    if (lastTakenDate.date().isBefore(beginingDate.date())) {
      return 0;
    }

    return pillNumberFor(targetDate: lastTakenDate);
  }

  /// 最後に服用したピルの番号（nullable）
  /// まだ服用していない場合や開始日より前の場合はnull
  /// 正確な服用状況を表現するnullableバージョン
  int? get lastTakenPillNumber {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return null;
    }

    // NOTE: [PillSheet:OLD_Calc_LastTakenPillNumber] 服用日が開始日より前の場合がある。服用日数を1つ目の1番目のピルシートに調整した時
    if (lastTakenDate.isBefore(beginingDate)) {
      return null;
    }

    return pillNumberFor(targetDate: lastTakenDate);
  }

  // 今日のピルをすでに飲んでいるかを確認する
  // 番号で比較しない(lastTakenPillNumber == todayPillNumber)理由は、各プロパティが上限値を超えないことを保証してないため。たとえばtodayPillNumberが30になることもありえる
  /// 今日のピルがすでに服用済みかどうか
  /// 最終服用日が今日以降の場合にtrueを返す
  /// @deprecated 1錠飲みでのみ使用。2錠飲み対応後は todayPillsAreAlreadyTaken を使用
  bool get todayPillIsAlreadyTaken {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return false;
    }
    return lastTakenDate.isAfter(today()) || isSameDay(lastTakenDate, today());
  }

  /// ピルシートの全てのピルを服用完了したかどうか
  /// 総ピル数と最終服用ピル番号を比較して判定
  bool get isTakenAll => typeInfo.totalCount == lastTakenOrZeroPillNumber;

  /// ピルシートの服用が開始されているかどうか
  /// 開始日が現在時刻より前の場合にtrueを返す
  bool get isBegan => beginingDate.date().toUtc().millisecondsSinceEpoch < now().toUtc().millisecondsSinceEpoch;

  /// 現在が休薬期間中かどうか
  /// 今日のピル番号が服用期間を超えている場合にtrueを返す
  bool get inNotTakenDuration => todayPillNumber > typeInfo.dosingPeriod;

  /// ピルシートが休薬期間または偽薬期間を持つかどうか
  /// 28日型シート（偽薬7日）などの場合にtrueを返す
  bool get pillSheetHasRestOrFakeDuration => pillSheetType.hasRestOrFakeDuration;

  /// ピルシートが現在アクティブ（有効）かどうか
  /// 現在日付がピルシートの有効期間内の場合にtrueを返す
  bool get isActive => isActiveFor(now());

  /// 指定した日付でピルシートがアクティブかどうかを判定
  /// ピルシートの開始日から予想終了日までの範囲内かをチェック
  bool isActiveFor(DateTime date) {
    return DateRange(beginingDate.date(), estimatedEndTakenDate).inRange(date);
  }

  /// ピルシートの予想服用完了日
  /// 開始日、総ピル数、休薬期間を考慮して計算される完了予定日
  DateTime get estimatedEndTakenDate => beginingDate
      .addDays(pillSheetType.totalCount - 1)
      .addDays(summarizedRestDuration(restDurations: restDurations, upperDate: today()))
      .date()
      .add(const Duration(days: 1))
      .subtract(const Duration(seconds: 1));

  /// 現在アクティブな休薬期間
  /// 現在継続中（endDateがnull）かつ開始済みの休薬期間を返す
  /// NOTE: beginDateは日付レベルで比較する。時刻を含めた比較だと、服用おやすみ開始日に
  /// lastTakenDateの時刻を過ぎるまで表示されない問題が発生するため
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

  // PillSheetのbeginDateは服用お休み中にbackendで毎日1日ずれるようになっているので、
  // ここで計算に考慮するのはこのPillSheetのrestDurationのみで良い
  /// 指定したピル番号の服用予定日を取得
  /// 休薬期間を考慮した実際の服用日を返す
  DateTime displayPillTakeDate(int pillNumberInPillSheet) {
    return dates[pillNumberInPillSheet - 1];
  }

  // NOTE: [PillSheet:OLD_Calc_LastTakenPillNumber] beginDate > targetDate(lastTakenDate) の場合がある。「本日の服用日」を編集して1番目を未服用にした場合
  // pillNumberは0は不自然なので、1番を返す
  /// 指定した日付に対応するピル番号を計算
  /// 開始日からの経過日数と休薬期間を考慮してピル番号を算出
  /// 最小値は1を保証
  int pillNumberFor({required DateTime targetDate}) {
    return max(daysBetween(beginingDate.date(), targetDate) - summarizedRestDuration(restDurations: restDurations, upperDate: targetDate) + 1, 1);
  }

  /// ピルシート内の各ピルの服用予定日リスト
  /// 休薬期間を考慮した実際の服用日程が格納される
  late final List<DateTime> dates = buildDates();

  // ピルシートのピルの日付を取得する
  /// ピルシートの各ピルの服用予定日を構築
  /// 休薬期間による日付の調整を行い、実際の服用スケジュールを生成
  /// estimatedEventCausingDateが指定された場合は過去の状態を再現
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
}

/// v2専用のプロパティ・メソッド
extension PillSheetV2Extension on PillSheetV2 {
  /// 最後に服用完了したピルの番号（0または1以上）
  /// 各ピルのtakenCount回すべて服用したピルの番号を返す
  int get lastCompletedPillNumber {
    final lastCompletedPill = pills.lastWhereOrNull((element) => element.isCompleted);
    if (lastCompletedPill == null) {
      return 0;
    }

    // 休薬期間を考慮したdatesプロパティを使用してピルの正確な日付を取得
    final dateOfLastCompletedPill = dates[lastCompletedPill.index];
    return pillNumberFor(targetDate: dateOfLastCompletedPill);
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

  /// 指定したピル番号のピルが、前日のピルが未完了のため押せない状態かどうか
  /// 前日のピルが未完了（0回でも）の場合はtrue
  bool isPillDisabled({required int pillNumberInPillSheet}) {
    final pillIndex = pillNumberInPillSheet - 1;
    // 1番目のピルは前日がないのでdisabledにならない
    if (pillIndex <= 0) {
      return false;
    }
    // 既に完了済みのピルはdisabledにならない
    if (pillIndex < pills.length && pills[pillIndex].isCompleted) {
      return false;
    }
    // 前日のピルが未完了ならdisabled
    final previousPillIndex = pillIndex - 1;
    if (previousPillIndex >= 0 && previousPillIndex < pills.length) {
      return !pills[previousPillIndex].isCompleted;
    }
    return false;
  }

  /// pillsリストの一部を置き換えたリストを返す
  /// 服用記録の更新時に使用
  List<Pill> replacedPills({required List<Pill> newPills}) {
    if (newPills.isEmpty) {
      return pills;
    }
    assert(newPills.first.index >= 0 && newPills.last.index < pills.length, 'newPills indices are out of bounds');
    // indexがはみ出た場合は早期リターン
    if (newPills.first.index < 0 || newPills.last.index >= pills.length) {
      return pills;
    }
    return [...pills]..replaceRange(newPills.first.index, newPills.last.index + 1, newPills);
  }
}

/// 指定日までの総休薬日数を計算
/// lastTakenDateやtodayなどの基準日までの累積休薬期間を集計
/// ピル番号計算時の日数調整に使用される
int summarizedRestDuration({
  required List<RestDuration> restDurations,
  required DateTime upperDate,
}) {
  if (restDurations.isEmpty) {
    return 0;
  }
  return restDurations.map((e) {
    // upperDate よりも後の休薬期間の場合は無視する。同一日は無視しないので、!upperDate.isAfter(e.beginDate)では無い
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
