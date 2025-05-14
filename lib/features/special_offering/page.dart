import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pilll/components/app_store/app_store_review_cards.dart';
import 'package:pilll/features/premium_introduction/components/annual_purchase_button.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/features/premium_introduction/premium_complete_dialog.dart';

const _specialOfferingClosedKey = 'special_offering_paywall_closed_at';

class SpecialOfferingPage extends HookConsumerWidget {
  const SpecialOfferingPage({super.key});

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
    final isLoading = useState(false);
    final isClosing = useState(false);

    final purchase = ref.watch(purchaseProvider);
    final monthlyPremiumPackage = ref.watch(monthlyPremiumPackageProvider);
    final annualSpecialOfferingPackage = ref.watch(annualSpecialOfferingPackageProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('今回限りの特別オファー'),
            leading: TextButton(
              onPressed: isClosing.value
                  ? null
                  : () async {
                      isClosing.value = true;
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt(_specialOfferingClosedKey, DateTime.now().millisecondsSinceEpoch);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
              child: const Text('閉じる（この画面は再表示されません）'),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('今だけ特別価格でプレミアム機能をゲット！'),
                        const SizedBox(height: 16),
                        if (annualSpecialOfferingPackage != null && monthlyPremiumPackage != null)
                          AnnualPurchaseButton(
                            annualPackage: annualSpecialOfferingPackage,
                            monthlyPackage: monthlyPremiumPackage,
                            monthlyPremiumPackage: monthlyPremiumPackage,
                            offeringType: OfferingType.specialOffering,
                            onTap: (package) async {
                              if (isLoading.value) return;
                              isLoading.value = true;

                              try {
                                final shouldShowCompleteDialog = await purchase(package);
                                if (shouldShowCompleteDialog) {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return PremiumCompleteDialog(onClose: () {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    );
                                  }
                                }
                              } catch (error) {
                                debugPrint('caused purchase error for $error');
                                if (context.mounted) {
                                  showErrorAlert(context, error);
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
