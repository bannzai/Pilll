import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:riverpod/riverpod.dart';

final menstruationDatastoreProvider = Provider<MenstruationDatastore>(
    (ref) => MenstruationDatastore(ref.watch(databaseProvider)));

class MenstruationDatastore {
  final DatabaseConnection _database;

  MenstruationDatastore(this._database);
  Menstruation _map(DocumentSnapshot document) {
    var data = document.data()! as Map<String, dynamic>;
    data["id"] = document.id;
    return Menstruation.fromJson(data);
  }

  Future<Menstruation> fetch(String id) {
    return _database.menstruationReference(id).get().then(_map);
  }

  Future<List<Menstruation>> fetchAll() {
    return _database
        .menstruationsReference()
        .where(MenstruationFirestoreKey.deletedAt, isEqualTo: null)
        .orderBy(MenstruationFirestoreKey.beginDate, descending: true)
        .get()
        .then((event) => event.docs.map(_map).toList())
        .then((value) =>
            value.where((element) => element.deletedAt == null).toList());
  }

  Future<Menstruation> create(Menstruation menstruation) {
    return _database
        .menstruationsReference()
        .add(menstruation.toJson())
        .then((event) => event.get())
        .then((value) => _map(value));
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
        .map((event) => event.docs.map((doc) => _map(doc)).toList())
        .map((value) =>
            value.where((element) => element.deletedAt == null).toList());
  }
}
