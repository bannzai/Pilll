import 'package:pilll/database/database.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:riverpod/riverpod.dart';

final menstruationServiceProvider = Provider<MenstruationService>(
    (ref) => MenstruationService(ref.watch(databaseProvider)));

class MenstruationService {
  final DatabaseConnection _database;

  MenstruationService(this._database);
  Future<List<Menstruation>> fetchAll() {
    return _database
        .menstruationsReference()
        .where(MenstruationFirestoreKey.deletedAt, isEqualTo: null)
        .orderBy(MenstruationFirestoreKey.beginDate)
        .get()
        .then((event) => event.docs
            .map((doc) => Menstruation.fromJson(doc.data()!))
            .toList());
  }

  Stream<List<Menstruation>> subscribeAll() {
    return _database
        .menstruationsReference()
        .where(MenstruationFirestoreKey.deletedAt, isEqualTo: null)
        .orderBy(MenstruationFirestoreKey.beginDate)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => Menstruation.fromJson(doc.data()!))
            .toList());
  }
}
