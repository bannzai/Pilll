import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_footer.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_header.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_limited.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/util/platform/platform.dart';

class PremiumIntroductionPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(premiumIntroductionStoreProvider);
    final state = useProvider(premiumIntroductionStoreProvider.state);
    final offerings = state.offerings;
    final trialDeadlineDate = state.trialDeadlineDate;
    if (state.isNotYetLoad) {
      return Indicator();
    }

    return HUD(
      shown: state.isLoading,
      child: UniversalErrorPage(
        error: state.exception,
        reload: () => store.reset(),
        child: Scaffold(
          body: Container(
            color: PilllColors.white,
            child: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: AssetImage("images/premium_background.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: EdgeInsets.only(left: 40, right: 40, bottom: 40),
                      width: MediaQuery.of(context).size.width,
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 100),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PremiumIntroductionHeader(shouldShowDismiss: true),
                          if (trialDeadlineDate != null)
                            PremiumIntroductionLimited(
                              trialDeadlineDate: trialDeadlineDate,
                            ),
                          if (offerings != null &&
                              trialDeadlineDate != null) ...[
                            SizedBox(height: 32),
                            PurchaseButtons(
                              offerings: offerings,
                              trialDeadlineDate: trialDeadlineDate,
                            ),
                          ],
                          SizedBox(height: 24),
                          Text(
                            "$storeNameからいつでも簡単に解約出来ます",
                            textAlign: TextAlign.center,
                            style: TextColorStyle.black.merge(
                              TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: FontFamily.japanese,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          SecondaryButton(
                              onPressed: () {
                                print("");
                              },
                              text: "プレミアム機能を見る"),
                          SizedBox(height: 24),
                          PremiumIntroductionFotter(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension PremiumIntroductionPageRoutes on PremiumIntroductionPage {
  static Route<dynamic> route() {
    return CupertinoPageRoute(
      fullscreenDialog: true,
      settings: RouteSettings(name: "PremiumIntroductionPage"),
      builder: (_) => PremiumIntroductionPage(),
    );
  }
}
