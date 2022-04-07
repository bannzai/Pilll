import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_notification_schedule.codegen.freezed.dart';
part 'local_notification_schedule.codegen.g.dart';

enum LocalNotificationScheduleKind { reminderNotification }

abstract class LocalNotificationScheduleFirestoreField {
  static const String kind = 'kind';
}

@freezed
class LocalNotificationSchedule with _$LocalNotificationSchedule {
  @JsonSerializable(explicitToJson: true)
  factory LocalNotificationSchedule({
    required LocalNotificationScheduleKind kind,
    required int localNotification,
    required DateTime scheduleDateTime,
  }) = _LocalNotificationSchedule;
  LocalNotificationSchedule._();

  factory LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$LocalNotificationScheduleFromJson(json);

  // createSchedule does not contains exclusion control.
  // You must call _createSchedule sequentially that means you must await createSchedule result;
  // for example, don't use Future.wait([processes])
  static Future<LocalNotificationSchedule> createSchedule({
    required LocalNotificationScheduleKind kind,
    required DateTime scheduleDateTime,
    required int currentLocalNotificationScheduleCount,
  }) async {
    final localNotificationID = currentLocalNotificationScheduleCount;
    final schedule = LocalNotificationSchedule(
      kind: kind,
      scheduleDateTime: scheduleDateTime,
      localNotification: localNotificationID,
    );

    return schedule;
  }
}
