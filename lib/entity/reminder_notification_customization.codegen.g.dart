// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_notification_customization.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderNotificationCustomizationImpl
    _$$ReminderNotificationCustomizationImplFromJson(
            Map<String, dynamic> json) =>
        _$ReminderNotificationCustomizationImpl(
          word: json['word'] as String? ?? pillEmoji,
          isInVisibleReminderDate:
              json['isInVisibleReminderDate'] as bool? ?? false,
          isInVisiblePillNumber:
              json['isInVisiblePillNumber'] as bool? ?? false,
          isInVisibleDescription:
              json['isInVisibleDescription'] as bool? ?? false,
        );

Map<String, dynamic> _$$ReminderNotificationCustomizationImplToJson(
        _$ReminderNotificationCustomizationImpl instance) =>
    <String, dynamic>{
      'word': instance.word,
      'isInVisibleReminderDate': instance.isInVisibleReminderDate,
      'isInVisiblePillNumber': instance.isInVisiblePillNumber,
      'isInVisibleDescription': instance.isInVisibleDescription,
    };
