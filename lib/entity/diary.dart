import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'diary.g.dart';
part 'diary.freezed.dart';

abstract class DiaryFirestoreKey {
  static final String date = "date";
}

enum PhysicalConditionStatus {
  @JsonKey(name: "Fine")
  fine,
  @JsonKey(name: "Bad")
  bad
}

@freezed
abstract class Diary with _$Diary {
  static final List<String> allPhysicalConditions = [
    "頭痛",
    "腹痛",
    "吐き気",
    "貧血",
    "下痢",
    "便秘",
    "ほてり",
    "眠気",
    "腰痛",
    "動悸",
    "不正出血",
    "食欲不振",
  ];

  String get id => "Diary_${DateTimeFormatter.diaryIdentifier(date)}";

  @JsonSerializable(explicitToJson: true)
  factory Diary({
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime date,
    // NOTE: OLD data does't have createdAt
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdAt,
    PhysicalConditionStatus? physicalConditionStatus,
    required List<String> physicalConditions,
    required bool hasSex,
    required String memo,
  }) = _Diary;
  Diary._();

  factory Diary.fromDate(DateTime date) =>
      Diary(date: date, memo: "", physicalConditions: [], hasSex: false);
  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
  Map<String, dynamic> toJson() => _$_$_DiaryToJson(this as _$_Diary);
  bool get hasPhysicalConditionStatus => physicalConditionStatus != null;
}
