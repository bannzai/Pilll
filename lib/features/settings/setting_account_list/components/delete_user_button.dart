import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
import 'package:pilll/features/root/localization/l.dart';  // Lクラスをインポート

class DeleteUserButton extends HookConsumerWidget {
  const DeleteUserButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAppleLinked = ref.watch(isAppleLinkedProvider);
    final isGoogleLinked = ref.watch(isGoogleLinkedProvider);
    final cancelReminderLocalNotification = ref.watch(cancelReminderLocalNotificationProvider);
    return Container(
      padding: const EdgeInsets.only(top: 54),
      child: AlertButton(
        onPressed: () async {
          showDiscardDialog(
            context,
            title: L.withdrawalCompleted,  // ユーザー情報が削除されますを翻訳
            message: L.withdraw,  // 退会をするとすべてデータが削除され、二度と同じアカウントでログインができなくなります。を翻訳
            actions: [
              AlertButton(
                text: L.cancel,  // キャンセルを翻訳
                onPressed: () async {
                  analytics.logEvent(name: 'cancel_delete_user');
                  Navigator.of(context).pop();
                },
              ),
              AlertButton(
                text: L.withdraw,  // 退会するを翻訳
                onPressed: () async {
                  analytics.logEvent(name: 'pressed_delete_user_button');
                  await (
                    _delete(
                      context,
                      isAppleLinked: isAppleLinked,
                      isGoogleLinked: isGoogleLinked,
                    ),
                    cancelReminderLocalNotification()
                  ).wait;
                },
              ),
            ],
          );
        },
        text: L.withdraw,  // 退会するを翻訳
      ),
    );
  }

  Future<void> _delete(
    BuildContext context, {
    required bool isAppleLinked,
    required bool isGoogleLinked,
  }) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool(BoolKey.didEndInitialSetting, false);
      await FirebaseAuth.instance.currentUser?.delete();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => const _CompletedDialog(),
      );
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == 'requires-recent-login') {
        if (!context.mounted) return;
        showDiscardDialog(
          context,
          title: L.reLogin,  // 再ログインしてくださいを翻訳
          message: L.reLogin,  // 退会前に本人確認のために再ログインをしてください。再ログイン後、自動的に退会処理が始まりますを翻訳
          actions: [
            AlertButton(
              text: L.cancel,  // キャンセルを翻訳
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            AlertButton(
              text: L.reLogin,  // 再ログインを翻訳
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
            L.withdrawalCompleted,  // 退会しましたを翻訳
            style: const TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            L.appExitMessage,  // アプリを一度終了します。新しく始める場合はアプリを再起動後、初期設定を行ってください。を翻訳
            style: const TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            child: PrimaryButton(
              onPressed: () async {
                exit(0);
              },
              text: L.oK,  // OKを翻訳
            ),
          ),
        ],
      ),
    );
  }
}
