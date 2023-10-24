// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_parameter.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RemoteConfigParameterImpl _$$RemoteConfigParameterImplFromJson(
        Map<String, dynamic> json) =>
    _$RemoteConfigParameterImpl(
      isPaywallFirst: json['isPaywallFirst'] as bool? ?? false,
      isUnnecessaryOnBoarding:
          json['isUnnecessaryOnBoarding'] as bool? ?? false,
      trialDay: json['trialDay'] as bool? ?? false,
      discountDay: json['discountDay'] as bool? ?? false,
    );

Map<String, dynamic> _$$RemoteConfigParameterImplToJson(
        _$RemoteConfigParameterImpl instance) =>
    <String, dynamic>{
      'isPaywallFirst': instance.isPaywallFirst,
      'isUnnecessaryOnBoarding': instance.isUnnecessaryOnBoarding,
      'trialDay': instance.trialDay,
      'discountDay': instance.discountDay,
    };
