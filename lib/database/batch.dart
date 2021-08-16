import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:riverpod/riverpod.dart';

final batchProvider = Provider<WriteBatch Function()>((ref) {
  final database = ref.watch(databaseProvider);
  return () {
    return database.batch();
  };
});
