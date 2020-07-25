import 'package:flutter_svg/flutter_svg.dart';

enum PillSheetType {
  pillsheet_21,
  pillsheet_28_4,
  pillsheet_28_7,
}

extension PillSheetTypeFunctions on PillSheetType {
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
}
