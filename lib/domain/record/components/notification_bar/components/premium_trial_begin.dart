import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () async {
          analytics.logEvent(name: "p_premium_trial_begin_n_b");
          await launchUrl(Uri.parse(
              "https://pilll.wraptas.site/3abd690f501549c48f813fd310b5f242"));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                analytics.logEvent(name: "p_premium_trial_begin_n_b_close");
                store.closePremiumTrialBeginNotification();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const Spacer(),
            Text(
              "$latestDay日後まですべての機能を使えます",
              style: TextColorStyle.white.merge(FontType.descriptionBold),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SvgPicture.asset(
              "images/arrow_right.svg",
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
