import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PreStoreReviewModal extends HookConsumerWidget {
  const PreStoreReviewModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Pilllの感想をお聞かせください",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.japanese,
              color: TextColor.main,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("images/laugh.svg", colorFilter: const ColorFilter.mode(PilllColors.primary, BlendMode.srcIn)),
              const SizedBox(width: 16),
              SvgPicture.asset("images/angry.svg", colorFilter: const ColorFilter.mode(PilllColors.primary, BlendMode.srcIn)),
            ],
          ),
        ],
      ),
    );
  }
}
