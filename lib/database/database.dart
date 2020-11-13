import 'package:Pilll/auth/auth.dart';
import 'package:Pilll/entity/diary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/all.dart';

final databaseProvider = Provider<DatabaseConnection>((ref) {
  final authInfo = ref.watch(signInProvider);

  if (authInfo.data?.value?.uid != null) {
    return DatabaseConnection(authInfo.data?.value?.uid);
  }
  return null;
});

abstract class _CollectionPath {
  static final String users = "users";
  static String pillSheets(String userID) => "$users/$userID/pill_sheets";
  static String diaries(String userID) => "$users/$userID/diaries";
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

  Future<T> transaction<T>(TransactionHandler<T> transactionHandler) {
    return FirebaseFirestore.instance.runTransaction(transactionHandler);
  }
}
