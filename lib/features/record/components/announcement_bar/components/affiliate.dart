import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/entity/affiliate.codegen.dart';
import 'package:pilll/provider/affiliate.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:url_launcher/url_launcher.dart';

final shownContentsProvider = Provider((ref) => ref.watch(affiliateProvider).asData?.value?.contents.where((e) => !e.isHidden).toList() ?? []);
final affiliateIndexProvider = Provider((ref) {
  final contents = ref.watch(shownContentsProvider);
  return ([...contents.indexed].toList()..shuffle()).firstOrNull?.$1 ?? 0;
});

class AffiliateAnnouncementBar extends HookConsumerWidget {
  final Affiliate affiliate;
  final VoidCallback onClose;
  const AffiliateAnnouncementBar({
    Key? key,
    required this.affiliate,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contents = ref.watch(shownContentsProvider);
    final index = ref.watch(affiliateIndexProvider);
    if (contents.isEmpty || contents.length <= index) {
      return Container();
    }
    return AffiliateImageAnnouncementBar(content: contents[index], affiliate: affiliate, onClose: onClose);
  }
}

class AffiliateImageAnnouncementBar extends StatelessWidget {
  final Affiliate affiliate;
  final AffiliateContent content;
  final VoidCallback onClose;

  const AffiliateImageAnnouncementBar({
    Key? key,
    required this.affiliate,
    required this.content,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onClose = this.onClose;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(name: "affiliate_image_tapped");
          launchUrl(Uri.parse(content.destinationURL));
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
                    analytics.logEvent(name: "affiliate_image_is_closed");
                    onClose();
                  },
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                ),
                const Spacer(),
                SvgPicture.asset(
                  "images/arrow_right.svg",
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  height: 20,
                  width: 20,
                ),
              ],
            ),
            Image.network(
              content.imageURL,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
