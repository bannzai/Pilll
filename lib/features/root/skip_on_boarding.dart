import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/home/home_page.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/features/root/initial_setting_or_app_page.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/utils/router.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

class SkipOnBoarding extends HookConsumerWidget {
  const SkipOnBoarding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfigParameter = ref.watch(remoteConfigParameterProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);
    final didEndInitialSettingNotifier = ref.watch(boolSharedPreferencesProvider(BoolKey.didEndInitialSetting).notifier);
    final initialSettingStateNotifier = ref.watch(initialSettingStateNotifierProvider.notifier);
    final navigator = Navigator.of(context);

    useEffect(() {
      final f = (() async {
        if (remoteConfigParameter.skipOnBoarding) {
          await initialSettingStateNotifier.register();
          await registerReminderLocalNotification.call();
          await AppRouter.endInitialSetting(navigator, didEndInitialSettingNotifier);
        }
      });

      f();
      return null;
    }, []);

    if (!remoteConfigParameter.skipOnBoarding) {
      return const InitialSettingOrAppPage();
    } else {
      return const HomePage();
    }
  }
}
