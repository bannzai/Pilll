// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_notification_customization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReminderNotificationCustomization
    _$$_ReminderNotificationCustomizationFromJson(Map<String, dynamic> json) =>
        _$_ReminderNotificationCustomization(
          beginTrialDate: json['beginTrialDate'] == null
              ? null
              : DateTime.parse(json['beginTrialDate'] as String),
          word: json['word'] as String? ?? pill,
        );

Map<String, dynamic> _$$_ReminderNotificationCustomizationToJson(
        _$_ReminderNotificationCustomization instance) =>
    <String, dynamic>{
      'beginTrialDate': instance.beginTrialDate?.toIso8601String(),
      'word': instance.word,
    };
