import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/platform/platform.dart';
import 'package:url_launcher/url_launcher.dart';

class LifetimeSubscriptionWarningAnnouncementBar extends HookConsumerWidget {
  final ValueNotifier<bool> isClosed;

  const LifetimeSubscriptionWarningAnnouncementBar({super.key, required this.isClosed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      analytics.logEvent(name: 'lifetime_subscription_warning_viewed');
      return null;
    }, []);

    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(name: 'lifetime_subscription_warning_tapped');
          _openSubscriptionManagementPage();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: const Icon(Icons.close, color: Colors.white, size: 24),
              onTap: () {
                analytics.logEvent(name: 'lifetime_subscription_warning_closed');
                isClosed.value = true;
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                L.lifetimeSubscriptionWarning,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: FontFamily.japanese, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset('images/arrow_right.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), height: 16, width: 16),
          ],
        ),
      ),
    );
  }

  void _openSubscriptionManagementPage() {
    launchUrl(Uri.parse(subscriptionManagementURL));
  }
}
