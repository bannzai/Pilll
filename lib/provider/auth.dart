import 'package:Pilll/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final signInProvider = FutureProvider<UserCredential>(
  (ref) => ref.watch(authProvider).signInAnonymously(),
);

final databaseProvider = Provider<DatabaseConnection>((ref) {
  final userCredential = ref.watch(signInProvider);

  if (userCredential.data?.value?.user?.uid != null) {
    return DatabaseConnection(userID: userCredential.data?.value?.user?.uid);
  }
  return null;
});
