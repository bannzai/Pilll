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
    final restDurationNotification = state.restDurationNotification;
    if (restDurationNotification != null) {
      return RestDurationNotificationBar(
          restDurationNotification: restDurationNotification);
    }

    final recommendedSignupNotification = state.recommendedSignupNotification;
    if (recommendedSignupNotification != null) {
      return RecommendSignupNotificationBar(
          store: store,
          recommendedSignupNotification: recommendedSignupNotification);
    }

    final premiumTrialLimit = state.premiumTrialLimit;
    if (premiumTrialLimit != null) {
      return Container(
        constraints: BoxConstraints.expand(
          height: 26,
          width: MediaQuery.of(context).size.width,
        ),
        color: PilllColors.secondary,
        child: Center(
          child: Text(premiumTrialLimit,
              style: FontType.assistingBold.merge(TextColorStyle.white)),
        ),
      );
    }

    return Container();
  }
}

class RecommendSignupNotificationBar extends StatelessWidget {
  const RecommendSignupNotificationBar({
    Key? key,
    required this.store,
    required this.recommendedSignupNotification,
  }) : super(key: key);

  final NotificationBarStateStore store;
  final String recommendedSignupNotification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSigninSheet(context, SigninSheetStateContext.recordPage,
          (linkAccount) {
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
}

class RestDurationNotificationBar extends StatelessWidget {
  const RestDurationNotificationBar({
    Key? key,
    required this.restDurationNotification,
  }) : super(key: key);

  final String restDurationNotification;

  @override
  Widget build(BuildContext context) {
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
}
