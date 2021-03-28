import 'package:pilll/auth/auth.dart';
import 'package:pilll/entity/diary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userIDProvider = FutureProvider<String>((ref) async {
  final authInfo = await ref.watch(authStateProvider.future);
  return authInfo.uid;
});

final _databaseProvider = FutureProvider<DatabaseConnection>((ref) async {
  final userID = await ref.watch(userIDProvider.future);
  return DatabaseConnection(userID);
});

final databaseProvider = Provider<DatabaseConnection>((ref) {
  return database;
});

late DatabaseConnection database;
Future<void> setupDatabase() async {
  final container = ProviderContainer();
  database = await container.read(_databaseProvider.future);
}

abstract class _CollectionPath {
  static final String users = "users";
  static String pillSheets(String userID) => "$users/$userID/pill_sheets";
  static String diaries(String userID) => "$users/$userID/diaries";
  static String userPrivates(String userID) => "$users/$userID/privates";
  static String menstruations(String userID) => "$users/$userID/menstruations";
}

class DatabaseConnection {
  DatabaseConnection(this._userID);
  final String _userID;

  DocumentReference userReference() {
    return FirebaseFirestore.instance
        .collection(_CollectionPath.users)
        .doc(_userID);
  }

  CollectionReference pillSheetsReference() => FirebaseFirestore.instance
      .collection(_CollectionPath.pillSheets(_userID));

  DocumentReference pillSheetReference(String pillSheetID) =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.pillSheets(_userID))
          .doc(pillSheetID);

  CollectionReference diariesReference() =>
      FirebaseFirestore.instance.collection(_CollectionPath.diaries(_userID));
  DocumentReference diaryReference(Diary diary) => FirebaseFirestore.instance
      .collection(_CollectionPath.diaries(_userID))
      .doc(diary.id);

  DocumentReference userPrivateReference() => FirebaseFirestore.instance
      .collection(_CollectionPath.userPrivates(_userID))
      .doc(_userID);

  CollectionReference menstruationsReference() => FirebaseFirestore.instance
      .collection(_CollectionPath.menstruations(_userID));
  Future<T> transaction<T>(TransactionHandler<T> transactionHandler) {
    return FirebaseFirestore.instance.runTransaction(transactionHandler);
  }
}
