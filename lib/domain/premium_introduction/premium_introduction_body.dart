import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_footer.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_header.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_limited.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons.dart';
import 'package:pilll/util/platform/platform.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumIntroductionBody extends StatelessWidget {
  const PremiumIntroductionBody({
    Key? key,
    required this.isBlessMode,
    required this.shownDismissButton,
    required this.trialDeadlineDate,
    required this.offerings,
    required this.scrollController,
  }) : super(key: key);

  final bool isBlessMode;
  final bool shownDismissButton;
  final DateTime? trialDeadlineDate;
  final Offerings? offerings;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final offerings = this.offerings;
    final trialDeadlineDate = this.trialDeadlineDate;
    return Container(
      width: MediaQuery.of(context).size.width,
      color: PilllColors.white,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: isBlessMode
                  ? DecorationImage(
                      image: AssetImage("images/premium_background.png"),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 40),
            width: MediaQuery.of(context).size.width,
          ),
          SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PremiumIntroductionHeader(
                    shouldShowDismiss: shownDismissButton),
                if (trialDeadlineDate != null)
                  PremiumIntroductionLimited(
                    trialDeadlineDate: trialDeadlineDate,
                  ),
                if (offerings != null) ...[
                  SizedBox(height: 32),
                  PurchaseButtons(
                    offerings: offerings,
                    trialDeadlineDate: trialDeadlineDate,
                  ),
                ],
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
    );
  }
}
