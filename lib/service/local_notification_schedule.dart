import 'dart:async';

import 'package:pilll/database/database.dart';
import 'package:pilll/entity/local_notification_schedule.codegen.dart';
import 'package:riverpod/riverpod.dart';

final localNotificationScheduleServiceProvider = Provider(
    (ref) => LocalNotificationScheduleService(ref.watch(databaseProvider)));

class LocalNotificationScheduleService {
  final DatabaseConnection _database;
  LocalNotificationScheduleService(this._database);

  Future<List<LocalNotificationSchedule>> fetchListWithKind(
      LocalNotificationScheduleKind kind) {
    return _database
        .localNotificationScheduleCollections()
        .where(LocalNotificationScheduleFirestoreField.kind, isEqualTo: kind)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }
}
