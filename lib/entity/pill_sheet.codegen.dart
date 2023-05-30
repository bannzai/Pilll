import 'package:pilll/entity/firestore_id_generator.dart';
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
  static const String typeInfo = "typeInfo";
  static const String createdAt = "createdAt";
  static const String deletedAt = "deletedAt";
  static const String lastTakenDate = "lastTakenDate";
  static const String beginingDate = "beginingDate";
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

  factory PillSheetTypeInfo.fromJson(Map<String, dynamic> json) => _$PillSheetTypeInfoFromJson(json);
}

@freezed
class RestDuration with _$RestDuration {
  @JsonSerializable(explicitToJson: true)
  const factory RestDuration({
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

  factory RestDuration.fromJson(Map<String, dynamic> json) => _$RestDurationFromJson(json);
}

@freezed
class PillSheet with _$PillSheet {
  String? get documentID => id;

  PillSheetType get sheetType => PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  const PillSheet._();
  @JsonSerializable(explicitToJson: true)
  const factory PillSheet({
    @JsonKey(includeIfNull: false) required String? id,
    @JsonKey() required PillSheetTypeInfo typeInfo,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime beginingDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? lastTakenDate,
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
    @Default(1) pillTakenCount,
  }) = _PillSheet;
  factory PillSheet.create(PillSheetType type) => PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: type.typeInfo,
        beginingDate: today(),
        lastTakenDate: null,
        createdAt: now(),
      );

  factory PillSheet.fromJson(Map<String, dynamic> json) => _$PillSheetFromJson(json);

  PillSheetType get pillSheetType => PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  int get todayPillNumber {
    return pillSheetPillNumber(pillSheet: this, targetDate: today());
  }

  // NOTE: if pill sheet is not yet taken, lastTakenNumber return 0;
  // Because if lastTakenPillNumber is nullable, ! = null, making it difficult to compare.
  // lastTakenNumber is often compare todayPillNumber
  int get lastTakenPillNumber {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return 0;
    }

    return pillSheetPillNumber(pillSheet: this, targetDate: lastTakenDate);
  }

  bool get todayPillIsAlreadyTaken {
    final lastTakenDate = this.lastTakenDate;
    if (lastTakenDate == null) {
      return false;
    }
    return lastTakenDate.isAfter(today()) || isSameDay(lastTakenDate, today());
  }

  bool get isEnded => typeInfo.totalCount == lastTakenPillNumber;
  bool get isBegan => beginingDate.date().toUtc().millisecondsSinceEpoch < now().toUtc().millisecondsSinceEpoch;
  bool get inNotTakenDuration => todayPillNumber > typeInfo.dosingPeriod;
  bool get pillSheetHasRestOrFakeDuration => !pillSheetType.isNotExistsNotTakenDuration;
  bool get isActive {
    final n = now();
    final begin = beginingDate.date();
    final totalCount = typeInfo.totalCount;
    final end = begin.add(Duration(days: totalCount + summarizedRestDuration(restDurations: restDurations, upperDate: today()) - 1));
    return DateRange(begin, end).inRange(n);
  }

  DateTime get estimatedEndTakenDate => beginingDate
      .add(Duration(days: pillSheetType.totalCount - 1))
      .add(Duration(days: summarizedRestDuration(restDurations: restDurations, upperDate: today())))
      .date()
      .add(const Duration(days: 1))
      .subtract(const Duration(seconds: 1));

  RestDuration? get activeRestDuration {
    if (restDurations.isEmpty) {
      return null;
    } else {
      if (restDurations.last.endDate == null && restDurations.last.beginDate.isBefore(now())) {
        return restDurations.last;
      } else {
        return null;
      }
    }
  }

  DateTime displayPillTakeDate(int pillNumberIntoPillSheet) {
    final originDate = beginingDate.add(Duration(days: pillNumberIntoPillSheet - 1)).date();
    if (restDurations.isEmpty) {
      return originDate;
    }

    var displayedDate = originDate;
    for (final restDuration in restDurations) {
      final restDurationBeginDate = restDuration.beginDate.date();
      final restDurationEndDate = restDuration.endDate?.date();

      if (restDurationEndDate != null && isSameDay(restDurationBeginDate, restDurationEndDate)) {
        continue;
      }
      if (displayedDate.isBefore(restDurationBeginDate)) {
        continue;
      }

      if (restDurationEndDate != null) {
        displayedDate = displayedDate.add(Duration(days: daysBetween(restDurationBeginDate, restDurationEndDate)));
      } else {
        displayedDate = displayedDate.add(Duration(days: daysBetween(restDurationBeginDate, today())));
      }
    }

    return displayedDate;
  }
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

int pillSheetPillNumber({
  required PillSheet pillSheet,
  required DateTime targetDate,
}) {
  return daysBetween(pillSheet.beginingDate.date(), targetDate) -
      summarizedRestDuration(restDurations: pillSheet.restDurations, upperDate: targetDate) +
      1;
}
