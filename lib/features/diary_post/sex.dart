import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/features/diary_post/util.dart';

class DiaryPostSex extends StatelessWidget {
  final Diary diary;
  final ValueNotifier<bool> sex;
  const DiaryPostSex({
    Key? key,
    required this.diary,
    required this.sex,
  }) : super(key: key);

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
              decoration: BoxDecoration(shape: BoxShape.circle, color: diary.hasSex ? PilllColors.thinSecondary : PilllColors.disabledSheet),
              child: SvgPicture.asset("images/heart.svg", color: diary.hasSex ? PilllColors.primary : TextColor.darkGray)),
        ),
        const Spacer(),
      ],
    );
  }
}
