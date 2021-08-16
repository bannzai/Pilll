import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:riverpod/riverpod.dart';

typedef BatchFactoryFunction = WriteBatch Function();

class BatchFactory {
  final BatchFactoryFunction _batch;

  BatchFactory(this._batch);

  WriteBatch bach() => _batch();
}

final batchFactoryProvider = Provider<BatchFactory>((ref) {
  final database = ref.watch(databaseProvider);
  return BatchFactory(() {
    return database.batch();
  });
});
