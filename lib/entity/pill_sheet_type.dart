import 'package:pilll/entity/pill_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PillSheetType {
  pillsheet_21,
  pillsheet_28_4,
  pillsheet_28_7,
  pillsheet_28_0,
}

extension PillSheetTypeFunctions on PillSheetType? {
  static final String firestoreCollectionPath = "pill_sheet_types";
  static PillSheetType fromRawPath(String rawPath) {
    switch (rawPath) {
      case "pillsheet_21":
        return PillSheetType.pillsheet_21;
      case "pillsheet_28_4":
        return PillSheetType.pillsheet_28_4;
      case "pillsheet_28_7":
        return PillSheetType.pillsheet_28_7;
      case "pillsheet_28_0":
        return PillSheetType.pillsheet_28_0;
      default:
        throw ArgumentError.notNull("");
    }
  }

  String get fullName {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return "21錠タイプ";
      case PillSheetType.pillsheet_28_4:
        return "28錠タイプ(4錠偽薬)";
      case PillSheetType.pillsheet_28_7:
        return "28錠タイプ(7錠偽薬)";
      case PillSheetType.pillsheet_28_0:
        return "28錠タイプ(すべて実薬)";
      default:
        throw ArgumentError.notNull("");
    }
  }

  String get rawPath {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return "pillsheet_21";
      case PillSheetType.pillsheet_28_4:
        return "pillsheet_28_4";
      case PillSheetType.pillsheet_28_7:
        return "pillsheet_28_7";
      case PillSheetType.pillsheet_28_0:
        return "pillsheet_28_0";
      default:
        throw ArgumentError.notNull(
            "unexpected null value for PillSheetType.rawPath");
    }
  }

  SvgPicture get image {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return SvgPicture.asset("images/pillsheet_21.svg");
      case PillSheetType.pillsheet_28_4:
        return SvgPicture.asset("images/pillsheet_28_4.svg");
      case PillSheetType.pillsheet_28_7:
        return SvgPicture.asset("images/pillsheet_28_7.svg");
      case PillSheetType.pillsheet_28_0:
        return SvgPicture.asset("images/pillsheet_28_0.svg");
      default:
        throw ArgumentError.notNull("");
    }
  }

  String get firestorePath {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return "pillsheet_21";
      case PillSheetType.pillsheet_28_4:
        return "pillsheet_28_4";
      case PillSheetType.pillsheet_28_7:
        return "pillsheet_28_7";
      case PillSheetType.pillsheet_28_0:
        return "pillsheet_28_0";
      default:
        throw ArgumentError.notNull("");
    }
  }

  int get totalCount {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return 28;
      case PillSheetType.pillsheet_28_4:
        return 28;
      case PillSheetType.pillsheet_28_7:
        return 28;
      case PillSheetType.pillsheet_28_0:
        return 28;
      default:
        throw ArgumentError.notNull("");
    }
  }

  int get dosingPeriod {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return 21;
      case PillSheetType.pillsheet_28_4:
        return 24;
      case PillSheetType.pillsheet_28_7:
        return 21;
      case PillSheetType.pillsheet_28_0:
        return 28;
      default:
        throw ArgumentError.notNull("");
    }
  }

  PillSheetTypeInfo get typeInfo => PillSheetTypeInfo(
      pillSheetTypeReferencePath: rawPath,
      name: fullName,
      totalCount: totalCount,
      dosingPeriod: dosingPeriod);

  bool get isNotExistsNotTakenDuration {
    return this.totalCount == this.dosingPeriod;
  }

  String get notTakenWord {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return "休薬";
      case PillSheetType.pillsheet_28_4:
        return "偽薬";
      case PillSheetType.pillsheet_28_7:
        return "偽薬";
      case PillSheetType.pillsheet_28_0:
        return "";
      default:
        throw ArgumentError.notNull(
            "unexpected null receiverr when get notTakenWord");
    }
  }
}
