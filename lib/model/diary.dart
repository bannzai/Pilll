import 'package:Pilll/model/firestore_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.g.dart';
part 'diary.freezed.dart';

abstract class DiaryFirestoreKey {
  static final String date = "date";
}

@freezed
abstract class Diary with _$Diary {
  static final List<String> physicalConditions = [
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

  @JsonSerializable(nullable: false, explicitToJson: true)
  factory Diary({
    @JsonKey(
      nullable: false,
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    @required
        DateTime date,
    @required
        String memo,
    @required
        List<String> physicalCondtions,
    @required
        bool hasSex,
  }) = _Diary;
  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
  Map<String, dynamic> toJson() => _$_$_DiaryToJson(this);
}
