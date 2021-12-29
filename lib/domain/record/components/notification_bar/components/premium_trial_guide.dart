import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PremiumTrialGuideNotificationBar extends HookConsumerWidget {
  final VoidCallback onClose;
  final VoidCallback onTap;
  const PremiumTrialGuideNotificationBar({
    Key? key,
    required this.onClose,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _closeButtonIconWidth = 24;

    return GestureDetector(
      onTap: () {
        analytics.logEvent(name: "premium_trial_from_notification_bar");
        onTap();
      },
      child: Stack(
        children: [
          Positioned(
            top: 8,
            child: GestureDetector(
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: _closeButtonIconWidth,
              ),
              onTap: () {
                analytics.logEvent(name: "premium_trial_notification_closed");
                onClose();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: _closeButtonIconWidth),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  "プレミアム機能 お試し体験プレゼント中\n詳しくみる",
                  style: TextColorStyle.white.merge(FontType.descriptionBold),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: SvgPicture.asset(
                  "images/arrow_right.svg",
                  color: Colors.white,
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
