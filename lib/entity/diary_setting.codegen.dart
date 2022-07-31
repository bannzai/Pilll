import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'diary_setting.codegen.g.dart';
part 'diary_setting.codegen.freezed.dart';

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
class DiarySetting with _$DiarySetting {
  const DiarySetting._();
  @JsonSerializable(explicitToJson: true)
  const factory DiarySetting({
    @Default(defaultPhysicalConditions)
        List<String> physicalConditions,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdAt,
  }) = _DiarySetting;

  factory DiarySetting.fromJson(Map<String, dynamic> json) => _$DiarySettingFromJson(json);
}
