import 'package:Pilll/entity/pill_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PillSheetType {
  pillsheet_21,
  pillsheet_28_4,
  pillsheet_28_7,
}

extension PillSheetTypeFunctions on PillSheetType {
  static final String firestoreCollectionPath = "pill_sheet_types";
  static PillSheetType fromRawPath(String rawPath) {
    switch (rawPath) {
      case "pillsheet_21":
        return PillSheetType.pillsheet_21;
      case "pillsheet_28_4":
        return PillSheetType.pillsheet_28_4;
      case "pillsheet_28_7":
        return PillSheetType.pillsheet_28_7;
      default:
        assert(false);
        return null;
    }
  }

  String get name {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return "21錠タイプ";
      case PillSheetType.pillsheet_28_4:
        return "28錠タイプ(4錠偽薬)";
      case PillSheetType.pillsheet_28_7:
        return "28錠タイプ(7錠偽薬)";
      default:
        assert(false);
        return null;
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
      default:
        throw ArgumentError.notNull(
            "unexpected null value for PillSheetType.rawPath");
    }
  }

  List<String> get examples {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return ["・トリキュラー21", "・マーベロン21", "・アンジュ21", "・ルナベルなど"];
      case PillSheetType.pillsheet_28_4:
        return ["・ヤーズなど"];
      case PillSheetType.pillsheet_28_7:
        return ["・トリキュラー28", "・マーベロン28", "・アンジュ28"];
      default:
        assert(false);
        return null;
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
      default:
        assert(false);
        return null;
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
      default:
        assert(false);
        return null;
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
      default:
        assert(false);
        return null;
    }
  }

  int get beginingWithoutTakenPeriod {
    switch (this) {
      case PillSheetType.pillsheet_21:
        return 22;
      case PillSheetType.pillsheet_28_4:
        return 25;
      case PillSheetType.pillsheet_28_7:
        return 22;
      default:
        assert(false);
        return null;
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
      default:
        assert(false);
        return null;
    }
  }

  PillSheetTypeInfo get typeInfo => PillSheetTypeInfo(
      pillSheetTypeReferencePath: rawPath,
      name: name,
      totalCount: totalCount,
      dosingPeriod: dosingPeriod);
}
