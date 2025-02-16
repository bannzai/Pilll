import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/datetime/day.dart';

class RestDurationAnnouncementBar extends StatelessWidget {
  const RestDurationAnnouncementBar({
    super.key,
    required this.restDurationNotification,
  });

  final String restDurationNotification;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: AppColors.primary,
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
    final activePillSheet = latestPillSheetGroup?.activePillSheet;
    if (activePillSheet == null) {
      return null;
    }
    if (activePillSheet.deletedAt != null) {
      return null;
    }
    final restDuration = latestPillSheetGroup?.lastActiveRestDuration;
    if (restDuration != null) {
      final day = daysBetween(restDuration.beginDate.date(), today()) + 1;
      return L.pauseTakingDay(day);
    }

    if (activePillSheet.typeInfo.dosingPeriod < activePillSheet.todayPillNumber) {
      final day = activePillSheet.todayPillNumber - activePillSheet.typeInfo.dosingPeriod;
      return L.restDurationDays(activePillSheet.pillSheetType.notTakenWord, day);
    }

    const threshold = 4;
    if (activePillSheet.pillSheetType.notTakenWord.isNotEmpty) {
      if (activePillSheet.typeInfo.dosingPeriod - threshold + 1 < activePillSheet.todayPillNumber) {
        final diff = activePillSheet.typeInfo.dosingPeriod - activePillSheet.todayPillNumber;
        return L.daysUntilPausePeriod(diff + 1, activePillSheet.pillSheetType.notTakenWord);
      }
    }
    return null;
  }
}
