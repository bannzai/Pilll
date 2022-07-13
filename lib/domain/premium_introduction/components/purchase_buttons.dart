import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/premium_introduction/components/annual_purchase_button.dart';
import 'package:pilll/domain/premium_introduction/components/monthly_purchase_button.dart';
import 'package:pilll/domain/premium_introduction/premium_complete_dialog.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_state.codegen.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/error/alert_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseButtons extends HookConsumerWidget {
  final PremiumIntroductionStore store;
  final OfferingType offeringType;
  final Package monthlyPackage;
  final Package annualPackage;

  const PurchaseButtons({
    Key? key,
    required this.store,
    required this.offeringType,
    required this.monthlyPackage,
    required this.annualPackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const Spacer(),
        MonthlyPurchaseButton(
          monthlyPackage: monthlyPackage,
          onTap: (monthlyPackage) async {
            analytics.logEvent(name: "pressed_monthly_purchase_button");
            await _purchase(context, monthlyPackage);
          },
        ),
        const SizedBox(width: 16),
        AnnualPurchaseButton(
          annualPackage: annualPackage,
          offeringType: offeringType,
          onTap: (annualPackage) async {
            analytics.logEvent(name: "pressed_annual_purchase_button");
            await _purchase(context, annualPackage);
          },
        ),
        const Spacer(),
      ],
    );
  }

  _purchase(BuildContext context, Package package) async {
    try {
      // NOTE: Revenuecatからの更新により非同期にUIが変わる。その場合PurchaseButtons自体が隠れてしまい、
      // ShowDialog が 表示されない場合がある。諸々の処理が完了するまでstreamを一回破棄しておく
      store.stopStream();
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
      debugPrint("caused purchase error for $error");
      if (error is AlertError) {
        showErrorAlertWithError(context, error);
      } else {
        UniversalErrorPage.of(context).showError(error);
      }
    } finally {
      HUD.of(context).hide();
      // NOTE: Revenuecatからの更新により非同期にUIが変わる。その場合PurchaseButtons自体が隠れてしまい、
      // ShowDialog が 表示されない場合がある。諸々の処理が完了するまでstreamを一回破棄しておく
      store.startStream();
    }
  }
}
