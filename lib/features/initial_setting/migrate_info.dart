import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

class MigrateInfo extends HookConsumerWidget {
  const MigrateInfo({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedPreferences = ref.watch(boolSharedPreferencesProvider(BoolKey.migrateFrom132IsShown).notifier);

    return Scaffold(
      backgroundColor: PilllColors.background,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "お知らせとお詫び",
                  style: TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: TextColor.main,
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "今回のアップデートにより大型リニューアル前のアプリでピルシートを服用していたときのデータを参照できるようにしました。",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: TextColor.main,
                        ),
                      ),
                      TextSpan(
                        text: "設定 > 大型アップデート前の情報 ",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: TextColor.main,
                        ),
                      ),
                      TextSpan(
                        text: "から表示されます。",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: TextColor.main,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "先日の大型アップデート後に一部のユーザーの方から「アップデート前のデータが分からなくなり、今飲んでいるピル番号が把握できなくなった」と。お問い合わせをいただきました。アプリの作り直しの過程で自動でピル番号を自動的に移行することが困難になり、このような事態になってしまいました。",
                  style: TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: TextColor.main,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "同じようにお困りの方はこちらの表示を参考にしてピルシートの番号を調整していただくようお願いします。ピル番号の調整はピルシートを作っていただいてから",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: TextColor.main,
                        ),
                      ),
                      TextSpan(
                        text: "設定 > 今日飲むピル番号の変更",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: TextColor.main,
                        ),
                      ),
                      TextSpan(
                        text: "へおすすみください。今日服用するピルの番号を調整できます。",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: TextColor.main,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "なお現在服用している番号がすでに把握できている方は引き続きそのままアプリを使っていただいて構いません。",
                  style: TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: TextColor.main,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "今回は以前からアプリを使っていただいているユーザーの方にご迷惑をおかけする形になり申し訳ありません。",
                  style: TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: TextColor.main,
                  ),
                ),
                const Text(
                  "引き続きよろしくお願いいたします。",
                  style: TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: TextColor.main,
                  ),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 230,
                      child: PrimaryButton(
                          onPressed: () async {
                            sharedPreferences.set(true);
                            ref.invalidate(sharedPreferencesProvider);
                            Navigator.of(context).pop();
                          },
                          text: "閉じる")),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
