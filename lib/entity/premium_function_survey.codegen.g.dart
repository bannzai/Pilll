// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_function_survey.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PremiumFunctionSurveyImpl _$$PremiumFunctionSurveyImplFromJson(
        Map<String, dynamic> json) =>
    _$PremiumFunctionSurveyImpl(
      elements: (json['elements'] as List<dynamic>)
          .map((e) => $enumDecode(_$PremiumFunctionSurveyElementTypeEnumMap, e))
          .toList(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$PremiumFunctionSurveyImplToJson(
        _$PremiumFunctionSurveyImpl instance) =>
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
