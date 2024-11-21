import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/features/diary_post/util.dart';

class DiaryPostSex extends StatelessWidget {
  final ValueNotifier<bool> sex;
  const DiaryPostSex({
    super.key,
    required this.sex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("sex", style: sectionTitle),
        const SizedBox(width: 80),
        GestureDetector(
          onTap: () {
            sex.value = !sex.value;
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            width: 32,
            height: 32,
            decoration: BoxDecoration(shape: BoxShape.circle, color: sex.value ? PilllColors.thinSecondary : PilllColors.disabledSheet),
            child: SvgPicture.asset(sex.value ? "images/heart.svg" : "images/heart-stroke.svg"),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
