import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/premium_introduction/components/annual_purchase_button.dart';
import 'package:pilll/domain/premium_introduction/components/monthly_purchase_button.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons_store.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons_store_parameter.dart';
import 'package:pilll/domain/premium_introduction/premium_complete_dialog.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseButtons extends StatelessWidget {
  final Offerings offerings;
  final DateTime? trialDeadlineDate;

  const PurchaseButtons({
    Key? key,
    required this.offerings,
    required this.trialDeadlineDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store =
        useProvider(purchaseButtonsStoreProvider(PurchaseButtonsStoreParameter(
      offerings: offerings,
      trialDeadlineDate: trialDeadlineDate,
    )));
    final state =
        useProvider(purchaseButtonsStoreProvider(PurchaseButtonsStoreParameter(
      offerings: offerings,
      trialDeadlineDate: trialDeadlineDate,
    )).state);
    final monthlyPackage = state.monthlyPackage;
    final annualPackage = state.annualPackage;

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
        Spacer(),
      ],
    );
  }
}
