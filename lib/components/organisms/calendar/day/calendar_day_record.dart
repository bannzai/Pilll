import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';

class CalendarDayRecord extends StatelessWidget {
  final Diary? diary;
  final Schedule? schedule;

  const CalendarDayRecord({
    super.key,
    required this.diary,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    final diary = this.diary;
    final schedule = this.schedule;

    if (diary != null) {
      final physicalConditionStatus = diary.physicalConditionStatus;
      if (physicalConditionStatus != null) {
        switch (physicalConditionStatus) {
          case PhysicalConditionStatus.fine:
            widgets.add(
              SvgPicture.asset(
                "images/laugh.svg",
                colorFilter: const ColorFilter.mode(PilllColors.green, BlendMode.srcIn),
              ),
            );
          case PhysicalConditionStatus.bad:
            widgets.add(
              SvgPicture.asset(
                "images/angry.svg",
                colorFilter: const ColorFilter.mode(PilllColors.danger, BlendMode.srcIn),
              ),
            );
        }
      }
      if (diary.physicalConditions.isNotEmpty) {
        widgets.add(
          const Icon(
            Icons.accessibility_new,
            color: PilllColors.gray,
          ),
        );
      }
      if (diary.hasSex) {
        widgets.add(
          const Icon(
            Icons.favorite,
            color: PilllColors.pinkRed,
          ),
        );
      }
      if (diary.memo.isNotEmpty) {
        widgets.add(
          const Icon(
            Icons.description,
            color: PilllColors.gray,
          ),
        );
      }
    }

    if (schedule != null) {
      widgets.add(
        const Icon(Icons.schedule, color: PilllColors.primary, size: 12),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }
}
