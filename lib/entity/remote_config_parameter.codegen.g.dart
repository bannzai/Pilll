// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_parameter.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RemoteConfigParameterImpl _$$RemoteConfigParameterImplFromJson(
        Map<String, dynamic> json) =>
    _$RemoteConfigParameterImpl(
      isPaywallFirst: json['isPaywallFirst'] as bool? ??
          RemoteConfigParameterDefaultValues.isPaywallFirst,
      skipOnBoarding: json['skipOnBoarding'] as bool? ??
          RemoteConfigParameterDefaultValues.skipOnBoarding,
      trialDeadlineDateOffsetDay: json['trialDeadlineDateOffsetDay'] as int? ??
          RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay,
      discountEntitlementOffsetDay:
          json['discountEntitlementOffsetDay'] as int? ??
              RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay,
      discountCountdownBoundaryHour:
          json['discountCountdownBoundaryHour'] as int? ??
              RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour,
    );

Map<String, dynamic> _$$RemoteConfigParameterImplToJson(
        _$RemoteConfigParameterImpl instance) =>
    <String, dynamic>{
      'isPaywallFirst': instance.isPaywallFirst,
      'skipOnBoarding': instance.skipOnBoarding,
      'trialDeadlineDateOffsetDay': instance.trialDeadlineDateOffsetDay,
      'discountEntitlementOffsetDay': instance.discountEntitlementOffsetDay,
      'discountCountdownBoundaryHour': instance.discountCountdownBoundaryHour,
    };
