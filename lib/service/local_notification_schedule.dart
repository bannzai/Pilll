import 'dart:async';

import 'package:pilll/database/database.dart';
import 'package:pilll/entity/local_notification_schedule.codegen.dart';
import 'package:riverpod/riverpod.dart';

final localNotificationScheduleCollectionServiceProvider = Provider((ref) =>
    LocalNotificationScheduleCollectionService(
        ref.watch(databaseProvider),
        ref.watch(
            localNotificationScheduleCollectionServiceStreamProvider.stream)));

final localNotificationScheduleCollectionServiceStreamProvider =
    StreamProvider<List<LocalNotificationScheduleCollection>>((ref) => ref
        .watch(databaseProvider)
        .localNotificationScheduleCollectionStream());

class LocalNotificationScheduleCollectionService {
  final DatabaseConnection _database;
  final Stream<List<LocalNotificationScheduleCollection>> _stream;
  LocalNotificationScheduleCollectionService(this._database, this._stream);

  Future<LocalNotificationScheduleCollection?> fetchReminderNotification() {
    return _database
        .localNotificationScheduleCollection(
            LocalNotificationScheduleKind.reminderNotification)
        .get()
        .then((e) => e.data());
  }

  Stream<List<LocalNotificationScheduleCollection>> stream(
      LocalNotificationScheduleKind kind) {
    return _stream.map(
        (event) => event.where((element) => element.kind == kind).toList());
  }
}
