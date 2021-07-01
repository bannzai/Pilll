import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/premium_introduction/components/annual_purchase_button.dart';
import 'package:pilll/domain/premium_introduction/components/monthly_purchase_button.dart';
import 'package:pilll/domain/premium_introduction/components/puchase_buttons_store.dart';
import 'package:pilll/domain/premium_introduction/premium_complete_dialog.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseButtons extends StatelessWidget {
  final Offerings offerings;

  const PurchaseButtons({
    Key? key,
    required this.offerings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = PurchaseButtonsStore(offerings);
    final monthlyPackage = store.monthlyPackage;
    final annualPackage = store.annualPackage;

    return Row(
      children: [
        Spacer(),
        if (monthlyPackage != null)
          MonthlyPurchaseButton(
            monthlyPackage: monthlyPackage,
            onTap: (monthlyPackage) async {
              try {
                HUD.of(context).show();
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
                  UniversalErrorPage.of(context).showError(error);
                }
              } finally {
                HUD.of(context).hide();
              }
            },
          ),
        SizedBox(width: 16),
        if (annualPackage != null)
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnnualPurchaseButton(
                annualPackage: annualPackage,
                onTap: (annualPackage) async {
                  try {
                    HUD.of(context).show();
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
                      UniversalErrorPage.of(context).showError(error);
                    }
                  } finally {
                    HUD.of(context).hide();
                  }
                },
              ),
              Positioned(
                top: -11,
                left: 8,
                child: _DiscountBadge(),
              ),
            ],
          ),
        Spacer(),
      ],
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
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
    );
  }
}
