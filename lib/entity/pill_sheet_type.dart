import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/entity/weekday.dart';

enum PillSheetType {
  // "21錠+休薬7日";
  pillsheet_21,
  // "24錠+4日偽薬";
  pillsheet_28_4,
  // "21錠+7日偽薬";
  pillsheet_28_7,
  // "28錠タイプ(すべて実薬)";
  pillsheet_28_0,
  // "24錠タイプ(すべて実薬)";
  pillsheet_24_0,
  // "21錠タイプ(すべて実薬)";
  pillsheet_21_0,
  // "24錠+4日休薬";
  // ignore: constant_identifier_names
  pillsheet_24_rest_4,
}

extension PillSheetTypeFunctions on PillSheetType {
  static const String firestoreCollectionPath = "pill_sheet_types";
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
      case "pillsheet_24_0":
        return PillSheetType.pillsheet_24_0;
      case "pillsheet_21_0":
        return PillSheetType.pillsheet_21_0;
      case "pillsheet_24_rest_4":
        return PillSheetType.pillsheet_24_rest_4;
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
      case PillSheetType.pillsheet_24_0:
        return "24錠タイプ(すべて実薬)";
      case PillSheetType.pillsheet_21_0:
        return "21錠タイプ(すべて実薬)";
      case PillSheetType.pillsheet_24_rest_4:
        return "24錠タイプ";
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
      case PillSheetType.pillsheet_24_0:
        return "pillsheet_24_0";
      case PillSheetType.pillsheet_21_0:
        return "pillsheet_21_0";
      case PillSheetType.pillsheet_24_rest_4:
        return "pillsheet_24_rest_4";
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
      case PillSheetType.pillsheet_24_0:
        return SvgPicture.asset("images/pillsheet_24_0.svg");
      case PillSheetType.pillsheet_21_0:
        return SvgPicture.asset("images/pillsheet_21_0.svg");
      case PillSheetType.pillsheet_24_rest_4:
        return SvgPicture.asset("images/pillsheet_28_4.svg");
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
      case PillSheetType.pillsheet_24_0:
        return 24;
      case PillSheetType.pillsheet_21_0:
        return 21;
      case PillSheetType.pillsheet_24_rest_4:
        return 28;
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
      case PillSheetType.pillsheet_24_0:
        return 24;
      case PillSheetType.pillsheet_21_0:
        return 21;
      case PillSheetType.pillsheet_24_rest_4:
        return 24;
    }
  }

  PillSheetTypeInfo get typeInfo =>
      PillSheetTypeInfo(pillSheetTypeReferencePath: rawPath, name: fullName, totalCount: totalCount, dosingPeriod: dosingPeriod);

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
      case PillSheetType.pillsheet_24_0:
        return "";
      case PillSheetType.pillsheet_21_0:
        return "";
      case PillSheetType.pillsheet_24_rest_4:
        return "休薬";
    }
  }

  int get numberOfLineInPillSheet => (totalCount / Weekday.values.length).ceil();
}

int summarizedPillCountWithPillSheetTypesToIndex({required List<PillSheetType> pillSheetTypes, required int toIndex}) {
  if (toIndex == 0) {
    return 0;
  }

  final passed = pillSheetTypes.sublist(0, toIndex);
  final passedTotalCount = passed.map((e) => e.totalCount).reduce((value, element) => value + element);
  return passedTotalCount;
}
