import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/native/health_care.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final menstruationPageAsyncActionProvider = Provider((ref) =>
    MenstruationPageAsyncAction(ref.watch(menstruationDatastoreProvider)));

class MenstruationPageAsyncAction {
  final MenstruationDatastore _menstruationDatastore;

  MenstruationPageAsyncAction(this._menstruationDatastore);

  Future<Menstruation> recordFromToday({required Setting setting}) async {
    final begin = now();
    var menstruation = Menstruation(
        beginDate: begin,
        endDate: begin.add(Duration(days: setting.durationMenstruation - 1)),
        createdAt: now());

    if (await _canHealthkitDataSave()) {
      final healthKitSampleDataUUID =
          await addMenstruationFlowHealthKitData(menstruation);
      menstruation = menstruation.copyWith(
          healthKitSampleDataUUID: healthKitSampleDataUUID);
    }

    return _menstruationDatastore.create(menstruation);
  }

  Future<Menstruation> recordFromYesterday({required Setting setting}) async {
    final begin = today().subtract(const Duration(days: 1));
    var menstruation = Menstruation(
        beginDate: begin,
        endDate: begin.add(Duration(days: setting.durationMenstruation - 1)),
        createdAt: now());

    if (await _canHealthkitDataSave()) {
      final healthKitSampleDataUUID =
          await addMenstruationFlowHealthKitData(menstruation);
      menstruation = menstruation.copyWith(
          healthKitSampleDataUUID: healthKitSampleDataUUID);
    }

    return _menstruationDatastore.create(menstruation);
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
}
