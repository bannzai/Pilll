import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/local_notification_schedule.codegen.dart';
import 'package:riverpod/riverpod.dart';

final localNotificationScheduleCollectionServiceProvider = Provider(
  (ref) => LocalNotificationScheduleCollectionService(
    ref.watch(databaseProvider),
  ),
);

final localNotificationScheduleCollectionServiceStreamProvider =
    StreamProvider<List<LocalNotificationScheduleCollection>>((ref) => ref
        .watch(databaseProvider)
        .localNotificationScheduleCollectionStream());

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

  Future<void> updateWithBatch(
      WriteBatch batch,
      LocalNotificationScheduleCollection
          localNotificationScheduleCollection) async {
    batch.set(
      _database.localNotificationScheduleCollection(
          localNotificationScheduleCollection.kind),
      localNotificationScheduleCollection,
      SetOptions(merge: true),
    );
  }

  Future<void> update(
      LocalNotificationScheduleCollection
          localNotificationScheduleCollection) async {
    await _database
        .localNotificationScheduleCollection(
            localNotificationScheduleCollection.kind)
        .set(localNotificationScheduleCollection, SetOptions(merge: true));
  }
}
