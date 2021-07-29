import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/premium_introduction/components/annual_purchase_button.dart';
import 'package:pilll/domain/premium_introduction/components/monthly_purchase_button.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons_state.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons_store.dart';
import 'package:pilll/domain/premium_introduction/premium_complete_dialog.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseButtons extends HookWidget {
  final Offerings offerings;
  final DateTime? discountEntitlementDeadlineDate;
  final bool hasDiscountEntitlement;

  const PurchaseButtons({
    Key? key,
    required this.offerings,
    required this.discountEntitlementDeadlineDate,
    required this.hasDiscountEntitlement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(purchaseButtonsStoreProvider(_buildState()));
    final state = useProvider(purchaseButtonStateProvider(_buildState()));
    final monthlyPackage = state.monthlyPackage;
    final annualPackage = state.annualPackage;

    return Row(
      children: [
        Spacer(),
        if (monthlyPackage != null)
          MonthlyPurchaseButton(
            monthlyPackage: monthlyPackage,
            onTap: (monthlyPackage) async {
              analytics.logEvent(name: "pressed_monthly_purchase_button");
              await _purchase(context, store, monthlyPackage);
            },
          ),
        SizedBox(width: 16),
        if (annualPackage != null)
          AnnualPurchaseButton(
            annualPackage: annualPackage,
            offeringType: state.offeringType,
            onTap: (annualPackage) async {
              analytics.logEvent(name: "pressed_annual_purchase_button");
              await _purchase(context, store, annualPackage);
            },
          ),
        Spacer(),
      ],
    );
  }

  _purchase(
      BuildContext context, PurchaseButtonsStore store, Package package) async {
    try {
      HUD.of(context).show();
      final shouldShowCompleteDialog = await store.purchase(package);
      if (shouldShowCompleteDialog) {
        showDialog(
            context: context,
            builder: (_) {
              return PremiumCompleteDialog(onClose: () {
                Navigator.of(context).pop();
              });
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
  }

  PurchaseButtonsState _buildState() {
    final discountEntitlementDeadlineDate =
        this.discountEntitlementDeadlineDate;
    return PurchaseButtonsState(
        offerings: offerings,
        hasDiscountEntitlement: hasDiscountEntitlement,
        isOverDiscountDeadline: useProvider(
            isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate)));
  }
}
