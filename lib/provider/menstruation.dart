import 'dart:io';

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
