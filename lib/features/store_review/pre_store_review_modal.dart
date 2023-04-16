import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

enum PreStoreReviewModalSelection { good, bad }

class PreStoreReviewModal extends HookConsumerWidget {
  const PreStoreReviewModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = useState<PreStoreReviewModalSelection?>(null);

    return Container(
      padding: const EdgeInsets.all(20),
      height: 300,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Pilllの感想をお聞かせください",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _goodOrBad(target: PreStoreReviewModalSelection.good, selection: selection),
                const SizedBox(width: 16),
                _goodOrBad(target: PreStoreReviewModalSelection.bad, selection: selection),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _goodOrBad({required PreStoreReviewModalSelection target, required ValueNotifier<PreStoreReviewModalSelection?> selection}) {
    final isSelected = target == selection.value;
    return GestureDetector(
      onTap: () => selection.value = target,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? PilllColors.primary.withOpacity(0.08) : PilllColors.white,
              border: Border.all(
                width: isSelected ? 2 : 1,
                color: isSelected ? PilllColors.primary : PilllColors.border,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  target == PreStoreReviewModalSelection.good ? "images/laugh.svg" : "images/angry.svg",
                  colorFilter: ColorFilter.mode(
                    isSelected ? PilllColors.primary : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),
                Text(target == PreStoreReviewModalSelection.good ? "満足している" : "満足では無い",
                    style: const TextStyle(color: PilllColors.primary, fontWeight: FontWeight.bold, fontFamily: FontFamily.japanese)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
