import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:riverpod/riverpod.dart';

typedef BatchFactoryFunction = WriteBatch Function();

class BatchFactory {
  final DatabaseConnection database;

  BatchFactory(this.database);

  WriteBatch batch() => database.batch();
}

final batchFactoryProvider = Provider<BatchFactory>((ref) {
  final database = ref.watch(databaseProvider);
  return BatchFactory(database);
});
