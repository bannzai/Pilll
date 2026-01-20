import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
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
                'images/laugh.svg',
                height: 10,
                colorFilter: const ColorFilter.mode(
                  AppColors.green,
                  BlendMode.srcIn,
                ),
              ),
            );
          case PhysicalConditionStatus.bad:
            widgets.add(
              SvgPicture.asset(
                'images/angry.svg',
                height: 10,
                colorFilter: const ColorFilter.mode(
                  AppColors.danger,
                  BlendMode.srcIn,
                ),
              ),
            );
        }
      }
      if (diary.hasSex) {
        widgets.add(
          const Icon(Icons.favorite, size: 10, color: AppColors.pinkRed),
        );
      }
      if (diary.physicalConditions.isNotEmpty) {
        widgets.add(
          const Icon(Icons.accessibility_new, size: 10, color: AppColors.gray),
        );
      }
      if (diary.memo.isNotEmpty) {
        widgets.add(
          const Icon(Icons.description, size: 10, color: AppColors.gray),
        );
      }
    }

    if (schedule != null) {
      widgets.add(
        const Icon(Icons.schedule, color: AppColors.primary, size: 10),
      );
    }

    if (widgets.length > 3) {
      final remain = widgets.length - 2;
      widgets = widgets.sublist(0, 2);
      widgets.add(
        Text(
          '+$remain',
          style: TextStyle(
            fontFamily: FontFamily.number,
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: TextColor.highEmphasis(TextColor.black),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final element in widgets.indexed) ...[
          element.$2,
          if (element.$1 != widgets.indexed.last.$1) const SizedBox(width: 2),
        ],
      ],
    );
  }
}
