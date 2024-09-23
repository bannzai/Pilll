import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/premium_introduction/components/annual_purchase_button.dart';
import 'package:pilll/features/premium_introduction/components/monthly_purchase_button.dart';
import 'package:pilll/features/premium_introduction/premium_complete_dialog.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseButtons extends HookConsumerWidget {
  final OfferingType offeringType;
  final Package monthlyPackage;
  final Package annualPackage;
  final ValueNotifier<bool> isLoading;

  const PurchaseButtons({
    super.key,
    required this.offeringType,
    required this.monthlyPackage,
    required this.annualPackage,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchase = ref.watch(purchaseProvider);
    return Row(
      children: [
        const Spacer(),
        MonthlyPurchaseButton(
          monthlyPackage: monthlyPackage,
          onTap: (monthlyPackage) async {
            analytics.logEvent(name: "pressed_monthly_purchase_button");
            await _purchase(context, monthlyPackage, purchase);
          },
        ),
        const SizedBox(width: 16),
        AnnualPurchaseButton(
          annualPackage: annualPackage,
          offeringType: offeringType,
          onTap: (annualPackage) async {
            analytics.logEvent(name: "pressed_annual_purchase_button");
            await _purchase(context, annualPackage, purchase);
          },
        ),
        const Spacer(),
      ],
    );
  }

  Future<void> _purchase(BuildContext context, Package package, Purchase purchase) async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;
    try {
      final shouldShowCompleteDialog = await purchase(package);
      if (shouldShowCompleteDialog) {
        // ignore: use_build_context_synchronously
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
      if (context.mounted) showErrorAlert(context, error);
    } finally {
      isLoading.value = false;
    }
  }
}
