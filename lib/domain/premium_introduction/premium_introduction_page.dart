import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/demography/demography_page.dart';
import 'package:pilll/domain/premium_introduction/components/annaul_purchase_button.dart';
import 'package:pilll/domain/premium_introduction/components/monthly_purchase_button.dart';
import 'package:pilll/domain/premium_introduction/premium_complete_dialog.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_limited_header.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_state.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/signin/signin_sheet.dart';
import 'package:pilll/signin/signin_sheet_state.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumIntroductionPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(premiumIntroductionStoreProvider);
    final state = useProvider(premiumIntroductionStoreProvider.state);
    if (state.isNotYetLoad) {
      return Indicator();
    }
    final annualPackage = state.annualPackage;
    final monthlyPackage = state.monthlyPackage;
    return HUD(
      shown: state.isLoading,
      child: UniversalErrorPage(
        error: state.exception,
        reload: () => store.reset(),
        child: Scaffold(
          appBar: AppBar(
            title: SvgPicture.asset("images/pillll_premium_logo.svg"),
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: PilllColors.blueBackground,
          ),
          body: Container(
            color: PilllColors.blueBackground,
            child: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 100),
                      child: Column(
                        children: [
                          PremiumIntroductionLimitedHeader(),
                          Row(
                            children: [
                              Spacer(),
                              if (monthlyPackage != null)
                                MonthlyPurchaseButton(
                                  monthlyPackage: monthlyPackage,
                                  onTap: (monthlyPackage) async {
                                    try {
                                      store.showHUD();
                                      final shouldShowCompleteDialog =
                                          await store.purchase(monthlyPackage);
                                      if (shouldShowCompleteDialog) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return PremiumCompleteDialog();
                                            });
                                      }
                                    } catch (error) {
                                      print("caused purchase error for $error");
                                      if (error is UserDisplayedError) {
                                        showErrorAlertWithError(context, error);
                                      } else {
                                        store.handleException(error);
                                      }
                                    } finally {
                                      store.hideHUD();
                                    }
                                  },
                                ),
                              SizedBox(width: 16),
                              if (annualPackage != null)
                                AnnualPurchaseButton(
                                  annualPackage: annualPackage,
                                  onTap: (annualPackage) async {
                                    try {
                                      store.showHUD();
                                      final shouldShowCompleteDialog =
                                          await store.purchase(annualPackage);
                                      if (shouldShowCompleteDialog) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return PremiumCompleteDialog();
                                            });
                                      }
                                    } catch (error) {
                                      print("caused purchase error for $error");
                                      if (error is UserDisplayedError) {
                                        showErrorAlertWithError(context, error);
                                      } else {
                                        store.handleException(error);
                                      }
                                    } finally {
                                      store.hideHUD();
                                    }
                                  },
                                ),
                              Spacer(),
                            ],
                          ),
                          _footer(context, store, state),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: PilllColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: PilllColors.shadow,
                              blurRadius: 6.0,
                              offset: Offset(0, -4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: PrimaryButton(
                            text: state.doneButtonText,
                            onPressed: state.isPremium
                                ? null
                                : () async {
                                    if (state.hasLoginProvider) {
                                      try {
                                        store.showHUD();
                                        final shouldShowCompleteDialog =
                                            await store.purchase(
                                                state.selectedPackage!);
                                        if (shouldShowCompleteDialog) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return PremiumCompleteDialog();
                                              });
                                        }
                                      } catch (error) {
                                        print(
                                            "caused purchase error for $error");
                                        if (error is UserDisplayedError) {
                                          showErrorAlertWithError(
                                              context, error);
                                        } else {
                                          store.handleException(error);
                                        }
                                      } finally {
                                        store.hideHUD();
                                      }
                                    } else {
                                      showSigninSheet(context,
                                          SigninSheetStateContext.premium,
                                          (linkAccountType) {
                                        analytics.logEvent(
                                            name:
                                                "signined_account_on_premium");
                                        showDemographyPageIfNeeded(context);
                                      });
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
          ),
        ),
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
                store.showHUD();
                final shouldShowSnackbar = await store.restore();
                if (shouldShowSnackbar) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(
                        seconds: 2,
                      ),
                      content: Text("購入情報を復元しました"),
                    ),
                  );
                }
              } catch (error) {
                if (error is UserDisplayedError) {
                  showErrorAlertWithError(context, error);
                } else {
                  store.handleException(error);
                }
              } finally {
                store.hideHUD();
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
    return CupertinoPageRoute(
      fullscreenDialog: true,
      settings: RouteSettings(name: "PremiumIntroductionPage"),
      builder: (_) => PremiumIntroductionPage(),
    );
  }
}
