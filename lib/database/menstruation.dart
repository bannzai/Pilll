import 'package:pilll/database/database.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:riverpod/riverpod.dart';

final menstruationDatastoreProvider = Provider<MenstruationDatastore>(
    (ref) => MenstruationDatastore(ref.watch(databaseProvider)));

class MenstruationDatastore {
  final DatabaseConnection _database;

  MenstruationDatastore(this._database);

  Future<Menstruation> fetch(String id) async {
    final doc = await _database.menstruationReference(id).get();
    return doc.data()!;
  }

  Future<List<Menstruation>> fetchAll() {
    return _database
        .menstruationsReference()
        .where(MenstruationFirestoreKey.deletedAt, isEqualTo: null)
        .orderBy(MenstruationFirestoreKey.beginDate, descending: true)
        .get()
        .then((event) => event.docs.map((e) => e.data()).toList())
        .then((value) =>
            value.where((element) => element.deletedAt == null).toList());
  }

  Future<Menstruation> create(Menstruation menstruation) {
    return _database
        .menstruationsReference()
        .add(menstruation)
        .then((event) => event.get())
        .then((value) => value.data()!);
  }

  Future<Menstruation> update(String id, Menstruation menstruation) {
    return _database
        .menstruationsReference()
        .doc(id)
        .update(menstruation.toJson())
        .then((event) => menstruation);
  }

  Stream<List<Menstruation>> streamAll() {
    return _database
        .menstruationsReference()
        .where(MenstruationFirestoreKey.deletedAt, isEqualTo: null)
        .orderBy(MenstruationFirestoreKey.beginDate, descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => doc.data()).toList())
        .map((value) =>
            value.where((element) => element.deletedAt == null).toList());
  }
}
