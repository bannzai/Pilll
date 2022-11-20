import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/settings/setting_account_list/setting_account_cooperation_list_page.dart';

class AccountLinkRow extends HookConsumerWidget {
  const AccountLinkRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAppleLinked = ref.watch(isAppleLinkedProvider);
    final isGoogleLinked = ref.watch(isGoogleLinkedProvider);
    return ListTile(
      title: const Text("アカウント設定",
          style: TextStyle(
            fontFamily: FontFamily.roboto,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          )),
      trailing: _subtitle(isAppleLinked || isGoogleLinked),
      onTap: () {
        analytics.logEvent(name: "did_select_setting_account_cooperation");
        Navigator.of(context).push(SettingAccountCooperationListPageRoute.route());
      },
    );
  }

  Widget _subtitle(bool isLinked) {
    if (isLinked) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("images/checkmark_green.svg"),
          const SizedBox(width: 6),
          Text("連携済み",
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ).merge(TextColorStyle.darkGray)),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("images/alert_24.svg"),
          const SizedBox(width: 6),
          Text("未登録",
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ).merge(TextColorStyle.darkGray)),
        ],
      );
    }
  }
}
