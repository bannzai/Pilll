import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/push_notification.dart';

class PushNotificationResolver extends HookConsumerWidget {
  final User user;

  const PushNotificationResolver({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerRemotePushNotificationToken = ref.watch(registerRemotePushNotificationTokenProvider);

    useEffect(() {
      // Android 13ユーザー向けに通知の許可を取る必要がある。古いバージョンからアップグレードしたユーザーへの許可はアプリのメインストリームが始まってから取得するようにする
      // https://developer.android.com/guide/topics/ui/notifiers/notification-permission
      Future<void> f() async {
        try {
          debugPrint('[DEBUG] PushNotificationResolver');
          await requestNotificationPermissions(registerRemotePushNotificationToken);
        } catch (e) {
          if (context.mounted) {
            showErrorAlert(context, e);
          }
        }
      }

      f();

      return null;
    }, []);

    return const SizedBox();
  }
}
