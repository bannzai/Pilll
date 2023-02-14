import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/google.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/features/settings/setting_account_list/components/delete_user_button.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/features/sign_in/sign_in_sheet.dart';

class SettingAccountCooperationListPage extends HookConsumerWidget {
  const SettingAccountCooperationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = useState<Object?>(null);
    final isAppleLinked = ref.watch(isAppleLinkedProvider);
    final isGoogleLinked = ref.watch(isGoogleLinkedProvider);
    return UniversalErrorPage(
      error: error.value,
      reload: () => error.value = null,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: PilllColors.background,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('アカウント設定', style: TextStyle(color: TextColor.main)),
              backgroundColor: PilllColors.white,
            ),
            body: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16, left: 15, right: 16),
                  child: const Text(
                    "アカウント登録",
                    style: TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: TextColor.primary,
                    ),
                  ),
                ),
                SettingAccountCooperationRow(
                  accountType: LinkAccountType.apple,
                  isLinked: () => isAppleLinked,
                  onTap: () async {
                    analytics.logEvent(
                      name: 'a_c_l_apple_tapped',
                    );
                    if (isAppleLinked) {
                      return;
                    }
                    _showSignInSheet(context);
                  },
                  onLongPress: () async {
                    analytics.logEvent(
                      name: 'a_c_l_apple_long_press',
                    );

                    showDiscardDialog(
                      context,
                      title: "認証情報を更新します",
                      message: "再度ログインをして認証情報を更新します",
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
                            try {
                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);
                              final isSuccess = await appleReauthentification();
                              analytics.logEvent(name: 'a_c_l_apple_long_press_result', parameters: {"success": isSuccess});

                              messenger.showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content: Text(isSuccess ? "認証情報を更新しました" : "認証情報を更新に失敗しました"),
                                ),
                              );
                              navigator.pop();
                            } catch (error) {
                              showErrorAlert(context, error);
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                const Divider(indent: 16),
                SettingAccountCooperationRow(
                  accountType: LinkAccountType.google,
                  isLinked: () => isGoogleLinked,
                  onTap: () async {
                    analytics.logEvent(
                      name: 'a_c_l_google_tapped',
                    );
                    if (isGoogleLinked) {
                      return;
                    }
                    _showSignInSheet(context);
                  },
                  onLongPress: () async {
                    analytics.logEvent(
                      name: 'a_c_l_google_long_press',
                    );
                    showDiscardDialog(
                      context,
                      title: "認証情報を更新します",
                      message: "再度ログインをして認証情報を更新します",
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
                            try {
                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);
                              final isSuccess = await googleReauthentification();
                              analytics.logEvent(name: 'a_c_l_google_long_press_result', parameters: {"success": isSuccess});

                              messenger.showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content: Text(isSuccess ? "認証情報を更新しました" : "認証情報を更新に失敗しました"),
                                ),
                              );
                              navigator.pop();
                            } catch (error) {
                              showErrorAlert(context, error);
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                const Divider(indent: 16),
                const DeleteUserButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSignInSheet(BuildContext context) {
    showSignInSheet(
      context,
      SignInSheetStateContext.setting,
      (accountType) async {
        const snackBarDuration = Duration(seconds: 1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: snackBarDuration,
            content: Text("${accountType.providerName}で登録しました"),
          ),
        );
        await Future.delayed(snackBarDuration);
      },
    );
  }
}

extension SettingAccountCooperationListPageRoute on SettingAccountCooperationListPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "SettingAccountCooperationListPage"),
      builder: (_) => const SettingAccountCooperationListPage(),
    );
  }
}

class SettingAccountCooperationRow extends StatelessWidget {
  final LinkAccountType accountType;
  final bool Function() isLinked;
  final Future<void> Function() onTap;
  final Future<void> Function() onLongPress;

  const SettingAccountCooperationRow({
    Key? key,
    required this.accountType,
    required this.isLinked,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(accountType.loginContentName,
          style: const TextStyle(
            fontFamily: FontFamily.roboto,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          )),
      trailing: _trailing(),
      horizontalTitleGap: 4,
      onTap: () async {
        if (isLinked()) {
          return;
        }
        await onTap();
      },
      onLongPress: () async {
        await onLongPress();
      },
    );
  }

  Widget _trailing() {
    if (isLinked()) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("images/checkmark_green.svg"),
          const SizedBox(width: 6),
          const Text("連携済み",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.darkGray,
              )),
        ],
      );
    } else {
      return SizedBox(
        height: 40,
        width: 88,
        child: SmallAppOutlinedButton(
          onPressed: () async {
            onTap();
          },
          text: "連携する",
        ),
      );
    }
  }
}
