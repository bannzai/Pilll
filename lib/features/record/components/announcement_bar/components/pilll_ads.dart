import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/pilll_ads.codegen.dart';
import 'package:pilll/utils/color.dart';
import 'package:url_launcher/url_launcher.dart';

class PilllAdsAnnouncementBar extends ConsumerWidget {
  final PilllAds pilllAds;
  final VoidCallback onClose;
  const PilllAdsAnnouncementBar({
    super.key,
    required this.pilllAds,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageURL = pilllAds.imageURL;
    if (imageURL != null) {
      return PilllAdsImageAnnouncementBar(
        imageURL: imageURL,
        pilllAds: pilllAds,
        onClose: onClose,
      );
    }
    return PilllAdsTextAnnouncementBar(pilllAds: pilllAds, onClose: onClose);
  }
}

class PilllAdsImageAnnouncementBar extends HookWidget {
  final PilllAds pilllAds;
  final String imageURL;
  final VoidCallback onClose;

  const PilllAdsImageAnnouncementBar({
    super.key,
    required this.pilllAds,
    required this.imageURL,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      analytics.logEvent(
        name: 'pilll_ads_image_viewed',
        parameters: {
          'pilll_ad_id': pilllAds.pilllAdID,
          'destination_url': pilllAds.destinationURL,
          'image_url': pilllAds.imageURL,
        },
      );
      return null;
    }, const []);

    return Container(
      color: HexColor.fromHex(pilllAds.hexColor),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(
            name: 'pilll_ads_image_tapped',
            parameters: {
              'pilll_ad_id': pilllAds.pilllAdID,
              'destination_url': pilllAds.destinationURL,
              'image_url': pilllAds.imageURL,
            },
          );
          final base = Uri.parse(pilllAds.destinationURL);
          launchUrl(
            base.replace(
              queryParameters: {
                'utm_source': 'pilll',
                'utm_medium': 'announcement_bar',
                'utm_campaign': pilllAds.pilllAdID ?? 'pilll_ads',
                ...base.queryParameters,
              },
            ),
          );
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
                  icon: Icon(
                    Icons.close,
                    color: HexColor.fromHex(pilllAds.closeButtonColor),
                    size: 24,
                  ),
                  onPressed: () {
                    analytics.logEvent(
                      name: 'pilll_ads_image_is_closed',
                      parameters: {
                        'pilll_ad_id': pilllAds.pilllAdID,
                        'destination_url': pilllAds.destinationURL,
                        'image_url': pilllAds.imageURL,
                      },
                    );
                    onClose();
                  },
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                ),
                const Spacer(),
                SvgPicture.asset(
                  'images/arrow_right.svg',
                  colorFilter: ColorFilter.mode(
                    HexColor.fromHex(pilllAds.chevronRightColor),
                    BlendMode.srcIn,
                  ),
                  height: 20,
                  width: 20,
                ),
              ],
            ),
            Image.network(imageURL, height: 50),
          ],
        ),
      ),
    );
  }
}

class PilllAdsTextAnnouncementBar extends HookWidget {
  final PilllAds pilllAds;
  final VoidCallback onClose;

  const PilllAdsTextAnnouncementBar({
    super.key,
    required this.pilllAds,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      analytics.logEvent(
        name: 'pilll_ads_text_viewed',
        parameters: {
          'pilll_ad_id': pilllAds.pilllAdID,
          'destination_url': pilllAds.destinationURL,
          'image_url': pilllAds.imageURL,
        },
      );
      return null;
    }, const []);

    return Container(
      color: HexColor.fromHex(pilllAds.hexColor),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(
            name: 'pilll_ads_text_tapped',
            parameters: {
              'pilll_ad_id': pilllAds.pilllAdID,
              'destination_url': pilllAds.destinationURL,
              'image_url': pilllAds.imageURL,
            },
          );
          final base = Uri.parse(pilllAds.destinationURL);
          launchUrl(
            base.replace(
              queryParameters: {
                'utm_source': 'pilll',
                'utm_medium': 'announcement_bar',
                'utm_campaign': pilllAds.pilllAdID ?? 'pilll_ads',
                ...base.queryParameters,
              },
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: const Icon(Icons.close, color: Colors.white, size: 24),
              onTap: () {
                analytics.logEvent(
                  name: 'pilll_ads_text_is_closed',
                  parameters: {
                    'pilll_ad_id': pilllAds.pilllAdID,
                    'destination_url': pilllAds.destinationURL,
                    'image_url': pilllAds.imageURL,
                  },
                );
                onClose();
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  for (final w in pilllAds.description.split('\\n'))
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
              'images/arrow_right.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
