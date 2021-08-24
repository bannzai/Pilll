import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/exception.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/router/router.dart';

class DeleteUserButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 54),
      child: SecondaryButton(
        onPressed: () {
          showDiscardDialog(
            context,
            title: "ユーザー情報が削除されます",
            message: "退会をするとすべてデータが削除され、二度と同じアカウントでログインができなくなります。",
            doneText: "退会する",
            done: () async {
              await _delete(context);
            },
          );
        },
        text: "退会する",
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } on FirebaseAuthException catch (error, stackTrace) {
      if (error.code == "requires-recent-login") {
        Navigator.of(context).pop();
        showDiscardDialog(
          context,
          title: "再ログインしてください",
          message: "退会前に本人確認のために再ログインをしてください。再ログイン後、自動的に退会処理が始まります",
          done: () async {
            if (isLinkedApple()) {
              await appleReauthentification();
            } else if (isLinkedGoogle()) {
              await googleReauthentification();
            } else {
              errorLogger.log("it is not cooperate account");
              exit(1);
            }
            await _delete(context);
          },
          doneText: "再ログイン",
        );
      } else {
        errorLogger.recordError(error, stackTrace);
        Navigator.of(context).pop();
        showErrorAlert(context, message: error.toString());
      }
    } catch (error) {
      Navigator.of(context).pop();
      showErrorAlert(context, message: error.toString());
    }
    showDialog(
      context: context,
      builder: (context) {
        return _CompletedDialog(
          onClose: () async {
            await AppRouter.routeToInitialSetting(context);
          },
        );
      },
    );
  }
}

class _CompletedDialog extends StatelessWidget {
  final VoidCallback onClose;

  const _CompletedDialog({Key? key, required this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(24, 48, 24, 24),
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "退会しました",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              "初期設定画面に移動します。新しいアカウントとして引き続きご利用になる場合は再度設定をお願いいたします",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            PrimaryButton(
              onPressed: () {
                Navigator.of(context).pop();
                onClose();
              },
              text: "OK",
            ),
          ],
        ),
      ),
    );
  }
}
