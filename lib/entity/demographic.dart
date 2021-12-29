import 'package:freezed_annotation/freezed_annotation.dart';

part 'demographic.g.dart';
part 'demographic.freezed.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class Demographic with _$Demographic {
  const factory Demographic({
    String purpose1,
    String purpose2,
    String prescription,
    String birthYear,
    String lifeTime,
  }) = _Demographic;
  const Demographic._();
  factory Demographic.fromJson(Map<String, dynamic> json) =>
      _$DemographicFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_DemographicToJson(this as _$_Demographic);
}
