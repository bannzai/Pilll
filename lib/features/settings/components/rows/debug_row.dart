import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/settings/components/inquiry/inquiry.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugRow extends StatelessWidget {
  const DebugRow({super.key});

  @override
  Widget build(BuildContext context) {
    if (Environment.isProduction) {
      return Container();
    }
    // identifier: 翻訳の画面比較の撮影フロー (.maestro/flows/translation_screenshot/capture.yaml) が
    // 表示言語を切り替えた後にユーザー削除 (長押し) で初期設定へ戻るため
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 20),
      child: Semantics(
        identifier: 'debug_row',
        child: GestureDetector(
          child: Center(
            child: Text(
              L.copyDebugInfo,
              style: const TextStyle(color: TextColor.primary),
            ),
          ),
          onTap: () async {
            Clipboard.setData(ClipboardData(text: await debugInfo('\n')));
          },
          onDoubleTap: () {
            final signOut = Environment.signOutUser;
            if (signOut == null) {
              return;
            }
            showDiscardDialog(
              context,
              title: 'サインアウトします',
              message: '''
これは開発用のオプションです。サインアウトあとはアプリを再起動してお試しください。初期設定から始まります
''',
              actions: [
                AlertButton(
                  text: L.cancel,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                AlertButton(
                  text: L.signOut,
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await signOut();
                    navigator.pop();
                  },
                ),
              ],
            );
          },
          onLongPress: () {
            final deleteUser = Environment.deleteUser;
            if (deleteUser == null) {
              return;
            }
            showDiscardDialog(
              context,
              title: L.deleteUser,
              message: '''
これは開発用のオプションです。ユーザーを削除したあとはアプリを再起動してからやり直してください。初期設定から始まります
''',
              actions: [
                AlertButton(
                  text: L.cancel,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                Semantics(
                  identifier: 'debug_delete_user_button',
                  child: AlertButton(
                    text: L.delete,
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await deleteUser();
                      navigator.pop();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
