// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_function_survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PremiumFunctionSurvey _$_$_PremiumFunctionSurveyFromJson(
    Map<String, dynamic> json) {
  return _$_PremiumFunctionSurvey(
    elements: (json['elements'] as List<dynamic>)
        .map((e) => _$enumDecode(_$PremiumFunctionSurveyElementTypeEnumMap, e))
        .toList(),
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$_$_PremiumFunctionSurveyToJson(
        _$_PremiumFunctionSurvey instance) =>
    <String, dynamic>{
      'elements': instance.elements
          .map((e) => _$PremiumFunctionSurveyElementTypeEnumMap[e])
          .toList(),
      'message': instance.message,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PremiumFunctionSurveyElementTypeEnumMap = {
  PremiumFunctionSurveyElementType.quickRecord: 'quickRecord',
  PremiumFunctionSurveyElementType.pillNumberOnPushNotification:
      'pillNumberOnPushNotification',
  PremiumFunctionSurveyElementType.pillSheetModifiedHistory:
      'pillSheetModifiedHistory',
  PremiumFunctionSurveyElementType.showingDate: 'showingDate',
  PremiumFunctionSurveyElementType.automaticallyCreatePillSheet:
      'automaticallyCreatePillSheet',
  PremiumFunctionSurveyElementType.menstruationHistory: 'menstruationHistory',
  PremiumFunctionSurveyElementType.menstruationAnalytics:
      'menstruationAnalytics',
};
