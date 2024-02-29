import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/page/ok_dialog.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

class LocalNotificationMigrateResolver extends HookConsumerWidget {
  final Widget Function(BuildContext) builder;
  const LocalNotificationMigrateResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    final user = ref.watch(userProvider).asData?.value;
    final migrateToLocalNotificationAlert = useState(sharedPreferences.getBool(BoolKey.migrateToLocalNotificationAlert) ?? false);
    migrateToLocalNotificationAlert.addListener(() {
      sharedPreferences.setBool(BoolKey.migrateToLocalNotificationAlert, migrateToLocalNotificationAlert.value);
    });

    if (!migrateToLocalNotificationAlert.value && user != null) {
      Future.microtask(() {
        showOKDialog(context, title: "服用通知機能が新しくなりました", message: """
多くの方に手伝っていただきありがとうございます。このバージョンから服用通知機能が新しくなります。旧:服用通知β表記されていた機能になります。問題が発生した場合はお手数ですがアプリ内の「お問い合わせ」よりお知らせください
""", ok: () {
          ref.read(updateUseLocalNotificationProvider).call(user, true);
          migrateToLocalNotificationAlert.value = true;
        });
      });
    }

    return builder(context);
  }
}
