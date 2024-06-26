import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SkipInitialSetting extends HookConsumerWidget {
  final Widget Function(BuildContext) homePageBuilder;
  final Widget Function(BuildContext) initialSettingPageBuilder;
  const SkipInitialSetting({
    super.key,
    required this.homePageBuilder,
    required this.initialSettingPageBuilder,
  });

  // 起動時にログインができなくなるユーザーがいてこれが起因している可能性がある。今は使用していないので一時的にコメントアウト
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final remoteConfigParameter = ref.watch(remoteConfigParameterProvider);
    // final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);
    // final didEndInitialSettingNotifier = ref.watch(boolSharedPreferencesProvider(BoolKey.didEndInitialSetting).notifier);
    // final initialSettingStateNotifier = ref.watch(initialSettingStateNotifierProvider.notifier);
    // final navigator = Navigator.of(context);

    // useEffect(() {
    //   final f = (() async {
    //     if (remoteConfigParameter.skipInitialSetting) {
    //       try {
    //         await initialSettingStateNotifier.register();
    //         await registerReminderLocalNotification();
    //         await AppRouter.endInitialSetting(navigator, didEndInitialSettingNotifier);
    //       } catch (error) {
    //         if (context.mounted) showErrorAlert(context, error.toString());
    //       }
    //     }
    //   });

    //   f();
    //   return null;
    // }, []);

    // if (remoteConfigParameter.skipInitialSetting) {
    // return homePageBuilder(context);
    // } else {
    return initialSettingPageBuilder(context);
    // }
  }
}
