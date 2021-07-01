import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/demography/demography_page.dart';
import 'package:pilll/domain/record/components/notification_bar_store.dart';
import 'package:pilll/domain/record/components/notification_bar_store_parameter.dart';
import 'package:pilll/signin/signin_sheet.dart';
import 'package:pilll/signin/signin_sheet_state.dart';

class NotificationBar extends HookWidget {
  final NotificationBarStoreParameter parameter;

  NotificationBar(this.parameter);
  @override
  Widget build(BuildContext context) {
    final store = useProvider(notificationBarStoreProvider(parameter));
    final state = useProvider(notificationBarStoreProvider(parameter).state);
    final recommendedSignupNotification = state.recommendedSignupNotification;
    if (recommendedSignupNotification.isNotEmpty) {
      return GestureDetector(
        onTap: () => showSigninSheet(
            context, SigninSheetStateContext.recordPage, (linkAccount) {
          analytics.logEvent(name: "signined_account_from_notification_bar");
          showDemographyPageIfNeeded(context);
        }),
        child: Container(
          height: 64,
          color: PilllColors.secondary,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    analytics.logEvent(
                        name: "record_page_signing_notification_closed");
                    store.closeRecommendedSignupNotification();
                  }),
              Column(
                children: [
                  SizedBox(height: 12),
                  Text(
                    recommendedSignupNotification,
                    style: TextColorStyle.white.merge(FontType.descriptionBold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 8),
                  IconButton(
                    icon: SvgPicture.asset(
                      "images/arrow_right.svg",
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final restDurationNotification = state.restDurationNotification;
    if (restDurationNotification.isNotEmpty) {
      return Container(
        constraints: BoxConstraints.expand(
          height: 26,
          width: MediaQuery.of(context).size.width,
        ),
        color: PilllColors.secondary,
        child: Center(
          child: Text(restDurationNotification,
              style: FontType.assistingBold.merge(TextColorStyle.white)),
        ),
      );
    }

    return Container();
  }
}
