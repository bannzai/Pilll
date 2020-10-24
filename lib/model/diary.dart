import 'package:Pilll/model/firestore_timestamp_converter.dart';
import 'package:Pilll/model/physical_condition.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.g.dart';
part 'diary.freezed.dart';

abstract class DiaryFirestoreKey {
  static final String date = "date";
}

@freezed
abstract class Diary with _$Diary {
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
        List<PhysicalCondition> physicalCondtions,
    @required
        bool hasSex,
  }) = _Diary;
  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
  Map<String, dynamic> toJson() => _$_$_DiaryToJson(this);
}
