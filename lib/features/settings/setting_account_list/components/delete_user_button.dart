import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/google.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/router.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

class DeleteUserButton extends HookConsumerWidget {
  const DeleteUserButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAppleLinked = ref.watch(isAppleLinkedProvider);
    final isGoogleLinked = ref.watch(isGoogleLinkedProvider);
    final didEndInitialSettingNotifier = ref.watch(boolSharedPreferencesProvider(BoolKey.didEndInitialSetting).notifier);
    return Container(
      padding: const EdgeInsets.only(top: 54),
      child: AlertButton(
        onPressed: () async {
          showDiscardDialog(
            context,
            title: "ユーザー情報が削除されます",
            message: "退会をするとすべてデータが削除され、二度と同じアカウントでログインができなくなります。",
            actions: [
              AlertButton(
                text: "キャンセル",
                onPressed: () async {
                  analytics.logEvent(name: "cancel_delete_user");
                  Navigator.of(context).pop();
                },
              ),
              AlertButton(
                text: "退会する",
                onPressed: () async {
                  analytics.logEvent(name: "pressed_delete_user_button");
                  await _delete(
                    context,
                    isAppleLinked: isAppleLinked,
                    isGoogleLinked: isGoogleLinked,
                    didEndInitialSettingNotifier: didEndInitialSettingNotifier,
                  );
                },
              ),
            ],
          );
        },
        text: "退会する",
      ),
    );
  }

  Future<void> _delete(
    BuildContext context, {
    required bool isAppleLinked,
    required bool isGoogleLinked,
    required BoolSharedPreferences didEndInitialSettingNotifier,
  }) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      await didEndInitialSettingNotifier.set(false);
      showDialog(
        context: context,
        builder: (context) => const _CompletedDialog(),
      );
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == "requires-recent-login") {
        showDiscardDialog(
          context,
          title: "再ログインしてください",
          message: "退会前に本人確認のために再ログインをしてください。再ログイン後、自動的に退会処理が始まります",
          actions: [
            AlertButton(
              text: "キャンセル",
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            AlertButton(
              text: "再ログイン",
              onPressed: () async {
                if (isAppleLinked) {
                  await appleReauthentification();
                } else if (isGoogleLinked) {
                  await googleReauthentification();
                } else {
                  errorLogger.log("it is not cooperate account");
                  exit(1);
                }
                Navigator.of(context).pop();
                await _delete(context,
                    isAppleLinked: isAppleLinked, isGoogleLinked: isGoogleLinked, didEndInitialSettingNotifier: didEndInitialSettingNotifier);
              },
            ),
          ],
        );
      } else {
        errorLogger.recordError(error, stackTrace);
        showErrorAlert(context, error);
      }
    } catch (error) {
      showErrorAlert(context, error);
    }
  }
}

class _CompletedDialog extends StatelessWidget {
  const _CompletedDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "退会しました",
            style: TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            "アプリを一度終了します。新しく始める場合はアプリを再起動後、初期設定を行ってください。",
            style: TextStyle(
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
              text: "OK",
            ),
          ),
        ],
      ),
    );
  }
}
