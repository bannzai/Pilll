# lifetime_offer

利用開始から約1年になる約1ヶ月前のユーザーへ、割引版の買い切り(lifetime)プランを一度だけ訴求するオファー機能。

## 役割

- 月額・年額を約1年払い続けてきたユーザーの、買い切りプランへの乗り換え(CV)を狙う
- 表示対象は課金・非課金を問わず全ユーザー。ただし買い切り購入済みユーザーは除外
- 買い切りはiOSのみ実装のため、Androidでは表示されない（`lifetimeDiscountPackageProvider` がnullになるため表示条件で弾かれる）

## 構成

- `provider.dart`
  - `shouldShowLifetimeOfferProvider`: 表示条件。Remote Configの `lifetimeOfferEnabled` と、利用日数が `lifetimeOfferUserCreationDaysSince < n < lifetimeOfferUserCreationDaysUntil`（排他境界、既定 335 < n < 355）で判定する。上限は1年の年会費更新と重なる課金トラブルを避けるため、更新直前を除外する意図で設定されている
  - `lifetimeOfferUsageDaysProvider`: `firebaseAuthUser.metadata.creationTime` からの経過日数
- `page.dart`: オファー画面。割引版買い切り（Discount offering）の価格と通常価格・割引率、利用日数、月額・年額課金中ユーザーへの解約誘導文言を表示する

## 導線

1. お知らせバー常設: `lib/features/record/components/announcement_bar/components/lifetime_offer.dart`。閉じると `BoolKey.lifetimeOfferIsClosed` で永続的に非表示
2. 起動時自動モーダル: `lib/features/root/resolver/show_lifetime_offer_on_app_launch.dart`。`BoolKey.lifetimeOfferAutoModalShown` で永続的に1回のみ。起動時ペイウォール（`ShowPaywallOnAppLaunch`）と同一起動で重ならないよう制御する

## 関連する外部設定

- RevenueCat: `Discount` offeringのlifetime package（割引価格）と `Premium3` offeringのlifetime package（通常価格）
- Firebase Remote Config: `lifetimeOfferEnabled` / `lifetimeOfferUserCreationDaysSince` / `lifetimeOfferUserCreationDaysUntil`
