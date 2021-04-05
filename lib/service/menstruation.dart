import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:riverpod/riverpod.dart';

final menstruationServiceProvider = Provider<MenstruationService>(
    (ref) => MenstruationService(ref.watch(databaseProvider)));

class MenstruationService {
  final DatabaseConnection _database;

  MenstruationService(this._database);
  Menstruation _map(DocumentSnapshot document) {
    var data = document.data()!;
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
        .orderBy(MenstruationFirestoreKey.beginDate)
        .get()
        .then((event) => event.docs.map(_map).toList());
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
