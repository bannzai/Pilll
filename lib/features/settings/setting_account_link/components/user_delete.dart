import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/google.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDelete extends HookConsumerWidget {
  const UserDelete({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAppleLinked = ref.watch(isAppleLinkedProvider);
    final isGoogleLinked = ref.watch(isGoogleLinkedProvider);
    final cancelReminderLocalNotification = ref.watch(cancelReminderLocalNotificationProvider);
    final firebaseAuthUser = ref.watch(firebaseUserStateProvider);

    useEffect(() {
      if (firebaseAuthUser.asData?.value == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(context: context, builder: (context) => const _CompletedDialog());
        });
      }
      return null;
    }, [firebaseAuthUser]);

    return ListTile(
      title: Text(
        L.withdraw,
        style: const TextStyle(color: AppColors.danger, fontSize: 16, fontFamily: FontFamily.japanese),
      ),
      trailing: const Icon(Icons.delete, color: AppColors.danger),
      horizontalTitleGap: 4,
      onTap: () async {
        showDiscardDialog(
          context,
          title: L.userInformationWillBeDeleted,
          message: L.withdrawalMessage,
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
                await (_delete(context, isAppleLinked: isAppleLinked, isGoogleLinked: isGoogleLinked), cancelReminderLocalNotification()).wait;
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, {required bool isAppleLinked, required bool isGoogleLinked}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool(BoolKey.didEndInitialSetting, false);
      await FirebaseAuth.instance.currentUser?.delete();
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == 'requires-recent-login') {
        if (!context.mounted) return;
        showDiscardDialog(
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
                // ignore: use_build_context_synchronously
                await _delete(context, isAppleLinked: isAppleLinked, isGoogleLinked: isGoogleLinked);
              },
            ),
          ],
        );
      } else {
        errorLogger.recordError(error, stackTrace);
        if (context.mounted) showErrorAlert(context, error);
      }
    } catch (error) {
      if (context.mounted) showErrorAlert(context, error);
    }
  }
}

class _CompletedDialog extends StatelessWidget {
  const _CompletedDialog();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L.withdrawalCompleted,
            style: const TextStyle(color: TextColor.main, fontFamily: FontFamily.japanese, fontWeight: FontWeight.w700, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            L.appExitMessage,
            style: const TextStyle(color: TextColor.main, fontFamily: FontFamily.japanese, fontWeight: FontWeight.w400, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            child: PrimaryButton(
              onPressed: () async {
                exit(0);
              },
              text: L.oK,
            ),
          ),
        ],
      ),
    );
  }
}
