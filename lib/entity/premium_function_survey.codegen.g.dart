// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_function_survey.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PremiumFunctionSurvey _$$_PremiumFunctionSurveyFromJson(
        Map<String, dynamic> json) =>
    _$_PremiumFunctionSurvey(
      elements: (json['elements'] as List<dynamic>)
          .map((e) => $enumDecode(_$PremiumFunctionSurveyElementTypeEnumMap, e))
          .toList(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$_PremiumFunctionSurveyToJson(
        _$_PremiumFunctionSurvey instance) =>
    <String, dynamic>{
      'elements': instance.elements
          .map((e) => _$PremiumFunctionSurveyElementTypeEnumMap[e]!)
          .toList(),
      'message': instance.message,
    };

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
