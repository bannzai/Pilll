import 'package:freezed_annotation/freezed_annotation.dart';

part 'physical_condition.g.dart';
part 'physical_condition.freezed.dart';

@freezed
abstract class PhysicalCondition with _$PhysicalCondition {
  static final List<String> all = [
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
  factory PhysicalCondition({
    @required String name,
  }) = _PhysicalCondition;

  factory PhysicalCondition.fromJson(Map<String, dynamic> json) =>
      _$PhysicalConditionFromJson(json);
  Map<String, dynamic> toJson() => _$_$_PhysicalConditionToJson(this);
}
