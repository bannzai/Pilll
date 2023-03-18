import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';

class RestDurationAnnouncementBar extends StatelessWidget {
  const RestDurationAnnouncementBar({
    Key? key,
    required this.restDurationNotification,
  }) : super(key: key);

  final String restDurationNotification;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: PilllColors.primary,
      child: Center(
        child: Text(restDurationNotification,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: TextColor.white,
            )),
      ),
    );
  }

  static String? retrieveRestDurationNotification({required PillSheetGroup? latestPillSheetGroup}) {
    final activedPillSheet = latestPillSheetGroup?.activedPillSheet;
    if (activedPillSheet == null) {
      return null;
    }
    if (activedPillSheet.deletedAt != null) {
      return null;
    }
    final restDuration = activedPillSheet.activeRestDuration;
    if (restDuration != null) {
      final day = daysBetween(restDuration.beginDate.date(), today()) + 1;
      return "🌙 服用お休み $day日目";
    }

    if (activedPillSheet.typeInfo.dosingPeriod < activedPillSheet.todayPillNumber) {
      final day = activedPillSheet.todayPillNumber - activedPillSheet.typeInfo.dosingPeriod;
      return "${activedPillSheet.pillSheetType.notTakenWord}$day日目";
    }

    const threshold = 4;
    if (activedPillSheet.pillSheetType.notTakenWord.isNotEmpty) {
      if (activedPillSheet.typeInfo.dosingPeriod - threshold + 1 < activedPillSheet.todayPillNumber) {
        final diff = activedPillSheet.typeInfo.dosingPeriod - activedPillSheet.todayPillNumber;
        return "あと${diff + 1}日で${activedPillSheet.pillSheetType.notTakenWord}期間です";
      }
    }
    return null;
  }
}
