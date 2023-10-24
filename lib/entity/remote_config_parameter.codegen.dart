import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_parameter.codegen.freezed.dart';
part 'remote_config_parameter.codegen.g.dart';

@freezed
class RemoteConfigParameter with _$RemoteConfigParameter {
  factory RemoteConfigParameter({
    @Default(false) bool isPaywallFirst,
    @Default(false) bool isUnnecessaryOnBoarding,
    @Default(false) bool trialDay,
    @Default(false) bool discountDay,
  }) = _RemoteConfigParameter;
  RemoteConfigParameter._();
  factory RemoteConfigParameter.fromJson(Map<String, dynamic> json) => _$RemoteConfigParameterFromJson(json);
}
