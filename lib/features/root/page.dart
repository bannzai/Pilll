import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/home/page.dart';
import 'package:pilll/features/initial_setting/pill_sheet_group/page.dart';
import 'package:pilll/features/localizations/resolver.dart';
import 'package:pilll/features/root/resolver/firebase_auth_resolver.dart';
import 'package:pilll/features/root/resolver/force_update.dart';
import 'package:pilll/features/root/resolver/initial_setting_or_app_page.dart';
import 'package:pilll/features/root/resolver/show_paywall_on_app_launch.dart';
import 'package:pilll/features/root/resolver/skip_initial_setting.dart';
import 'package:pilll/features/root/resolver/sync_data.dart';
import 'package:pilll/features/root/resolver/user_setup.dart';
import 'package:pilll/features/root/resolver/user_stream.dart';
import 'package:pilll/utils/analytics.dart';

class RootPage extends HookConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLocalizationResolver(
      builder: (context) {
        debugPrint('Resolved: AppLocalizationResolver');
        return ForceUpdate(
          builder: (_) {
            debugPrint('Resolved: ForceUpdateResolver');
            return FirebaseAuthResolver(
              builder: (_, user) {
                debugPrint('Resolved: FirebaseAuthResolver');
                return UserSetup(
                  userID: user.uid,
                  builder: (_) {
                    debugPrint('Resolved: UserSetup');
                    return Stack(
                      children: [
                        UserStreamResolver(stream: (user) => analyticsDebugIsEnabled = user.analyticsDebugIsEnabled),
                        const SyncDataResolver(),
                        InitialSettingOrAppPage(
                          initialSettingPageBuilder: (_) => ShowPaywallOnAppLaunch(
                            builder: (_) => SkipInitialSetting(
                              initialSettingPageBuilder: (context) => InitialSettingPillSheetGroupPageRoute.screen(),
                              homePageBuilder: (_) => const HomePage(),
                            ),
                          ),
                          homePageBuilder: (_) => const HomePage(),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
