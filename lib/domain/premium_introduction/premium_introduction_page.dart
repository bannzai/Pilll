import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_body.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/util/datetime/timer.dart';

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
          body: SafeArea(
            child: PremiumIntroductionBody(
              isBlessMode: isBlessMode,
              trialDeadlineDate: trialDeadlineDate,
              offerings: offerings,
              scrollController: null,
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
