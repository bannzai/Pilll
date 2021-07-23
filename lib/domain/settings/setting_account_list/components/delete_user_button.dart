import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/page/discard_dialog.dart';

class DeleteUserButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 54),
      child: SecondaryButton(
        onPressed: () {
          showDiscardDialog(
            context,
            title: "ユーザーが削除されます",
            message:
                "退会をするとユーザーが削除されます。ユーザーが削除されたあとはすべてのデータが消え、二度と同じアカウントでログインができなくなります。",
            doneText: "退会する",
            done: () async {
              try {
                await FirebaseAuth.instance.currentUser?.delete();
                showDialog(
                    context: context,
                    builder: (_) {
                      return _CompletedDialog(onClose: () {
                        Navigator.of(context).pop();
                      });
                    });
              } catch (error) {}
            },
          );
        },
        text: "退会する",
      ),
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
              "Pilllプレミアム登録完了",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            SvgPicture.asset("images/jewel.svg"),
            SizedBox(height: 24),
            Text(
              "ご登録ありがとうございます。\nすべての機能が使えるようになりました！",
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
