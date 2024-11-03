import 'package:flutter/material.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
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

class PillSheetFirestoreKey {
  static const String typeInfo = 'typeInfo';
  static const String createdAt = 'createdAt';
  static const String deletedAt = 'deletedAt';
  static const String lastTakenDate = 'lastTakenDate';
  static const String beginingDate = 'beginingDate';
}

@freezed
class PillSheetTypeInfo with _$PillSheetTypeInfo {
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetTypeInfo({
    required String pillSheetTypeReferencePath,
    required String name,
    required int totalCount,
    required int dosingPeriod,
  }) = _PillSheetTypeInfo;

  factory PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$PillSheetTypeInfoFromJson(json);
}

@freezed
class RestDuration with _$RestDuration {
  @JsonSerializable(explicitToJson: true)
  const factory RestDuration({
    // from: 2024-03-28の実装時に追加。調査しやすいようにuuidを入れておく
    required String? id,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? endDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdDate,
  }) = _RestDuration;
  const RestDuration._();

  factory RestDuration.fromJson(Map<String, dynamic> json) =>
      _$RestDurationFromJson(json);

  DateTimeRange? get dateTimeRange =>
      endDate == null ? null : DateTimeRange(start: beginDate, end: endDate!);
}

@freezed
class PillSheet with _$PillSheet {
  String? get documentID => id;

  PillSheetType get sheetType =>
      PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  PillSheet._();
  @JsonSerializable(explicitToJson: true)
  factory PillSheet({
    @JsonKey(includeIfNull: false) required String? id,
    @JsonKey() required PillSheetTypeInfo typeInfo,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime beginingDate,
    // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required DateTime? lastTakenDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? deletedAt,
    @Default(0) int groupIndex,
    @Default([]) List<RestDuration> restDurations,
  }) = _PillSheet;

  // NOTE: visibleForTestingを消すならpillTakenCountもrequiredにする
  @visibleForTesting
  factory PillSheet.create(
    PillSheetType type, {
    required DateTime beginDate,
    required DateTime? lastTakenDate,
    int? pillTakenCount,
  }) =>
      PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: type.typeInfo,
        beginingDate: beginDate,
        lastTakenDate: lastTakenDate,
        createdAt: now(),
      );

  factory PillSheet.fromJson(Map<String, dynamic> json) =>
      _$PillSheetFromJson(json);

  PillSheetType get pillSheetType =>
      PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  int get todayPillNumber {
    return pillNumberFor(targetDate: today());
  }

  // lastTakenPillNumber は最後に服了したピルの番号を返す
  // あえてnon nullにしている。なぜならよく比較するのでnullableだと不便だから
  // まだpillを飲んでない場合は `0` が変える。飲んでいる場合は 1以上の値が入る
  int get lastTakenPillNumber {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return 0;
    }

    return pillNumberFor(targetDate: lastTakenDate);
  }

  // 今日のピルをすでに飲んでいるかを確認する
  // 番号で比較しない(lastTakenPillNumber == todayPillNumber)理由は、各プロパティが上限値を超えないことを保証してないため。たとえばtodayPillNumberが30になることもありえる
  bool get todayPillIsAlreadyTaken {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return false;
    }
    return lastTakenDate.isAfter(today()) || isSameDay(lastTakenDate, today());
  }

  bool get isTakenAll => typeInfo.totalCount == lastTakenPillNumber;
  bool get isBegan =>
      beginingDate.date().toUtc().millisecondsSinceEpoch <
      now().toUtc().millisecondsSinceEpoch;
  bool get inNotTakenDuration => todayPillNumber > typeInfo.dosingPeriod;
  bool get pillSheetHasRestOrFakeDuration =>
      !pillSheetType.isNotExistsNotTakenDuration;
  bool get isActive => isActiveFor(now());

  bool isActiveFor(DateTime date) {
    return DateRange(beginingDate.date(), estimatedEndTakenDate).inRange(date);
  }

  DateTime get estimatedEndTakenDate => beginingDate
      .addDays(pillSheetType.totalCount - 1)
      .addDays(summarizedRestDuration(
          restDurations: restDurations, upperDate: today()))
      .date()
      .add(const Duration(days: 1))
      .subtract(const Duration(seconds: 1));

  RestDuration? get activeRestDuration {
    if (restDurations.isEmpty) {
      return null;
    } else {
      if (restDurations.last.endDate == null &&
          restDurations.last.beginDate.isBefore(now())) {
        return restDurations.last;
      } else {
        return null;
      }
    }
  }

  // PillSheetのbeginDateは服用お休み中にbackendで毎日1日ずれるようになっているので、
  // ここで計算に考慮するのはこのPillSheetのrestDurationのみで良い
  DateTime displayPillTakeDate(int pillNumberInPillSheet) {
    return dates[pillNumberInPillSheet - 1];
  }

  int pillNumberFor({required DateTime targetDate}) {
    return daysBetween(beginingDate.date(), targetDate) -
        summarizedRestDuration(
            restDurations: restDurations, upperDate: targetDate) +
        1;
  }

  // ピルシートのピルの日付を取得する
  late final List<DateTime> dates = () {
    final List<DateTime> dates = [];
    var offset = 0;
    for (int index = 0; index < typeInfo.totalCount; index++) {
      var date = beginingDate.addDays(index + offset).date();

      for (final restDuration in restDurations) {
        if (restDuration.beginDate.isBefore(date) ||
            isSameDay(restDuration.beginDate, date)) {
          final restDurationEndDateOrToday = restDuration.endDate ?? today();
          if (restDurationEndDateOrToday.isAfter(date)) {
            final diff = daysBetween(date, restDurationEndDateOrToday);
            date = date.addDays(diff);
            offset += diff;
          }
        }
      }

      dates.add(date);
    }
    return dates;
  }();
}

// upperDate までの休薬期間を集計する
// upperDate にはlastTakenDate(lastTakenPillNumberを集計したい時)やtoday(todayPillNumberを集計したい時）が入る想定
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
