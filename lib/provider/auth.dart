import 'package:Pilll/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final signInProvider = StreamProvider<UserCredential>(
  (ref) => ref.watch(authProvider).signInAnonymously().asStream(),
);

final databaseProvider = Provider<DatabaseConnection>((ref) {
  final userCredential = ref.watch(signInProvider);

  if (userCredential.data?.value?.user?.uid != null) {
    return DatabaseConnection(userID: userCredential.data.value.user.uid);
  }
  return null;
});
