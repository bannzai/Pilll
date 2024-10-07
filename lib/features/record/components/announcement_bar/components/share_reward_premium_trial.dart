import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/picker/picker_toolbar.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/native/present_share_to_sns_for_reward_premium_trial.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class ShareRewardPremiumTrialAnnoumcenetBar extends HookConsumerWidget {
  final User user;

  const ShareRewardPremiumTrialAnnoumcenetBar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applyShareRewardPremiumTrial = ref.watch(applyShareRewardPremiumTrialProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      color: PilllColors.primary,
      child: GestureDetector(
        onTap: () async {
          analytics.logEvent(name: "pressed_share_reward_announcement_bar");

          _showPicker(context, (shareToSNSKind) {
            presentShareToSNSForPremiumTrialReward(shareToSNSKind, () async {
              await applyShareRewardPremiumTrial(user);
            });
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            const Spacer(),
            const Text(
              "SNSシェアしてプレミアム機能を7日間無料で再体験できます！\nタップしてシェアしましょう！",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: TextColor.white,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SvgPicture.asset(
              "images/arrow_right.svg",
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context, Function(ShareToSNSKind) completionHandler) {
    int selected = ShareToSNSKind.values.first.index;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("どちらにシェアしますか？"),
            PickerToolbar(
              done: (() {
                completionHandler(ShareToSNSKind.values[selected]);
                Navigator.pop(context);
              }),
              cancel: (() {
                Navigator.pop(context);
              }),
            ),
            SizedBox(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    selected = index;
                  },
                  scrollController: FixedExtentScrollController(initialItem: selected),
                  children: ShareToSNSKind.values.map((e) => Text(e.rawValue)).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
