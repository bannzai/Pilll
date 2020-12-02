import 'package:Pilll/auth/auth.dart';
import 'package:Pilll/entity/diary.dart';
import 'package:Pilll/entity/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/all.dart';

final userIDProvider = Provider<String>((ref) {
  final authInfo = ref.watch(authStateChangesProvider);
  if (authInfo.data?.value?.uid != null) {
    return authInfo.data?.value?.uid;
  }
  return null;
});

final databaseProvider = Provider<DatabaseConnection>((ref) {
  final userID = ref.watch(userIDProvider);
  if (userID == null) {
    return null;
  }
  return DatabaseConnection(userID);
});

abstract class _CollectionPath {
  static final String users = "users";
  static String pillSheets(String userID) => "$users/$userID/pill_sheets";
  static String diaries(String userID) => "$users/$userID/diaries";
  static String userPrivates(String userID) => "$users/$userID/privates";
}

class DatabaseConnection {
  DatabaseConnection(this._userID)
      : assert(
            _userID != null, 'Pill firestore request should necessary userID');
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

  DocumentReference userPrivateReference(User user) =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.userPrivates(_userID))
          .doc(user.privateDocumentID);

  Future<T> transaction<T>(TransactionHandler<T> transactionHandler) {
    return FirebaseFirestore.instance.runTransaction(transactionHandler);
  }
}
