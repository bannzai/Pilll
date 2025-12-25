// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_notification_customization.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReminderNotificationCustomization _$ReminderNotificationCustomizationFromJson(Map<String, dynamic> json) => _ReminderNotificationCustomization(
  version: json['version'] as String? ?? 'v2',
  word: json['word'] as String? ?? pillEmoji,
  isInVisibleReminderDate: json['isInVisibleReminderDate'] as bool? ?? false,
  isInVisiblePillNumber: json['isInVisiblePillNumber'] as bool? ?? false,
  isInVisibleDescription: json['isInVisibleDescription'] as bool? ?? false,
  dailyTakenMessage: json['dailyTakenMessage'] as String? ?? '',
  missedTakenMessage: json['missedTakenMessage'] as String? ?? '飲み忘れていませんか？\n服用記録がない日が複数あります$thinkingFaceEmoji',
);

Map<String, dynamic> _$ReminderNotificationCustomizationToJson(_ReminderNotificationCustomization instance) => <String, dynamic>{
  'version': instance.version,
  'word': instance.word,
  'isInVisibleReminderDate': instance.isInVisibleReminderDate,
  'isInVisiblePillNumber': instance.isInVisiblePillNumber,
  'isInVisibleDescription': instance.isInVisibleDescription,
  'dailyTakenMessage': instance.dailyTakenMessage,
  'missedTakenMessage': instance.missedTakenMessage,
};
