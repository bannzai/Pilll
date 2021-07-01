import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_body.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/util/datetime/timer.dart';

class PremiumIntroductionSheet extends HookWidget {
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

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return HUD(
          shown: state.isLoading,
          child: UniversalErrorPage(
            error: null,
            reload: () => store.reset(),
            child: PremiumIntroductionBody(
              isBlessMode: isBlessMode,
              shownDismissButton: false,
              trialDeadlineDate: trialDeadlineDate,
              offerings: offerings,
              scrollController: scrollController,
            ),
          ),
        );
      },
    );
  }
}

showPremiumIntroductionSheet(BuildContext context) {
  analytics.setCurrentScreen(screenName: "PremiumIntroductionSheet");
  showModalBottomSheet(
    context: context,
    builder: (_) => PremiumIntroductionSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
