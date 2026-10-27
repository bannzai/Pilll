import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_type_column.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillSheetTypeSelectBodyTemplate extends StatelessWidget {
  final PillSheetType? selectedFirstPillSheetType;
  final void Function(PillSheetType type) onSelect;

  const PillSheetTypeSelectBodyTemplate({
    super.key,
    required this.onSelect,
    required this.selectedFirstPillSheetType,
  });

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
            Flexible(child: Container(constraints: PillSheetTypeColumn.boxConstraints)),
          ],
        ),
      ],
    );
  }

  // 説明文が長い言語でカードが画面幅を超えて Row が溢れないよう、各カードを Row の半分までに収める。
  // カード内の Text は幅が決まることで折り返す
  Widget _pillSheet(PillSheetType type) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(
            name: 'pill_sheet_type_selected',
            parameters: {
              'pill_sheet_type': type.toString(),
              'pill_sheet_name': type.fullName,
            },
          );
          onSelect(type);
        },
        child: PillSheetTypeColumn(
          pillSheetType: type,
          selected: selectedFirstPillSheetType == type,
        ),
      ),
    );
  }
}
