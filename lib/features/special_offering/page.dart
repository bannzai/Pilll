import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async_value_group/async_value_group.dart';
import 'package:pilll/components/app_store/app_store_review_cards.dart';
import 'package:pilll/features/premium_introduction/components/annual_purchase_button.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/user.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:pilll/features/premium_introduction/premium_complete_dialog.dart';

const _specialOfferingClosedKey = 'special_offering_paywall_closed_at';

Future<bool> shouldShowSpecialOffering() async {
  final prefs = await SharedPreferences.getInstance();
  return !prefs.containsKey(_specialOfferingClosedKey);
}

Future<void> setSpecialOfferingClosed() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_specialOfferingClosedKey, DateTime.now().millisecondsSinceEpoch);
}

void showSpecialOfferingModal(BuildContext context) async {
  if (await shouldShowSpecialOffering()) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SpecialOfferingModal(),
    );
  }
}

class SpecialOfferingModal extends HookConsumerWidget {
  const SpecialOfferingModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userProvider).when(
          data: (user) {
            return SpecialOfferingPageBody(user: user);
          },
          error: (error, stack) => AlertDialog(
            title: const Text('エラー'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}

class SpecialOfferingPageBody extends HookConsumerWidget {
  final User user;

  const SpecialOfferingPageBody({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyPremiumPackage = ref.watch(monthlyPremiumPackageProvider);
    final annualSpecialOfferingPackage = ref.watch(annualSpecialOfferingPackageProvider);

    return AlertDialog(
      title: const Text('今回限りの特別オファー'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('今だけ特別価格でプレミアム機能をゲット！'),
            const SizedBox(height: 16),
            if (annualSpecialOfferingPackage != null && monthlyPremiumPackage != null)
              AnnualPurchaseButton(
                annualPackage: annualSpecialOfferingPackage,
                monthlyPackage: monthlyPremiumPackage,
                onTap: (package) async {
                  if (isLoading.value) return;
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
                        },
                      );
                    }
                  } catch (error) {
                    debugPrint('caused purchase error for $error');
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('エラー'),
                          content: Text(error.toString()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('閉じる'),
                            ),
                          ],
                        ),
                      );
                    }
                  } finally {
                    isLoading.value = false;
                  }
                },
              ),
            const SizedBox(height: 24),
            const AppStoreReviewCards(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isClosing.value
              ? null
              : () async {
                  isClosing.value = true;
                  await setSpecialOfferingClosed();
                  Navigator.of(context).pop();
                },
          child: const Text('閉じる（この画面は再表示されません）'),
        ),
      ],
    );
  }
}
