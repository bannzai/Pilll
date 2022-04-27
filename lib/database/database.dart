import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:pilll/entity/diary.codegen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/service/auth.dart';

final databaseProvider = Provider<DatabaseConnection>((ref) {
  final stream = ref.watch(authStateStreamProvider);
  final uid = stream.asData?.value.uid ??
      firebase.FirebaseAuth.instance.currentUser?.uid;
  print("[DEBUG] database uid is $uid");
  if (uid == null) {
    throw UnimplementedError("Must be called service/auth.dart callSignIn");
  }
  return DatabaseConnection(uid);
});

abstract class _CollectionPath {
  static final String users = "users";
  static String pillSheets(String userID) => "$users/$userID/pill_sheets";
  static String pillSheetGroups(String userID) =>
      "$users/$userID/pill_sheet_groups";
  static String diaries(String userID) => "$users/$userID/diaries";
  static String userPrivates(String userID) => "$users/$userID/privates";
  static String menstruations(String userID) => "$users/$userID/menstruations";
  static String pillSheetModifiedHistories(String userID) =>
      "$users/$userID/pill_sheet_modified_histories";
}

class DatabaseConnection {
  DatabaseConnection(this._userID);
  String get userID => _userID;
  final String _userID;

  FromFirestore<User> _userFromFirestore =
      (snapshot, options) => User.fromJson(snapshot.data()!);
  ToFirestore<User> _userToFirestore = (user, options) => user.toJson();
  DocumentReference<User> userReference() => FirebaseFirestore.instance
      .collection(_CollectionPath.users)
      .doc(_userID)
      .withConverter(
        fromFirestore: _userFromFirestore,
        toFirestore: _userToFirestore,
      );
  DocumentReference userRawReference() =>
      FirebaseFirestore.instance.collection(_CollectionPath.users).doc(_userID);

  FromFirestore<PillSheet> _pillSheetFromFirestore =
      (snapshot, options) => PillSheet.fromJson(snapshot.data()!);
  ToFirestore<PillSheet> _pillSheetToFirestore =
      (pillSheet, options) => pillSheet.toJson();
  CollectionReference<PillSheet> pillSheetsReference() =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.pillSheets(_userID))
          .withConverter(
            fromFirestore: _pillSheetFromFirestore,
            toFirestore: _pillSheetToFirestore,
          );

  DocumentReference<PillSheet> pillSheetReference(String pillSheetID) =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.pillSheets(_userID))
          .doc(pillSheetID)
          .withConverter(
            fromFirestore: _pillSheetFromFirestore,
            toFirestore: _pillSheetToFirestore,
          );

  FromFirestore<Diary> _diaryFromFirestore =
      (snapshot, options) => Diary.fromJson(snapshot.data()!);
  ToFirestore<Diary> _diaryToFirestore = (diary, options) => diary.toJson();
  CollectionReference<Diary> diariesReference() => FirebaseFirestore.instance
      .collection(_CollectionPath.diaries(_userID))
      .withConverter(
        fromFirestore: _diaryFromFirestore,
        toFirestore: _diaryToFirestore,
      );
  DocumentReference<Diary> diaryReference(Diary diary) =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.diaries(_userID))
          .doc(diary.id)
          .withConverter(
            fromFirestore: _diaryFromFirestore,
            toFirestore: _diaryToFirestore,
          );

  DocumentReference userPrivateRawReference() => FirebaseFirestore.instance
      .collection(_CollectionPath.userPrivates(_userID))
      .doc(_userID);

  FromFirestore<Menstruation> _menstruationFromFirestore =
      (snapshot, options) => Menstruation.fromJson(
          snapshot.data()!.putIfAbsent("id", () => snapshot.id));
  ToFirestore<Menstruation> _menstruationToFirestore =
      (menstruation, options) => menstruation.toJson();
  CollectionReference<Menstruation> menstruationsReference() =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.menstruations(_userID))
          .withConverter(
            fromFirestore: _menstruationFromFirestore,
            toFirestore: _menstruationToFirestore,
          );
  DocumentReference<Menstruation> menstruationReference(
          String menstruationID) =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.menstruations(_userID))
          .doc(menstruationID)
          .withConverter(
            fromFirestore: _menstruationFromFirestore,
            toFirestore: _menstruationToFirestore,
          );

  FromFirestore<PillSheetModifiedHistory>
      _pillSheetModifiedHistoryFromFirestore = (snapshot, options) =>
          PillSheetModifiedHistory.fromJson(
              snapshot.data()!.putIfAbsent("id", () => snapshot.id));
  ToFirestore<PillSheetModifiedHistory> _pillSheetModifiedHistoryToFirestore =
      (history, options) => history.toJson();
  CollectionReference<PillSheetModifiedHistory>
      pillSheetModifiedHistoriesReference() => FirebaseFirestore.instance
          .collection(_CollectionPath.pillSheetModifiedHistories(_userID))
          .withConverter(
            fromFirestore: _pillSheetModifiedHistoryFromFirestore,
            toFirestore: _pillSheetModifiedHistoryToFirestore,
          );

  FromFirestore<PillSheetGroup> _pillSheetGroupFromFirestore =
      (snapshot, options) => PillSheetGroup.fromJson(
          snapshot.data()!.putIfAbsent("id", () => snapshot.id));
  ToFirestore<PillSheetGroup> _pillSheetGroupToFirestore =
      (pillSheetGroup, options) => pillSheetGroup.toJson();
  CollectionReference<PillSheetGroup> pillSheetGroupsReference() =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.pillSheetGroups(_userID))
          .withConverter(
            fromFirestore: _pillSheetGroupFromFirestore,
            toFirestore: _pillSheetGroupToFirestore,
          );

  DocumentReference<PillSheetGroup> pillSheetGroupReference(
          String pillSheetGroupID) =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.pillSheetGroups(_userID))
          .doc(pillSheetGroupID)
          .withConverter(
            fromFirestore: _pillSheetGroupFromFirestore,
            toFirestore: _pillSheetGroupToFirestore,
          );

  Future<T> transaction<T>(TransactionHandler<T> transactionHandler) {
    return FirebaseFirestore.instance.runTransaction(transactionHandler);
  }

  WriteBatch batch() {
    return FirebaseFirestore.instance.batch();
  }
}
