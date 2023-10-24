import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_parameter.codegen.freezed.dart';
part 'remote_config_parameter.codegen.g.dart';

abstract class RemoteConfigKeys {
  static const isPaywallFirst = "isPaywallFirst";
  static const isUnnecessaryOnBoarding = "isUnnecessaryOnBoarding";
  static const trialDeadlineDateOffsetDay = "trialDeadlineDateOffsetDay";
  static const discountEntitlementOffsetDay = "discountEntitlementOffsetDay";
  static const discountCountdownBoundaryHour = "discountCountdownBoundaryHour";
}

abstract class RemoteConfigParameterDefaultValues {
  static const isPaywallFirst = false;
  static const isUnnecessaryOnBoarding = false;
  static const trialDeadlineDateOffsetDay = 30;
  static const discountEntitlementOffsetDay = 2;
  static const discountCountdownBoundaryHour = 48;
}

@freezed
class RemoteConfigParameter with _$RemoteConfigParameter {
  factory RemoteConfigParameter({
    @Default(RemoteConfigParameterDefaultValues.isPaywallFirst) bool isPaywallFirst,
    @Default(RemoteConfigParameterDefaultValues.isUnnecessaryOnBoarding) bool isUnnecessaryOnBoarding,
    @Default(RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay) int trialDeadlineDateOffsetDay,
    @Default(RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay) int discountEntitlementOffsetDay,
    @Default(RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour) int discountCountdownBoundaryHour,
  }) = _RemoteConfigParameter;
  RemoteConfigParameter._();
  factory RemoteConfigParameter.fromJson(Map<String, dynamic> json) => _$RemoteConfigParameterFromJson(json);
}
