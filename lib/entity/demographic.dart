import 'package:freezed_annotation/freezed_annotation.dart';

part 'demographic.g.dart';
part 'demographic.freezed.dart';

@freezed
@JsonSerializable(explicitToJson: true)
abstract class Demographic with _$Demographic {
  factory Demographic({
    required String purpose1,
    required String purpose2,
    required String prescription,
    required String birthYear,
    required String lifeTime,
  }) = _Demographic;
  Demographic._();
  factory Demographic.fromJson(Map<String, dynamic> json) =>
      _$DemographicFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_DemographicToJson(this as _$_Demographic);
}
