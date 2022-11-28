import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

class FirestoreIDGenerator {
  String call() => const Uuid().v4();
}

FirestoreIDGenerator firestoreIDGenerator = FirestoreIDGenerator();

class IDDefault implements Default {
  @override
  String get defaultValue => firestoreIDGenerator();
}
