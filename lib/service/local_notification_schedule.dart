import 'dart:async';

import 'package:pilll/database/database.dart';
import 'package:pilll/entity/local_notification_schedule.codegen.dart';
import 'package:riverpod/riverpod.dart';

final localNotificationScheduleCollectionServiceProvider = Provider((ref) =>
    LocalNotificationScheduleCollectionService(ref.watch(databaseProvider)));

class LocalNotificationScheduleCollectionService {
  final DatabaseConnection _database;
  LocalNotificationScheduleCollectionService(this._database);

  Future<LocalNotificationScheduleCollection?> fetchReminderNotification() {
    return _database
        .localNotificationScheduleCollection(
            LocalNotificationScheduleKind.reminderNotification)
        .get()
        .then((e) => e.data());
  }
}
