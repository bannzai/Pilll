import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/record/pill_mark.dart';
import 'package:Pilll/record/pill_mark_model.dart';
import 'package:flutter/material.dart';

abstract class PillSheetModel extends ChangeNotifier {
  int _index;
  get index => _index;
  set index(value) {
    _index = value;
    notifyListeners();
  }

  List<PillMarkModel> marks;
  final PillSheetType pillSheetType;

  PillSheetModel(this.pillSheetType);
}

class MainPillSheetModel extends PillSheetModel {
  MainPillSheetModel(PillSheetType pillSheetType) : super(pillSheetType) {
    this.marks = List.generate(
      28,
      (index) => MainPillMarkModel(
        pillMarkStateWithNumber(index),
        pillSheetType,
      ),
    );
  }

  PillMarkState pillMarkStateWithNumber(int number) {
    return number >= pillSheetType.beginingWithoutTakenPeriod
        ? PillMarkState.notTaken
        : PillMarkState.none;
  }
}

class InitialSettingPillSheetModel extends PillSheetModel {
  InitialSettingPillSheetModel(PillSheetType pillSheetType)
      : super(pillSheetType) {
    this.marks = List.generate(
      28,
      (index) => InitialSettingPillMarkModel(
        index: index,
        isSelected: index == this.index,
        pillSheetType: pillSheetType,
      ),
    );
  }
}
