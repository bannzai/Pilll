import 'package:freezed_annotation/freezed_annotation.dart';

part 'demographic.g.dart';
part 'demographic.freezed.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class Demographic with _$Demographic {
const factory Demographic({
    required String purpose1,
    required String purpose2,
    required String prescription,
    required String birthYear,
    required String lifeTime,
  }) = _Demographic;
const Demographic._();
factory. Demographic.fromJson(Map<String, dynamic> json) =>
      _$DemographicFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_DemographicToJson(this as _$_Demographic);
}
