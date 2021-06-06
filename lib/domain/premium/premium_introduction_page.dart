import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/premium/premium_introduction_state.dart';
import 'package:pilll/domain/premium/premium_introduction_store.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error_log.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumIntroductionPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(premiumIntroductionStoreProvider);
    final state = useProvider(premiumIntroductionStoreProvider.state);
    if (state.isNotYetLoad) {
      return Indicator();
    }
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset("images/pillll_premium_logo.svg"),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: PilllColors.secondary.withAlpha(10),
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _plan(context, store, state),
                _noOpen(context, store, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _plan(BuildContext context, PremiumIntroductionStore store,
      PremiumIntroductionState state) {
    final annualPackage = state.annualPackage;
    final monthlyPackage = state.monthlyPackage;
    return Container(
      decoration: BoxDecoration(
        color: PilllColors.secondary.withAlpha(10),
        image: DecorationImage(
          image: AssetImage("images/premium_background.png"),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.only(left: 40, right: 40, bottom: 40),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "今、年間プランに登録すれば\n¥250/月で使える",
            textAlign: TextAlign.center,
            style: TextColorStyle.main.merge(
              TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "通常 月額プラン",
            textAlign: TextAlign.center,
            style: TextColorStyle.black.merge(
              TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                fontFamily: FontFamily.japanese,
              ),
            ),
          ),
          SizedBox(height: 4),
          Stack(
            children: [
              Text(
                "¥480",
                textAlign: TextAlign.center,
                style: TextColorStyle.main.merge(
                  TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    fontFamily: FontFamily.japanese,
                  ),
                ),
              ),
              Positioned(
                left: 30,
                child: SvgPicture.asset("images/strikethrough.svg"),
              ),
            ],
          ),
          SizedBox(height: 8),
          SvgPicture.asset("images/arrow_down.svg"),
          SizedBox(height: 28),
          Column(
            children: [
              if (annualPackage != null)
                GestureDetector(
                  onTap: () {
                    store.purchase(annualPackage);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: state.isSelectedAnnual
                          ? Colors.transparent
                          : PilllColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                        width: state.isSelectedAnnual ? 2 : 0.5,
                        color: PilllColors.secondary,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          store.annualPlanName(),
                          style: TextColorStyle.main.merge(
                            TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                fontFamily: FontFamily.japanese),
                          ),
                        ),
                        Text(
                          store.annualPriceString(annualPackage),
                          style: TextColorStyle.main.merge(
                            TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                fontFamily: FontFamily.japanese),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 16),
              if (monthlyPackage != null)
                GestureDetector(
                  onTap: () {
                    store.purchase(monthlyPackage);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: state.isSelectedAnnual
                          ? Colors.transparent
                          : PilllColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                        width: state.isSelectedAnnual ? 2 : 0.5,
                        color: PilllColors.secondary,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          store.monthlyPlanName(),
                          style: TextColorStyle.main.merge(
                            TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontFamily: FontFamily.japanese,
                            ),
                          ),
                        ),
                        SizedBox(height: 17),
                        Text(
                          store.monthlyPriceString(monthlyPackage),
                          style: TextColorStyle.main.merge(
                            TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontFamily: FontFamily.japanese,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 17),
              Text(
                "App Storeからいつでも簡単に解約出来ます",
                textAlign: TextAlign.center,
                style: TextColorStyle.gray.merge(
                  TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 24),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "プレミアム機能が増えたタイミングで\n通常の金額での提供になります。\nそのため、",
                      style: TextColorStyle.main.merge(
                        TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: "この価格は今だけ！！",
                      style: TextColorStyle.main.merge(
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _noOpen(BuildContext context, PremiumIntroductionStore store,
      PremiumIntroductionState state) {
    return Container(
      padding: EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Text(
            '''
アプリを開かなくても
今日飲むピルが分かる、記録できる
          ''',
            textAlign: TextAlign.center,
            style: TextColorStyle.main.merge(
              TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 48),
          Image.asset("images/premium_introduce_no_open.png"),
        ],
      ),
    );
  }
}

extension PremiumIntroductionPageRoutes on PremiumIntroductionPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "PremiumIntroductionPage"),
      builder: (_) => PremiumIntroductionPage(),
    );
  }
}
