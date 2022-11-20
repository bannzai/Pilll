import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class RecommendSignupNotificationBar extends HookConsumerWidget {
  final VoidCallback onTap;
  final VoidCallback onClose;
  const RecommendSignupNotificationBar({
    required this.onTap,
    required this.onClose,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: PilllColors.primary,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              alignment: Alignment.topLeft,
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
              onPressed: onClose,
              iconSize: 24,
              padding: EdgeInsets.zero,
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  "機種変更やスマホ紛失時に備えて\nアカウント登録しませんか？",
                  style: TextColorStyle.white.merge(const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  )),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    "images/arrow_right.svg",
                    color: Colors.white,
                  ),
                  onPressed: () {},
                  iconSize: 24,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
