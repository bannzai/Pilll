import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'diary.codegen.g.dart';
part 'diary.codegen.freezed.dart';

class DiaryFirestoreKey {
  static const String date = "date";
}

enum PhysicalConditionStatus { fine, bad }

const List<String> defaultPhysicalConditions = [
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
  "胸の張り",
  "不眠",
];

@freezed
class Diary with _$Diary {
  String get id => "Diary_${DateTimeFormatter.diaryIdentifier(date)}";

  @JsonSerializable(explicitToJson: true)
  const factory Diary({
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
        required DateTime? createdAt,
    PhysicalConditionStatus? physicalConditionStatus,
    required List<String> physicalConditions,
    required bool hasSex,
    required String memo,
  }) = _Diary;
  const Diary._();

  factory Diary.fromDate(DateTime date) => Diary(date: date, memo: "", createdAt: now(), physicalConditions: [], hasSex: false);
  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
  bool get hasPhysicalConditionStatus => physicalConditionStatus != null;
}
