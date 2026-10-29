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

  /// 同じ段のカードの間隔。PR #1955 より前の組み方 (カードが内容の幅で並び、間を 16 空ける) の見た目を保つ値
  static const double _cardGap = 16;

  @override
  Widget build(BuildContext context) {
    // 各段を同じ幅 (カード 2 枚 + 間隔) に固定し、段の中ではカードを Expanded で等分する。
    // カードが訳文の長さで幅を変えると段ごとに左端がずれて列にならないため (PR #1955 の QA で ja・en で確認)。
    // 画面がこの幅より狭い時は Expanded が縮めて Row が溢れない
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: PillSheetTypeColumnConstant.width * 2 + _cardGap),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pillSheet(PillSheetType.pillsheet_21),
                const SizedBox(width: _cardGap),
                _pillSheet(PillSheetType.pillsheet_28_4),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pillSheet(PillSheetType.pillsheet_28_7),
                const SizedBox(width: _cardGap),
                _pillSheet(PillSheetType.pillsheet_28_0),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pillSheet(PillSheetType.pillsheet_24_rest_4),
                const SizedBox(width: _cardGap),
                _pillSheet(PillSheetType.pillsheet_21_0),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pillSheet(PillSheetType.pillsheet_24_0),
                const SizedBox(width: _cardGap),
                // 最後の段の右側は空き枠。Expanded で左のカードと同じ幅を占めて列を揃える
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 種類 [type] のカード。段の幅を 2 枚で等分する幅を占め、タップで analytics を送って [onSelect] を呼ぶ
  Widget _pillSheet(PillSheetType type) {
    return Expanded(
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
