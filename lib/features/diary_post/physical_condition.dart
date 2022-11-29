import 'package:pilll/features/diary_post/util.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DiaryPostPhysicalCondition extends StatelessWidget {
  const DiaryPostPhysicalCondition({
    Key? key,
    required this.diary,
    required this.physicalCondition,
  }) : super(key: key);

  final Diary diary;
  final ValueNotifier<PhysicalConditionStatus?> physicalCondition;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("体調", style: sectionTitle),
        const Spacer(),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: PilllColors.divider,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  color: diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.bad) ? PilllColors.thinSecondary : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/angry.svg",
                        color: diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.bad) ? PilllColors.primary : TextColor.darkGray),
                    onPressed: () {
                      if (diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.bad)) {
                        physicalCondition.value = null;
                      } else {
                        physicalCondition.value = PhysicalConditionStatus.bad;
                      }
                    }),
              ),
              const SizedBox(height: 48, child: VerticalDivider(width: 1, color: PilllColors.divider)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                  color: diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.fine) ? PilllColors.thinSecondary : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/laugh.svg",
                        color: diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.fine) ? PilllColors.primary : TextColor.darkGray),
                    onPressed: () {
                      if (diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.fine)) {
                        physicalCondition.value = null;
                      } else {
                        physicalCondition.value = PhysicalConditionStatus.fine;
                      }
                    }),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
