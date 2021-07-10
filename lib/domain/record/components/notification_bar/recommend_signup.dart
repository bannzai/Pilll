import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/demography/demography_page.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/signin/signin_sheet.dart';
import 'package:pilll/signin/signin_sheet_state.dart';

class RecommendSignupNotificationBar extends HookWidget {
  const RecommendSignupNotificationBar({
    Key? key,
    required this.parameter,
  }) : super(key: key);

  final RecordPageState parameter;

  @override
  Widget build(BuildContext context) {
    final store = useProvider(notificationBarStoreProvider(parameter));
    return GestureDetector(
      onTap: () {
        analytics.logEvent(name: "tapped_signup_notification_bar");
        showSigninSheet(context, SigninSheetStateContext.recordPage,
            (linkAccount) {
          analytics.logEvent(name: "signined_account_from_notification_bar");
          showDemographyPageIfNeeded(context);
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            alignment: Alignment.topLeft,
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              analytics.logEvent(
                  name: "record_page_signing_notification_closed");
              store.closeRecommendedSignupNotification();
            },
            iconSize: 24,
            padding: EdgeInsets.zero,
          ),
          Spacer(),
          Column(
            children: [
              Text(
                "機種変更やスマホ紛失時に備えて\nアカウント登録しませんか？",
                style: TextColorStyle.white.merge(FontType.descriptionBold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "images/arrow_right.svg",
                  color: Colors.white,
                ),
                onPressed: () {},
                iconSize: 24,
                padding: EdgeInsets.all(8),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
