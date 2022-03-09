import 'package:pilll/components/organisms/pill_sheet/pill_sheet_type_column.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillSheetTypeSelectBodyTemplate extends StatelessWidget {
  final PillSheetType? selectedPillSheetType;
  final void Function(PillSheetType type) onSelect;

  const PillSheetTypeSelectBodyTemplate({
    Key? key,
    required this.onSelect,
    required this.selectedPillSheetType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pillSheet(PillSheetType.pillsheet_21),
            const SizedBox(width: 16),
            _pillSheet(PillSheetType.pillsheet_28_4),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pillSheet(PillSheetType.pillsheet_28_7),
            const SizedBox(width: 16),
            _pillSheet(PillSheetType.pillsheet_28_0),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pillSheet(PillSheetType.pillsheet_24_rest_4),
            const SizedBox(width: 16),
            _pillSheet(PillSheetType.pillsheet_21_0),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pillSheet(PillSheetType.pillsheet_24_0),
            const SizedBox(width: 16),
            Container(
              constraints: PillSheetTypeColumn.boxConstraints,
            ),
          ],
        ),
      ],
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
