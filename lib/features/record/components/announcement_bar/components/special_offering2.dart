import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/special_offering/page.dart';
import 'package:pilll/utils/analytics.dart';

class SpecialOfferingAnnouncementBar2 extends HookConsumerWidget {
  final ValueNotifier<bool> specialOfferingIsClosed;
  const SpecialOfferingAnnouncementBar2({
    super.key,
    required this.specialOfferingIsClosed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      analytics.logEvent(name: 'special_offering_announcement_bar2_viewed');
      return null;
    }, []);
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 4, left: 8, right: 8),
      color: AppColors.primary,
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(name: 'special_offering_announcement_bar2_tap');
          showModalBottomSheet(
            context: context,
            builder: (context) => SpecialOfferingPage(specialOfferingIsClosed: specialOfferingIsClosed),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            enableDrag: false,
            isDismissible: false,
          );
        },
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                // TODO: 訴求文言を後から埋める
                'TODO: 訴求文言をここに入れる',
                style: TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: TextColor.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: SvgPicture.asset(
                  'images/arrow_right.svg',
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                onPressed: () {},
                iconSize: 24,
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
