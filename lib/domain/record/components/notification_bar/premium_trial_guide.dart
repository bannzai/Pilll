import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store_parameter.dart';

class PremiumTrialGuideNotificationBar extends HookWidget {
  const PremiumTrialGuideNotificationBar({
    Key? key,
    required this.parameter,
  }) : super(key: key);

  final NotificationBarStoreParameter parameter;

  @override
  Widget build(BuildContext context) {
    final store = useProvider(notificationBarStoreProvider(parameter));

    return GestureDetector(
      onTap: () {
        analytics.logEvent(name: "premium_trial_from_notification_bar");
        showPremiumTrialModal(context, () {
          showPremiumTrialCompleteModalPreDialog(context);
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            alignment: Alignment.topLeft,
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              analytics.logEvent(name: "premium_trial_notification_closed");
              store.closePremiumTrialNotification();
            },
            iconSize: 24,
            padding: EdgeInsets.zero,
          ),
          Spacer(),
          Column(
            children: [
              Text(
                "プレミアム機能 お試し体験プレゼント中\n詳しくみる",
                style: TextColorStyle.white.merge(FontType.descriptionBold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "images/arrow_right.svg",
                  color: Colors.white,
                ),
                onPressed: () {},
                iconSize: 24,
                padding: EdgeInsets.all(8),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
