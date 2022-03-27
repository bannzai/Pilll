import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
import 'package:pilll/util/links.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumTrialBegin extends HookConsumerWidget {
  final int latestDay;
  final NotificationBarStateStore store;
  const PremiumTrialBegin({
    required this.latestDay,
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: GestureDetector(
        onTap: () async {
          analytics.logEvent(name: "p_premium_trial_begin_notification_bar");
          await launch(preimumLink);
        },
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
              onPressed: () {
                store.closePremiumTrialBeginNotification();
              },
              iconSize: 24,
              padding: EdgeInsets.zero,
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  "プレミアムお試し体験中（残り$latestDay日）",
                  style: TextColorStyle.white.merge(FontType.descriptionBold),
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
