import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/record/pill_mark.dart';
import 'package:Pilll/record/pill_mark_model.dart';
import 'package:flutter/material.dart';

abstract class PillSheetModel extends ChangeNotifier {
  int _index;
  get index => _index;
  set index(value) {
    _index = value;
    regenerate();
    notifyListeners();
  }

  List<PillMarkModel> marks;
  final PillSheetType pillSheetType;

  PillSheetModel(this.pillSheetType);
  void regenerate();
}

class MainPillSheetModel extends PillSheetModel {
  MainPillSheetModel(PillSheetType pillSheetType) : super(pillSheetType) {
    regenerate();
  }

  PillMarkState pillMarkStateWithNumber(int number) {
    return number >= pillSheetType.beginingWithoutTakenPeriod
        ? PillMarkState.notTaken
        : PillMarkState.none;
  }

  @override
  void regenerate() {
    this.marks = List.generate(
      28,
      (index) => MainPillMarkModel(
        pillMarkStateWithNumber(index),
        pillSheetType,
      ),
    );
  }
}

class InitialSettingPillSheetModel extends PillSheetModel {
  InitialSettingPillSheetModel(PillSheetType pillSheetType)
      : super(pillSheetType) {
    regenerate();
  }

  @override
  void regenerate() {
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
