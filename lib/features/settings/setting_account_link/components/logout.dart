import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/google.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout extends HookConsumerWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancelReminderLocalNotification = ref.watch(cancelReminderLocalNotificationProvider);
    final isAppleLinked = ref.watch(isAppleLinkedProvider);
    final isGoogleLinked = ref.watch(isGoogleLinkedProvider);
    final firebaseUser = ref.watch(firebaseUserStateProvider);
    final firebaseUserValue = firebaseUser.valueOrNull;
    if (firebaseUserValue == null) {
      return const SizedBox.shrink();
    }
    if (firebaseUserValue.isAnonymous) {
      return const SizedBox.shrink();
    }

    return ListTile(
      title: Text(
        L.logout,
        style: const TextStyle(
          color: AppColors.danger,
          fontSize: 16,
          fontFamily: FontFamily.japanese,
        ),
      ),
      trailing: const Icon(Icons.logout, color: AppColors.primary),
      horizontalTitleGap: 4,
      onTap: () async {
        showDiscardDialog(
          context,
          title: L.logout,
          message: L.goToInitialSettingAndReloginIfNeededMessage,
          actions: [
            AlertButton(
              text: L.cancel,
              onPressed: () async {
                analytics.logEvent(name: 'cancel_delete_user');
                Navigator.of(context).pop();
              },
            ),
            AlertButton(
              text: L.withdraw,
              onPressed: () async {
                analytics.logEvent(name: 'pressed_delete_user_button');
                await (
                  _logout(
                    context,
                    isAppleLinked: isAppleLinked,
                    isGoogleLinked: isGoogleLinked,
                  ),
                  cancelReminderLocalNotification(),
                ).wait;
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context, {required bool isAppleLinked, required bool isGoogleLinked}) async {
    try {
      (await SharedPreferences.getInstance()).setBool(BoolKey.didEndInitialSetting, false);
      await CancelReminderLocalNotification().call();
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e, stackTrace) {
      if (e.code == 'requires-recent-login') {
        showDiscardDialog(
          // ignore: use_build_context_synchronously
          context,
          title: L.doReLogin,
          message: L.reLoginMessage,
          actions: [
            AlertButton(
              text: L.cancel,
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            AlertButton(
              text: L.reLogin,
              onPressed: () async {
                final navigator = Navigator.of(context);
                if (isAppleLinked) {
                  await appleReauthentification();
                } else if (isGoogleLinked) {
                  await googleReauthentification();
                } else {
                  errorLogger.log('it is not cooperate account');
                  exit(1);
                }
                navigator.pop();
                await _logout(
                  // ignore: use_build_context_synchronously
                  context,
                  isAppleLinked: isAppleLinked,
                  isGoogleLinked: isGoogleLinked,
                );
              },
            ),
          ],
        );
      } else {
        errorLogger.recordError(e, stackTrace);
        if (context.mounted) showErrorAlert(context, e);
      }
    } catch (e, stackTrace) {
      errorLogger.recordError(e, stackTrace);
      if (context.mounted) showErrorAlert(context, e);
    }
  }
}
