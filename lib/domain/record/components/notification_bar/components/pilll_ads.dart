import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:url_launcher/url_launcher.dart';

class PilllAdsNotificationBar extends HookConsumerWidget {
  final VoidCallback? onClose;
  const PilllAdsNotificationBar({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color(0xFFFC7CA4),
      child: GestureDetector(
        onTap: () {
          launchUrl(Uri.parse("https://mederi.jp/pr/tvcmdoctor01/?utm_source=Pilll_reminder&utm_medium=Pilll_reminder&utm_campaign=202208"));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: onClose != null
                      ? () {
                          analytics.logEvent(name: "pilll_ads_is_closed");
                          onClose?.call();
                        }
                      : null,
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                ),
                const Spacer(),
                SvgPicture.asset(
                  "images/arrow_right.svg",
                  color: Colors.white,
                  height: 24,
                  width: 24,
                ),
              ],
            ),
            Image.asset("images/mederi_pill_ads.png", height: 50),
          ],
        ),
      ),
    );
  }
}
