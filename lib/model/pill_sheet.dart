import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class PillSheetFirestoreFieldKey {
  static final String creator = "creator";
  static final String creatorReference = "reference";
  static final String beginingDate = "beginingDate";
  static final String pillSheetTypeInfo = "pillSheetTypeInfo";
  static final String pillSheetTypeInfoRef = "reference";
  static final String pillSheetTypeInfoPillCount = "pillCount";
  static final String pillSheetTypeInfoDosingPeriod = "dosingPeriod";
  static final String lastTakenDate = "lastTakenDate";
}

class PillSheetModel {
  final DocumentReference pillSheetTypeReference;
  final int totalCount;
  final int dosingPeriod;
  final DateTime beginingDate;
  final DateTime lastTakenDate;

  factory PillSheetModel(Map<String, dynamic> firestoreRowData) {
    return PillSheetModel._(
      pillSheetTypeReference:
          firestoreRowData[PillSheetFirestoreFieldKey.pillSheetTypeInfo]
              [PillSheetFirestoreFieldKey.pillSheetTypeInfoRef],
      totalCount: firestoreRowData[PillSheetFirestoreFieldKey.pillSheetTypeInfo]
          [PillSheetFirestoreFieldKey.pillSheetTypeInfoPillCount],
      dosingPeriod:
          firestoreRowData[PillSheetFirestoreFieldKey.pillSheetTypeInfo]
              [PillSheetFirestoreFieldKey.pillSheetTypeInfoDosingPeriod],
      beginingDate:
          firestoreRowData[PillSheetFirestoreFieldKey.beginingDate].toDate(),
      lastTakenDate: firestoreRowData[PillSheetFirestoreFieldKey.lastTakenDate],
    );
  }
  PillSheetModel._({
    @required this.pillSheetTypeReference,
    @required this.totalCount,
    @required this.dosingPeriod,
    @required this.beginingDate,
    @required this.lastTakenDate,
  });
  // Map<String, dynamic> userPillSheetRowData() {
  //   var rowData = Map<String, dynamic>();
  //   if (pillSheetType != null) {
  //     rowData[PillSheetFirestoreFieldKey.pillSheetTypeInfo] = {
  //       PillSheetFirestoreFieldKey.pillSheetTypeInfoRef:
  //           pillSheetType.documentReference,
  //       PillSheetFirestoreFieldKey.pillSheetTypeInfoPillCount:
  //           pillSheetType.totalCount,
  //       PillSheetFirestoreFieldKey.pillSheetTypeInfoDosingPeriod:
  //           pillSheetType.dosingPeriod,
  //     };
  //     rowData[PillSheetFirestoreFieldKey.creator] = {
  //       PillSheetFirestoreFieldKey.creatorReference:
  //           user.User.documentReference,
  //     };
  //     rowData[PillSheetFirestoreFieldKey.beginingDate] = Timestamp.fromDate(
  //         today().subtract(Duration(days: todayPillNumber - 1)));
  //   }
  //   return rowData;
  // }
}
