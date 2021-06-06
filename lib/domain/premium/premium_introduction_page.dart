import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/premium/premium_introduction_state.dart';
import 'package:pilll/domain/premium/premium_introduction_store.dart';
import 'package:pilll/domain/root/root.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:url_launcher/url_launcher.dart';

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
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    _plan(context, store, state),
                    _noOpen(context, store, state),
                    _advancedAppearancePillSheet(context, store, state),
                    _footer(context, store, state),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  color: PilllColors.white,
                  child: Center(
                    child: PrimaryButton(
                      text: state.doneButtonText,
                      onPressed: () async {
                        try {
                          store.purchase();
                        } catch (error) {
                          if (error is UserDisplayedError) {
                            showErrorAlertWithError(context, error);
                          } else {
                            rootKey.currentState?.onError(error);
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
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
                    store.selectedAnnual();
                  },
                  child: Container(
                    height: 68,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 13),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                            decoration: BoxDecoration(
                              color: state.isSelectedAnnual
                                  ? Colors.transparent
                                  : PilllColors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                width: state.isSelectedAnnual ? 2 : 0.5,
                                color: PilllColors.secondary,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 24),
                                Text(
                                  "年間プラン",
                                  style: TextColorStyle.main.merge(
                                    TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      fontFamily: FontFamily.japanese,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  store.annualPriceString(annualPackage),
                                  style: TextColorStyle.main.merge(
                                    TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: FontFamily.number,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: PilllColors.primary,
                            ),
                            child: Text(
                              "通常月額と比べて48％OFF",
                              style: TextColorStyle.white.merge(
                                TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    fontFamily: FontFamily.japanese),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 16),
              if (monthlyPackage != null)
                GestureDetector(
                  onTap: () {
                    store.selectedMonthly();
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: state.isSelectedMonthly
                          ? Colors.transparent
                          : PilllColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                        width: state.isSelectedMonthly ? 2 : 0.5,
                        color: PilllColors.secondary,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 24),
                        Text(
                          "月額プラン",
                          style: TextColorStyle.main.merge(
                            TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontFamily: FontFamily.japanese,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          store.monthlyPriceString(monthlyPackage),
                          style: TextColorStyle.main.merge(
                            TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: FontFamily.number,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 17),
              Text(
                "${store.storeName}からいつでも簡単に解約出来ます",
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
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 24),
      color: PilllColors.white,
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

  Widget _advancedAppearancePillSheet(
    BuildContext context,
    PremiumIntroductionStore store,
    PremiumIntroductionState state,
  ) {
    return Container(
      padding: EdgeInsets.only(top: 24, bottom: 24),
      width: MediaQuery.of(context).size.width,
      color: PilllColors.secondary,
      child: Column(
        children: [
          Text(
            "ピルシートを日付表示に",
            textAlign: TextAlign.center,
            style: TextColorStyle.white.merge(
              TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 48),
          Image.asset("images/premium_introduce_appearance_pill_sheet.png"),
        ],
      ),
    );
  }

  Widget _footer(
    BuildContext context,
    PremiumIntroductionStore store,
    PremiumIntroductionState state,
  ) {
    return Container(
      padding: EdgeInsets.only(top: 24, bottom: 24),
      width: MediaQuery.of(context).size.width,
      color: PilllColors.white,
      child: Column(
        children: [
          Text(
            '''
今後も便利な機能を続々追加予定です！
お楽しみに✨
            ''',
            textAlign: TextAlign.center,
            style: TextColorStyle.black.merge(
              TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.japanese,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: TextColorStyle.gray.merge(
                  TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      fontFamily: FontFamily.japanese),
                ),
                children: [
                  TextSpan(text: "・プレミアム契約期間は開始日から起算して1ヶ月または1年ごとの自動更新となります\n"),
                  TextSpan(text: "・"),
                  TextSpan(
                    text: "プライバシーポリシー",
                    style: TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://bannzai.github.io/Pilll/PrivacyPolicy",
                            forceSafariVC: true);
                      },
                  ),
                  TextSpan(
                    text: " / ",
                  ),
                  TextSpan(
                    text: "利用規約",
                    style: TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://bannzai.github.io/Pilll/Terms",
                            forceSafariVC: true);
                      },
                  ),
                  TextSpan(
                    text: "をご確認のうえ登録してください\n",
                  ),
                  TextSpan(
                    text: "・プレミアム契約期間の終了日の24時間以上前に解約しない限り契約期間が自動更新されます\n",
                  ),
                  TextSpan(
                    text:
                        "・購入後、自動更新の解約は${store.storeName}アプリのアカウント設定で行えます。(アプリ内から自動更新の解約は行なえません)",
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          GestureDetector(
            onTap: () async {
              try {
                await store.restore();
              } catch (error) {
                if (error is UserDisplayedError) {
                  showErrorAlertWithError(context, error);
                } else {
                  rootKey.currentState?.onError(error);
                }
              }
            },
            child: Text(
              '以前購入した方はこちら',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ).merge(TextColorStyle.main).merge(
                    TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: FontFamily.japanese,
                    ),
                  ),
            ),
          ),
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
