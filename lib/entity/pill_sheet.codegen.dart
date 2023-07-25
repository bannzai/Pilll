import 'package:collection/collection.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
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
    @Default(1) pillTakenCount,
    // TODO: [PillSheet.Pill] from: 2023-06-14 ある程度時間が経ったらrequiredにする。1年くらい。下位互換のためにpillsが無い場合を考慮する
    @Default([]) List<Pill> pills,
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
        pillTakenCount: pillTakenCount ?? 1,
        pills: Pill.generateAndFillTo(pillSheetType: type, fromDate: beginDate, lastTakenDate: lastTakenDate, pillTakenCount: pillTakenCount ?? 1),
      );

  factory PillSheet.fromJson(Map<String, dynamic> json) => _$PillSheetFromJson(json);

  PillSheetType get pillSheetType => PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath);

  int get todayPillNumber {
    return pillNumberFor(targetDate: today());
  }

  int get todayPillIndex {
    return todayPillNumber - 1;
  }

  // lastCompletedPillNumber は最後に服用完了したピルの番号を返す。lastTakenPillNumberとの違いは服用を完了しているかどうか
  // あえてnon nullにしている。なぜならよく比較するのでnullableだと不便だから
  // まだpillを飲んでない場合は `0` が変える。飲んでいる場合は 1以上の値が入る
  int get lastCompletedPillNumber {
    // TODO: [PillSheet.Pill] そのうち消す。古いPillSheetのPillsは[]になっている
    if (pills.isEmpty) {
      final lastTakenDate = this.lastTakenDate;
      if (lastTakenDate == null) {
        return 0;
      }

      return pillNumberFor(targetDate: lastTakenDate);
    }

    // lastTakenDate is not nullのチェックをしていてこの変数がnullのはずは無いが、将来的にlastTakenDateは消える可能性はあるのでこのロジックは真っ当なチェックになる
    final lastCompletedPill = pills.lastWhereOrNull((element) => element.pillTakens.length == pillTakenCount);
    if (lastCompletedPill == null) {
      return 0;
    }

    // lastCompletedPillTakenDateを用意している箇所でlastWhereOrNullの中で空配列じゃ無いことはチェックをしているのでlastでアクセス
    final lastPillTakenDate = lastCompletedPill.pillTakens.last.takenDateTime;
    return pillNumberFor(targetDate: lastPillTakenDate);
  }

  // lastTakenPillNumber は最後に服了したピルの番号を返す。lastcompletedPillNumberとは違い完了はしてな区ても良い
  // あえてnon nullにしている。なぜならよく比較するのでnullableだと不便だから
  // まだpillを飲んでない場合は `0` が変える。飲んでいる場合は 1以上の値が入る
  int get lastTakenPillNumber {
    // TODO: [PillSheet.Pill] そのうち消す。古いPillSheetのPillsは[]になっている
    if (pills.isEmpty) {
      final lastTakenDate = this.lastTakenDate;
      if (lastTakenDate == null) {
        return 0;
      }

      return pillNumberFor(targetDate: lastTakenDate);
    }

    // lastTakenDate is not nullのチェックをしていてこの変数がnullのはずは無いが、将来的にlastTakenDateは消える可能性はあるのでこのロジックは真っ当なチェックになる
    final lastCompletedPill = pills.lastWhereOrNull((element) => element.pillTakens.length > 0);
    if (lastCompletedPill == null) {
      return 0;
    }

    // lastCompletedPillTakenDateを用意している箇所でlastWhereOrNullの中で空配列じゃ無いことはチェックをしているのでlastでアクセス
    final lastPillTakenDate = lastCompletedPill.pillTakens.last.takenDateTime;
    return pillNumberFor(targetDate: lastPillTakenDate);
  }

  bool get todayPillsAreAlreadyTaken {
    return lastCompletedPillNumber == todayPillNumber;
  }

  bool get anyTodayPillsAreAlreadyTaken {
    // TODO: [PillSheet.Pill] そのうち消す。古いPillSheetのPillsは[]になっている
    if (pills.isEmpty) {
      return lastCompletedPillNumber == todayPillNumber;
    }
    return pills[todayPillIndex].pillTakens.isNotEmpty;
  }

  bool get isEnded => typeInfo.totalCount == lastCompletedPillNumber;
  bool get isBegan => beginingDate.date().toUtc().millisecondsSinceEpoch < now().toUtc().millisecondsSinceEpoch;
  bool get inNotTakenDuration => todayPillNumber > typeInfo.dosingPeriod;
  bool get pillSheetHasRestOrFakeDuration => !pillSheetType.isNotExistsNotTakenDuration;
  bool get isActive => isActiveFor(now());

  bool isActiveFor(DateTime date) {
    final begin = beginingDate.date();
    final totalCount = typeInfo.totalCount;
    final end = begin.add(Duration(days: totalCount + summarizedRestDuration(restDurations: restDurations, upperDate: today()) - 1));
    return DateRange(begin, end).inRange(date);
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

  // pillTakenDateFromPillNumber は元々の番号から、休薬期間を考慮した番号に変換する
  DateTime pillTakenDateFromPillNumber(int pillNumberIntoPillSheet) {
    final originDate = beginingDate.add(Duration(days: pillNumberIntoPillSheet - 1)).date();
    if (restDurations.isEmpty) {
      return originDate;
    }

    var pillTakenDate = originDate;
    for (final restDuration in restDurations) {
      final restDurationBeginDate = restDuration.beginDate.date();
      final restDurationEndDate = restDuration.endDate?.date();

      if (restDurationEndDate != null && isSameDay(restDurationBeginDate, restDurationEndDate)) {
        continue;
      }
      if (pillTakenDate.isBefore(restDurationBeginDate)) {
        continue;
      }

      if (restDurationEndDate != null) {
        pillTakenDate = pillTakenDate.add(Duration(days: daysBetween(restDurationBeginDate, restDurationEndDate)));
      } else {
        pillTakenDate = pillTakenDate.add(Duration(days: daysBetween(restDurationBeginDate, today())));
      }
    }

    return pillTakenDate;
  }

  int pillNumberFor({
    required DateTime targetDate,
  }) {
    return daysBetween(beginingDate.date(), targetDate) - summarizedRestDuration(restDurations: restDurations, upperDate: targetDate) + 1;
  }
}

// upperDate までの休薬期間を集計する
// upperDate にはlastTakenDate(lastCompletedPillNumberを集計したい時)やtoday(todayPillNumberを集計したい時）が入る想定
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
