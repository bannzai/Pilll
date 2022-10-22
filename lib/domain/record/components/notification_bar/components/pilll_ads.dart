import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/database/pilll_ads.dart';
import 'package:pilll/entity/pilll_ads.codegen.dart';
import 'package:pilll/util/color.dart';
import 'package:url_launcher/url_launcher.dart';

class PilllAdsNotificationBar extends HookConsumerWidget {
  final PilllAds pilllAds;
  final VoidCallback? onClose;
  const PilllAdsNotificationBar({
    Key? key,
    required this.pilllAds,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onClose = this.onClose;
    final imageURL = pilllAds.imageURL;

    return Container(
      color: HexColor.fromHex(pilllAds.hexColor),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(name: "pilll_ads_tapped");
          launchUrl(Uri.parse(pilllAds.destinationURL));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                onClose != null
                    ? IconButton(
                        alignment: Alignment.centerLeft,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          analytics.logEvent(name: "pilll_ads_is_closed");
                          onClose();
                        },
                        iconSize: 24,
                        padding: EdgeInsets.zero,
                      )
                    : const SizedBox(width: 24, height: 24),
                const Spacer(),
                SvgPicture.asset(
                  "images/arrow_right.svg",
                  color: Colors.white,
                  height: 20,
                  width: 20,
                ),
              ],
            ),
            if (imageURL != null) ...[
              Image.network(
                imageURL,
                height: 50,
              ),
            ],
            if (imageURL == null && pilllAds.description.isNotEmpty) ...[
              Text(pilllAds.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w700,
                  ))
            ],
          ],
        ),
      ),
    );
  }
}
