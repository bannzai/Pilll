import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class PillSheetFirestoreFieldKeys {
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
          firestoreRowData[PillSheetFirestoreFieldKeys.pillSheetTypeInfo]
              [PillSheetFirestoreFieldKeys.pillSheetTypeInfoRef],
      totalCount: firestoreRowData[PillSheetFirestoreFieldKeys.pillSheetTypeInfo]
          [PillSheetFirestoreFieldKeys.pillSheetTypeInfoPillCount],
      dosingPeriod:
          firestoreRowData[PillSheetFirestoreFieldKeys.pillSheetTypeInfo]
              [PillSheetFirestoreFieldKeys.pillSheetTypeInfoDosingPeriod],
      beginingDate:
          firestoreRowData[PillSheetFirestoreFieldKeys.beginingDate].toDate(),
      lastTakenDate: firestoreRowData[PillSheetFirestoreFieldKeys.lastTakenDate],
    );
  }
  PillSheetModel._({
    @required this.pillSheetTypeReference,
    @required this.totalCount,
    @required this.dosingPeriod,
    @required this.beginingDate,
    @required this.lastTakenDate,
  })  : assert(pillSheetTypeReference != null),
        assert(totalCount != null),
        assert(dosingPeriod != null),
        assert(beginingDate != null);
}
