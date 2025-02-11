import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum PillSheetAppearanceMode {
  @JsonValue('number')
  number,
  @JsonValue('date')
  date,
  @JsonValue('sequential')
  sequential,
  @JsonValue('cyclicSequential')
  cyclicSequential,
}

extension PillSheetAppearanceModeExt on PillSheetAppearanceMode {
  bool get isSequential {
    switch (this) {
      case PillSheetAppearanceMode.number:
      case PillSheetAppearanceMode.date:
        return false;
      case PillSheetAppearanceMode.sequential:
      case PillSheetAppearanceMode.cyclicSequential:
        return true;
    }
  }
}
