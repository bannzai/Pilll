import 'package:collection/collection.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:riverpod/riverpod.dart';

final allMenstruationProvider = StreamProvider<List<Menstruation>>((ref) => ref
    .watch(databaseProvider)
    .menstruationsReference()
    .where(MenstruationFirestoreKey.deletedAt, isEqualTo: null)
    .orderBy(MenstruationFirestoreKey.beginDate, descending: true)
    .snapshots()
    .map((event) => event.docs.map((doc) => doc.data()).toList())
    .map((value) => value.where((element) => element.deletedAt == null).toList()));
final latestMenstruationProvider = Provider((ref) => ref.watch(allMenstruationProvider)..whenData((menstruations) => menstruations.firstOrNull));
