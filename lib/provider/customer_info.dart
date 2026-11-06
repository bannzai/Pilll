import 'dart:async';

import 'package:collection/collection.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/functions/firebase_functions.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod/riverpod.dart';

/// RevenueCat の Promotional Entitlement (トライアル) の productIdentifier の接頭辞。
/// RevenueCat は Promotional Entitlement の productIdentifier を "rc_promo" で始め、entitlement 名と期間を続ける (例: rc_promo_Premium_three_day)。
/// 出典: https://docs-origin.revenuecat.com/docs/dashboard-and-metrics/customer-history/promotionals 、bannzai/Focus の DigitalDetox/Features/CustomerInfo/CustomerInfo+.swift
const promotionalPremiumProductIdentifierPrefix = 'rc_promo_$premiumEntitlements';

/// ログイン中のユーザーの RevenueCat の CustomerInfo。プレミアム・トライアルの判定の正。
/// Purchases.configure の後に読む。UserSetup が configure を待ってからこの Provider を読み込み、読み込みが終わるまで画面を出さない
final customerInfoProvider = StreamProvider<CustomerInfo>((ref) {
  final controller = StreamController<CustomerInfo>();
  void customerInfoUpdateListener(CustomerInfo customerInfo) => controller.add(customerInfo);
  Purchases.addCustomerInfoUpdateListener(customerInfoUpdateListener);
  Purchases.getCustomerInfo().then(controller.add, onError: controller.addError);
  ref.onDispose(() {
    Purchases.removeCustomerInfoUpdateListener(customerInfoUpdateListener);
    controller.close();
  });
  return controller.stream;
});

/// 画面の外 (通知のアクション・ネイティブからの呼び出し) で CustomerInfo を取得する。
/// この経路は UserSetup を通らず RevenueCat SDK が未設定のことがあるため、未設定なら [uid] で設定してから取得する
Future<CustomerInfo> fetchCustomerInfoOutsideUI({required String uid}) async {
  if (!await Purchases.isConfigured) {
    configurePurchases(uid: uid);
  }
  return Purchases.getCustomerInfo();
}

final startPromotionProvider = Provider((ref) => StartPromotion());

/// サーバーの callable `startPromotion` でトライアル (RevenueCat の Promotional Entitlement) を付与し、端末の CustomerInfo のキャッシュを捨てて取得し直す。
/// 付与の可否 (1 アカウント 1 回) と期限はサーバーが決める。付与は RevenueCat のサーバー側で起きるため、取得し直さないと端末の CustomerInfo に反映されない
class StartPromotion {
  Future<void> call() async {
    await functions.startPromotion();
    await Purchases.invalidateCustomerInfoCache();
    await Purchases.getCustomerInfo();
  }
}

/// プレミアム・トライアル・割引期限の判定。
/// 権限の正は RevenueCat の CustomerInfo。Promotional Entitlement でトライアルを付与する前の版でトライアルを始めた既存ユーザーだけ、
/// users ドキュメントの trialDeadlineDate・discountEntitlementDeadlineDate・beginTrialDate を読み取り専用で使う
extension CustomerInfoPremium on CustomerInfo {
  /// 課金 (サブスクリプション・買い切り) で Premium を持っているか。トライアル (Promotional Entitlement) は含めない。
  /// Promotional Entitlement の期限が課金より後の時は entitlements.active の productIdentifier が Promotional Entitlement の方になるため、activeSubscriptions も見る。
  /// Pilll の商品は全て Premium entitlement に紐づくため、activeSubscriptions は Premium の商品だけを含む
  bool get isPremium =>
      entitlements.active[premiumEntitlements]?.productIdentifier.startsWith(promotionalPremiumProductIdentifierPrefix) == false ||
      activeSubscriptions.any((productIdentifier) => !productIdentifier.startsWith(promotionalPremiumProductIdentifierPrefix));

  /// トライアルの Promotional Entitlement の期限。期限切れも含み、付与されていなければ null
  DateTime? get promotionalPremiumExpirationDate => allExpirationDates.entries
      .where((entry) => entry.key.startsWith(promotionalPremiumProductIdentifierPrefix))
      .map((entry) => entry.value)
      .nonNulls
      .map((expirationDate) => DateTime.parse(expirationDate).toLocal())
      .maxOrNull;

  /// トライアルの期限。Promotional Entitlement が無い既存ユーザーは users ドキュメントの期限を使う
  DateTime? trialDeadlineDate({required User user}) => promotionalPremiumExpirationDate ?? user.trialDeadlineDate;

  /// トライアル中か
  bool isTrial({required User user}) {
    final trialDeadlineDate = this.trialDeadlineDate(user: user);
    return trialDeadlineDate != null && now().isBefore(trialDeadlineDate);
  }

  /// プレミアム会員またはトライアル中か
  // NOTE: [SyncData:Widget] この値はWidgetに同期されてる
  bool premiumOrTrial({required User user}) => isPremium || isTrial(user: user);

  /// トライアルを開始済みか
  bool trialIsAlreadyBegin({required User user}) => promotionalPremiumExpirationDate != null || user.beginTrialDate != null;

  /// トライアル終了後に割引価格で購入できる期限。トライアルの期限の [discountEntitlementOffsetDay] 日後。
  /// トライアルを始めていないユーザーは null
  DateTime? discountEntitlementDeadlineDate({required User user, required int discountEntitlementOffsetDay}) =>
      promotionalPremiumExpirationDate?.addDays(discountEntitlementOffsetDay) ?? user.discountEntitlementDeadlineDate;

  /// 割引価格で購入できるか。期限が決まっていない (トライアル前・トライアルの期限を持たない古いデータ) 時も購入できる
  bool hasDiscountEntitlement({required User user, required int discountEntitlementOffsetDay}) {
    final discountEntitlementDeadlineDate =
        this.discountEntitlementDeadlineDate(user: user, discountEntitlementOffsetDay: discountEntitlementOffsetDay);
    return discountEntitlementDeadlineDate == null || now().isBefore(discountEntitlementDeadlineDate);
  }
}
