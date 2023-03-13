import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/native/health_care.dart';
import 'package:pilll/utils/datetime/day.dart';
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
  Future<Menstruation> call(Menstruation menstruation) async {
    var mutableMenstruation = menstruation;
    if (mutableMenstruation.id == null) {
      if (await _canHealthkitDataSave()) {
        final healthKitSampleDataUUID = await addMenstruationFlowHealthKitData(mutableMenstruation);
        mutableMenstruation = mutableMenstruation.copyWith(healthKitSampleDataUUID: healthKitSampleDataUUID);
      }
    } else {
      if (await _healthKitDateDidSave(menstruation: mutableMenstruation)) {
        final healthKitSampleDataUUID = await updateOrAddMenstruationFlowHealthKitData(mutableMenstruation);
        mutableMenstruation = mutableMenstruation.copyWith(healthKitSampleDataUUID: healthKitSampleDataUUID);
      }
    }

    final doc = databaseConnection.menstruationReference(mutableMenstruation.id);
    await doc.set(mutableMenstruation, SetOptions(merge: true));
    return mutableMenstruation.copyWith(id: doc.id);
  }
}

final deleteMenstruationProvider = Provider((ref) => DeleteMenstruation(ref.watch(databaseProvider)));

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
      if (await healthKitRequestAuthorizationIsUnnecessary()) {
        if (await healthKitAuthorizationStatusIsSharingAuthorized()) {
          return true;
        }
      }
    }
  }
  return false;
}

Future<bool> _healthKitDateDidSave({required Menstruation menstruation}) async {
  if (Platform.isIOS) {
    if (await isHealthDataAvailable()) {
      if (await healthKitRequestAuthorizationIsUnnecessary()) {
        if (await healthKitAuthorizationStatusIsSharingAuthorized()) {
          if (menstruation.healthKitSampleDataUUID != null) {
            return true;
          }
        }
      }
    }
  }

  return false;
}
