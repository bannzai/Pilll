import 'package:pilll/entity/diary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/service/auth.dart';

final databaseProvider = Provider<DatabaseConnection>((ref) {
  final stream = ref.watch(authStateStreamProvider);
  final uid = stream.data?.value.uid;
  print("database uid is $uid");
  if (uid == null) {
    throw UnimplementedError("Must be called service/auth.dart callSignin");
  }
  return DatabaseConnection(uid);
});

abstract class _CollectionPath {
  static final String users = "users";
  static String pillSheets(String userID) => "$users/$userID/pill_sheets";
  static String diaries(String userID) => "$users/$userID/diaries";
  static String userPrivates(String userID) => "$users/$userID/privates";
  static String menstruations(String userID) => "$users/$userID/menstruations";
  static String pillSheetModifiedHistories(String userID) =>
      "$users/$userID/pill_sheet_modified_histories";
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
  DocumentReference menstruationReference(String menstruationID) =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.menstruations(_userID))
          .doc(menstruationID);

  CollectionReference pillSheetModifiedHistoriesReference() =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.pillSheetModifiedHistories(_userID));

  Future<T> transaction<T>(TransactionHandler<T> transactionHandler) {
    return FirebaseFirestore.instance.runTransaction(transactionHandler);
  }

  WriteBatch batch() {
    return FirebaseFirestore.instance.batch();
  }
}
