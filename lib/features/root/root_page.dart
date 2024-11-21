import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/home/home_page.dart';
import 'package:pilll/features/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/features/root/resolver/firebase_auth_resolver.dart';
import 'package:pilll/features/root/resolver/force_update.dart';
import 'package:pilll/features/root/resolver/initial_setting_or_app_page.dart';
import 'package:pilll/features/root/resolver/migration20240819.dart';
import 'package:pilll/features/root/resolver/pill_sheet_appearance_mode_migration.dart';
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
    return ForceUpdate(
      builder: (_) => FirebaseAuthResolver(
        builder: (_, user) => UserSetup(
          userID: user.uid,
          builder: (_) => Stack(
            children: [
              UserStreamResolver(
                  stream: (user) =>
                      analyticsDebugIsEnabled = user.analyticsDebugIsEnabled),
              const SyncDataResolver(),
              const Migration20240819(),
              InitialSettingOrAppPage(
                initialSettingPageBuilder: (_) => ShowPaywallOnAppLaunch(
                  builder: (_) => SkipInitialSetting(
                    initialSettingPageBuilder: (context) =>
                        InitialSettingPillSheetGroupPageRoute.screen(),
                    homePageBuilder: (_) =>
                        PillSheetAppearanceModeMigrationResolver(
                      builder: (_) => const HomePage(),
                    ),
                  ),
                ),
                homePageBuilder: (_) =>
                    PillSheetAppearanceModeMigrationResolver(
                  builder: (_) => const HomePage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
