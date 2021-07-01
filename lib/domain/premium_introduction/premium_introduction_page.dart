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
import 'package:pilll/domain/premium_introduction/premium_introduction_body.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/util/datetime/timer.dart';
import 'package:pilll/util/platform/platform.dart';

class PremiumIntroductionPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(premiumIntroductionStoreProvider);
    final state = useProvider(premiumIntroductionStoreProvider.state);
    final offerings = state.offerings;
    final trialDeadlineDate = state.trialDeadlineDate;
    final bool isBlessMode;
    if (trialDeadlineDate != null) {
      final isOverTiralDeadline =
          useProvider(isOverTrialDeadlineProvider(trialDeadlineDate));
      isBlessMode = !isOverTiralDeadline;
    } else {
      isBlessMode = false;
    }
    if (state.isNotYetLoad) {
      return Indicator();
    }

    return HUD(
      shown: state.isLoading,
      child: UniversalErrorPage(
        error: null,
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
                        image: isBlessMode
                            ? DecorationImage(
                                image:
                                    AssetImage("images/premium_background.png"),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      padding: EdgeInsets.only(left: 40, right: 40, bottom: 40),
                      width: MediaQuery.of(context).size.width,
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 100),
                      child: PremiumIntroductionBody(
                        isBlessMode: isBlessMode,
                        offerings: offerings,
                        trialDeadlineDate: trialDeadlineDate,
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
