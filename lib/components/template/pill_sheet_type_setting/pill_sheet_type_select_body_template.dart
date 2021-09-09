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
          Expanded(
            child: GridView.count(
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: EdgeInsets.only(left: 34, right: 34),
              childAspectRatio: PillSheetTypeColumnConstant.aspectRatio,
              crossAxisCount: 2,
              children: [
                ...PillSheetType.values.map((e) => _pillSheet(e)).toList(),
              ],
            ),
          ),
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
