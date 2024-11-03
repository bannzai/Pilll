import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/utils/emoji/emoji.dart';

part 'reminder_notification_customization.codegen.g.dart';
part 'reminder_notification_customization.codegen.freezed.dart';

@freezed
class ReminderNotificationCustomization
    with _$ReminderNotificationCustomization {
  @JsonSerializable(explicitToJson: true)
  const factory ReminderNotificationCustomization({
    @Default('v2') String version,
    @Default(pillEmoji) String word,
    @Default(false) bool isInVisibleReminderDate,
    @Default(false) bool isInVisiblePillNumber,
    @Default(false) bool isInVisibleDescription,
    // BEGIN: From v2
    @Default('') String dailyTakenMessage,
    @Default('飲み忘れていませんか？\n服用記録がない日が複数あります$thinkingFaceEmoji')
    String missedTakenMessage,
    // END: From v2
  }) = _ReminderNotificationCustomization;
  const ReminderNotificationCustomization._();

  factory ReminderNotificationCustomization.fromJson(
          Map<String, dynamic> json) =>
      _$ReminderNotificationCustomizationFromJson(json);
}
