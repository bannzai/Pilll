import 'dart:async';
import 'dart:io';

import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/native/health_care.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final menstruationEditPageAsyncActionProvider = Provider((ref) =>
    MenstruationEditPageAsyncAction(ref.watch(menstruationDatastoreProvider)));

class MenstruationEditPageAsyncAction {
  final MenstruationDatastore _menstruationDatastore;

  MenstruationEditPageAsyncAction(
    this._menstruationDatastore,
  );

  Future<Menstruation> save({
    required Menstruation? initialMenstruation,
    required Menstruation? menstruation,
  }) async {
    if (menstruation == null) {
      throw const FormatException("menstruation is not exists when save");
    }
    final documentID = initialMenstruation?.documentID;
    if (documentID == null) {
      if (await _canHealthKitDataSave(menstruation: menstruation)) {
        final healthKitSampleDataUUID =
            await addMenstruationFlowHealthKitData(menstruation);
        menstruation = menstruation.copyWith(
            healthKitSampleDataUUID: healthKitSampleDataUUID);
      }

      return _menstruationDatastore.create(menstruation);
    } else {
      if (await _canHealthKitDataSave(menstruation: menstruation)) {
        final healthKitSampleDataUUID =
            await updateOrAddMenstruationFlowHealthKitData(menstruation);
        menstruation = menstruation.copyWith(
            healthKitSampleDataUUID: healthKitSampleDataUUID);
      }
      return _menstruationDatastore.update(documentID, menstruation);
    }
  }

  Future<void> delete({
    required Menstruation? initialMenstruation,
    required Menstruation? menstruation,
  }) async {
    if (initialMenstruation == null) {
      throw const FormatException(
          "menstruation is not exists from db when delete");
    }
    final documentID = initialMenstruation.documentID;
    if (documentID == null) {
      throw const FormatException(
          "menstruation is not exists document id from db when delete");
    }
    if (menstruation != null) {
      throw const FormatException(
          "missing condition about state.menstruation is exists when delete. state.menstruation should flushed on edit page");
    }

    if (await _canHealthKitDataSave(menstruation: menstruation)) {
      await deleteMenstruationFlowHealthKitData(initialMenstruation);
      initialMenstruation =
          initialMenstruation.copyWith(healthKitSampleDataUUID: null);
    }

    await _menstruationDatastore.update(
        documentID, initialMenstruation.copyWith(deletedAt: now()));
  }

  Future<bool> _canHealthKitDataSave(
      {required Menstruation? menstruation}) async {
    if (Platform.isIOS) {
      if (await isHealthDataAvailable()) {
        if (await isAuthorizedReadAndShareToHealthKitData()) {
          if (menstruation?.healthKitSampleDataUUID != null) {
            return true;
          }
        }
      }
    }

    return false;
  }
}
