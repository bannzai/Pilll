import 'package:flutter/cupertino.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/material.dart';

class TodayTakenPillNumber extends StatelessWidget {
  final PillSheetGroup? pillSheetGroup;
  final VoidCallback onPressed;

  const TodayTakenPillNumber({super.key, required this.pillSheetGroup, required this.onPressed});

  PillSheetAppearanceMode get _appearanceMode => pillSheetGroup?.pillSheetAppearanceMode ?? PillSheetAppearanceMode.number;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // TODO: [Localizations]
          if (_appearanceMode.isSequential)
            Text(
              L.todayIsTaking,
              style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w300, fontSize: 14, color: TextColor.noshime),
            ),
          if (!_appearanceMode.isSequential)
            Text(
              L.todayPillToTake,
              style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w300, fontSize: 14, color: TextColor.noshime),
            ),
          _content(),
        ],
      ),
      onTap: () {
        analytics.logEvent(name: 'tapped_record_page_today_pill');
        if (pillSheetGroup?.activePillSheet == null) {
          return;
        }
        onPressed();
      },
    );
  }

  Widget _content() {
    final pillSheetGroup = this.pillSheetGroup;
    final activePillSheet = this.pillSheetGroup?.activePillSheet;
    if (pillSheetGroup == null || activePillSheet == null || pillSheetGroup.isDeactived || pillSheetGroup.lastActiveRestDuration != null) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          '-',
          style: TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w300, fontSize: 14, color: TextColor.noshime),
        ),
      );
    }
    if (activePillSheet.inNotTakenDuration) {
      return Text(
        L.withDay('${activePillSheet.pillSheetType.notTakenWord}${activePillSheet.todayPillNumber - activePillSheet.typeInfo.dosingPeriod}'),
        style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w600, fontSize: 14, color: TextColor.main),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: <Widget>[
        if (_appearanceMode == PillSheetAppearanceMode.number) ...[
          Text(
            '${activePillSheet.todayPillNumber}',
            style: const TextStyle(fontFamily: FontFamily.number, fontWeight: FontWeight.w500, fontSize: 40, color: TextColor.main),
          ),
          Text(
            L.number,
            style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w600, fontSize: 14, color: TextColor.noshime),
          ),
        ],
        if (_appearanceMode == PillSheetAppearanceMode.date) ...[
          Text(
            '${activePillSheet.todayPillNumber}',
            style: const TextStyle(fontFamily: FontFamily.number, fontWeight: FontWeight.w500, fontSize: 40, color: TextColor.main),
          ),
          Text(
            L.number,
            style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w600, fontSize: 14, color: TextColor.noshime),
          ),
        ],
        if (_appearanceMode.isSequential) ...[
          Text(
            '${pillSheetGroup.sequentialTodayPillNumber}',
            style: const TextStyle(fontFamily: FontFamily.number, fontWeight: FontWeight.w500, fontSize: 40, color: TextColor.main),
          ),
          Text(
            L.dayNumber,
            style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w600, fontSize: 14, color: TextColor.noshime),
          ),
        ],
      ],
    );
  }
}
