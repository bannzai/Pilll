import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/user.dart';

class LocalNotificationMigrateResolver extends HookConsumerWidget {
  final Widget Function(BuildContext) builder;
  const LocalNotificationMigrateResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).asData?.value;

    if (user != null && !user.useLocalNotificationForReminder) {
      Future.microtask(() {
        ref.read(updateUseLocalNotificationProvider).call(user, true);
      });
    }

    return builder(context);
  }
}
