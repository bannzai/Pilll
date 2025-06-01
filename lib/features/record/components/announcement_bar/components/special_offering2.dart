import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/special_offering/page2.dart';
import 'package:pilll/utils/analytics.dart';

class SpecialOfferingAnnouncementBar2 extends HookConsumerWidget {
  final ValueNotifier<bool> specialOfferingIsClosed2;
  final int missedDays;
  const SpecialOfferingAnnouncementBar2({
    super.key,
    required this.specialOfferingIsClosed2,
    required this.missedDays,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      analytics.logEvent(name: 'special_offering_announcement_bar2_view');
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
            builder: (context) => SpecialOfferingPage2(specialOfferingIsClosed2: specialOfferingIsClosed2),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            enableDrag: false,
            isDismissible: false,
          );
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '過去30日間で$missedDays日の飲み忘れがありました\n特別価格でプレミアムプランをゲット！',
                style: const TextStyle(
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
