import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/native/health_care.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final allMenstruationProvider = StreamProvider<List<Menstruation>>((ref) => ref
    .watch(databaseProvider)
    .menstruationsReference()
    .where(MenstruationFirestoreKey.deletedAt, isEqualTo: null)
    .orderBy(MenstruationFirestoreKey.beginDate, descending: true)
    .snapshots()
    .map((event) => event.docs.map((doc) => doc.data()).toList())
    .map((value) => value.where((element) => element.deletedAt == null).toList()));
final latestMenstruationProvider = Provider((ref) => ref.watch(allMenstruationProvider).whenData((menstruations) => menstruations.firstOrNull));

final beginMenstruationProvider = Provider((ref) => BeginMenstruation(ref.watch(databaseProvider)));

class BeginMenstruation {
  final DatabaseConnection databaseConnection;
  BeginMenstruation(this.databaseConnection);

  Future<Menstruation> call(DateTime begin, {required Setting setting}) async {
    var menstruation = Menstruation(beginDate: begin, endDate: begin.add(Duration(days: setting.durationMenstruation - 1)), createdAt: now());
    if (await _canHealthkitDataSave()) {
      final healthKitSampleDataUUID = await addMenstruationFlowHealthKitData(menstruation);
      menstruation = menstruation.copyWith(healthKitSampleDataUUID: healthKitSampleDataUUID);
    }

    return await databaseConnection.menstruationsReference().add(menstruation).then((event) => event.get()).then((value) => value.data()!);
  }
}

// TODO: HealthKit系の処理がおかしい気がしたので下のコードから変えているのでテスト
final setMenstruationProvider = Provider((ref) => SetMenstruation(ref.watch(databaseProvider)));

class SetMenstruation {
  final DatabaseConnection databaseConnection;
  SetMenstruation(this.databaseConnection);
  Future<Menstruation> call(Menstruation _menstruation) async {
    var menstruation = _menstruation;
    if (menstruation.id == null) {
      if (await _canHealthkitDataSave()) {
        final healthKitSampleDataUUID = await addMenstruationFlowHealthKitData(menstruation);
        menstruation = menstruation.copyWith(healthKitSampleDataUUID: healthKitSampleDataUUID);
      }
    } else {
      if (await _healthKitDateDidSave(menstruation: menstruation)) {
        final healthKitSampleDataUUID = await updateOrAddMenstruationFlowHealthKitData(menstruation);
        menstruation = menstruation.copyWith(healthKitSampleDataUUID: healthKitSampleDataUUID);
      }
    }

    final doc = databaseConnection.menstruationReference(menstruation.id);
    await doc.set(menstruation, SetOptions(merge: true));
    return menstruation.copyWith(id: doc.id);
  }
}

class DeleteMenstruation {
  final DatabaseConnection databaseConnection;
  DeleteMenstruation(this.databaseConnection);
  Future<void> call(Menstruation menstruation) async {
    if (await _healthKitDateDidSave(menstruation: menstruation)) {
      await deleteMenstruationFlowHealthKitData(menstruation);
    }
    await databaseConnection.menstruationReference(menstruation.id).update({MenstruationFirestoreKey.deletedAt: now()});
  }
}

Future<bool> _canHealthkitDataSave() async {
  if (Platform.isIOS) {
    if (await isHealthDataAvailable()) {
      if (await isAuthorizedReadAndShareToHealthKitData()) {
        return true;
      }
    }
  }
  return false;
}

Future<bool> _healthKitDateDidSave({required Menstruation menstruation}) async {
  if (Platform.isIOS) {
    if (await isHealthDataAvailable()) {
      if (await isAuthorizedReadAndShareToHealthKitData()) {
        if (menstruation.healthKitSampleDataUUID != null) {
          return true;
        }
      }
    }
  }

  return false;
}
