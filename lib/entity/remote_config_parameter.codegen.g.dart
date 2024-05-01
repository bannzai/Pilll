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
      skipInitialSetting: json['skipInitialSetting'] as bool? ??
          RemoteConfigParameterDefaultValues.skipInitialSetting,
      trialDeadlineDateOffsetDay:
          (json['trialDeadlineDateOffsetDay'] as num?)?.toInt() ??
              RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay,
      discountEntitlementOffsetDay:
          (json['discountEntitlementOffsetDay'] as num?)?.toInt() ??
              RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay,
      discountCountdownBoundaryHour:
          (json['discountCountdownBoundaryHour'] as num?)?.toInt() ??
              RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour,
    );

Map<String, dynamic> _$$RemoteConfigParameterImplToJson(
        _$RemoteConfigParameterImpl instance) =>
    <String, dynamic>{
      'isPaywallFirst': instance.isPaywallFirst,
      'skipInitialSetting': instance.skipInitialSetting,
      'trialDeadlineDateOffsetDay': instance.trialDeadlineDateOffsetDay,
      'discountEntitlementOffsetDay': instance.discountEntitlementOffsetDay,
      'discountCountdownBoundaryHour': instance.discountCountdownBoundaryHour,
    };
