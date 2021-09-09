import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_type_column.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillSheetTypeSelectBodyTemplate extends StatelessWidget {
  final PrimaryButton? doneButton;
  final SecondaryButton? signinButton;
  final PillSheetType? selectedPillSheetType;
  final void Function(PillSheetType type) onSelect;

  const PillSheetTypeSelectBodyTemplate({
    Key? key,
    required this.doneButton,
    required this.signinButton,
    required this.onSelect,
    required this.selectedPillSheetType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doneButton = this.doneButton;
    final signinButton = this.signinButton;

    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(height: 24),
          Text("飲んでいるピルシートのタイプはどれ？",
              style: FontType.sBigTitle.merge(TextColorStyle.main)),
          SizedBox(height: 24),
          ..._chunckedPillSheetTypes()
              .map((pillSheetTypes) {
                return [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pillSheetTypes
                        .asMap()
                        .map(
                          (index, pillSheetType) {
                            if (index == 0) {
                              return MapEntry(index, [
                                _pillSheet(pillSheetType),
                                SizedBox(width: 16),
                              ]);
                            } else {
                              return MapEntry(
                                  index, [_pillSheet(pillSheetType)]);
                            }
                          },
                        )
                        .values
                        .expand((element) => element)
                        .toList(),
                  ),
                ];
              })
              .expand((element) => element)
              .toList(),
          SizedBox(height: 10),
          if (doneButton != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: doneButton,
            ),
          if (signinButton != null) ...[
            SizedBox(height: 20),
            signinButton,
          ],
          SizedBox(height: 35),
        ],
      ),
    );
  }

  List<List<PillSheetType>> _chunckedPillSheetTypes() {
    final List<List<PillSheetType>> chunkedPillSheetTypes = [];
    final pillSheetTypes = PillSheetType.values;
    for (int i = 0; i < pillSheetTypes.length; i += 2) {
      chunkedPillSheetTypes.add(pillSheetTypes.sublist(
          i, i + 2 > pillSheetTypes.length ? pillSheetTypes.length : i + 2));
    }
    return chunkedPillSheetTypes;
  }

  Widget _pillSheet(PillSheetType type) {
    return GestureDetector(
      onTap: () {
        onSelect(type);
      },
      child: PillSheetTypeColumn(
        pillSheetType: type,
        selected: selectedPillSheetType == type,
      ),
    );
  }
}
