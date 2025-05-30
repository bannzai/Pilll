import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/google.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/settings/setting_account_link/page.dart';

class AccountLinkRow extends HookConsumerWidget {
  const AccountLinkRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAppleLinked = ref.watch(isAppleLinkedProvider);
    final isGoogleLinked = ref.watch(isGoogleLinkedProvider);
    return ListTile(
      title: Text(
        L.accountSettings,
        style: const TextStyle(
          fontFamily: FontFamily.roboto,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      trailing: _subtitle(isAppleLinked || isGoogleLinked),
      onTap: () {
        analytics.logEvent(name: 'did_select_setting_account_cooperation');
        Navigator.of(context).push(SettingAccountCooperationListPageRoute.route());
      },
    );
  }

  Widget _subtitle(bool isLinked) {
    if (isLinked) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('images/checkmark_green.svg'),
          const SizedBox(width: 6),
          Text(L.linked,
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.darkGray,
              )),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('images/alert_24.svg'),
          const SizedBox(width: 6),
          Text(
            L.unregistered,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: TextColor.darkGray,
            ),
          ),
        ],
      );
    }
  }
}
