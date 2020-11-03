import 'package:Pilll/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

// ignore: top_level_function_literal_block
final authProvider = FutureProvider((ref) async {
  return FirebaseAuth.instance;
});

final signInProvider = FutureProvider<UserCredential>((ref) async {
  final auth = await ref.watch(authProvider.future);
  return auth.signInAnonymously();
});

final databaseProvider = Provider<DatabaseConnection>((ref) {
  final userCredential = ref.watch(signInProvider);

  if (userCredential.data?.value?.user?.uid != null) {
    return DatabaseConnection(userCredential.data?.value?.user?.uid);
  }
  return null;
});
