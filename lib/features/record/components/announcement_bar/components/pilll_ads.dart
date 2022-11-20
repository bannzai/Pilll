import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/pilll_ads.codegen.dart';
import 'package:pilll/utils/color.dart';
import 'package:url_launcher/url_launcher.dart';

class PilllAdsAnnouncementBar extends HookConsumerWidget {
  final PilllAds pilllAds;
  final VoidCallback onClose;
  const PilllAdsAnnouncementBar({
    Key? key,
    required this.pilllAds,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageURL = pilllAds.imageURL;
    if (imageURL != null) {
      return PilllAdsImageAnnouncementBar(imageURL: imageURL, pilllAds: pilllAds, onClose: onClose);
    } else {
      return PilllAdsTextAnnouncementBar(pilllAds: pilllAds, onClose: onClose);
    }
  }
}

class PilllAdsImageAnnouncementBar extends StatelessWidget {
  final PilllAds pilllAds;
  final String imageURL;
  final VoidCallback onClose;

  const PilllAdsImageAnnouncementBar({
    Key? key,
    required this.pilllAds,
    required this.imageURL,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onClose = this.onClose;

    return Container(
      color: HexColor.fromHex(pilllAds.hexColor),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(name: "pilll_ads_image_tapped");
          launchUrl(Uri.parse(pilllAds.destinationURL));
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
                  onPressed: () {
                    analytics.logEvent(name: "pilll_ads_image_is_closed");
                    onClose();
                  },
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                ),
                const Spacer(),
                SvgPicture.asset(
                  "images/arrow_right.svg",
                  color: Colors.white,
                  height: 20,
                  width: 20,
                ),
              ],
            ),
            Image.network(
              imageURL,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class PilllAdsTextAnnouncementBar extends StatelessWidget {
  final PilllAds pilllAds;
  final VoidCallback onClose;

  const PilllAdsTextAnnouncementBar({
    Key? key,
    required this.pilllAds,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor.fromHex(pilllAds.hexColor),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(name: "pilll_ads_text_tapped");
          launchUrl(Uri.parse(pilllAds.destinationURL));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
              onTap: () {
                analytics.logEvent(name: "pilll_ads_text_is_closed");
                onClose();
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  for (final w in pilllAds.description.split("\\n"))
                    Text(
                      w,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset(
              "images/arrow_right.svg",
              color: Colors.white,
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
