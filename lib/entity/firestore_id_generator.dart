import 'package:uuid/uuid.dart';

class FirestoreIDGenerator {
  String call() => const Uuid().v4();
}

FirestoreIDGenerator firestoreIDGenerator = FirestoreIDGenerator();
