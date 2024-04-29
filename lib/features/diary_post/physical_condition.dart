import 'package:pilll/features/diary_post/util.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DiaryPostPhysicalCondition extends StatelessWidget {
  const DiaryPostPhysicalCondition({
    super.key,
    required this.physicalCondition,
  });

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
                  color: physicalCondition.value == PhysicalConditionStatus.bad ? PilllColors.thinSecondary : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/angry.svg",
                        colorFilter: ColorFilter.mode(
                            physicalCondition.value == PhysicalConditionStatus.bad ? PilllColors.primary : TextColor.darkGray, BlendMode.srcIn)),
                    onPressed: () {
                      if (physicalCondition.value == PhysicalConditionStatus.bad) {
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
                  color: physicalCondition.value == PhysicalConditionStatus.fine ? PilllColors.thinSecondary : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/laugh.svg",
                        colorFilter: ColorFilter.mode(
                            physicalCondition.value == PhysicalConditionStatus.fine ? PilllColors.primary : TextColor.darkGray, BlendMode.srcIn)),
                    onPressed: () {
                      if (physicalCondition.value == PhysicalConditionStatus.fine) {
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
