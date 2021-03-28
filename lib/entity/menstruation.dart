import 'package:freezed_annotation/freezed_annotation.dart';
part 'menstruation.g.dart';
part 'menstruation.freezed.dart';

@freezed
abstract class Menstruation with _$Menstruation {
  factory Menstruation.fromJson(Map<String, dynamic> json) =>
      _$MenstruationFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_MenstruationToJson(this as _$_Menstruation);
  @JsonSerializable(explicitToJson: true)
  factory Menstruation({
    required DateTime date,
    required List<String> physicalConditions,
    required bool hasSex,
    required String memo,
  }) = _Menstruation;
}
