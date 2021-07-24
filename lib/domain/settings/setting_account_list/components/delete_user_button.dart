import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/error/error_alert.dart';
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
              try {
                await FirebaseAuth.instance.currentUser?.delete();
                await AppRouter.routeToInitialSetting(context);
              } catch (error) {
                showErrorAlert(context, message: error.toString());
              }
            },
          );
        },
        text: "退会する",
      ),
    );
  }
}
