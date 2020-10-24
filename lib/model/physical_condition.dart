import 'package:freezed_annotation/freezed_annotation.dart';

part 'physical_condition.g.dart';
part 'physical_condition.freezed.dart';

@freezed
abstract class PhysicalCondition with _$PhysicalCondition {
  @JsonSerializable(nullable: false, explicitToJson: true)
  factory PhysicalCondition({
    @required String name,
  }) = _PhysicalCondition;

  factory PhysicalCondition.fromJson(Map<String, dynamic> json) =>
      _$PhysicalConditionFromJson(json);
  Map<String, dynamic> toJson() => _$_$_PhysicalConditionToJson(this);
}
