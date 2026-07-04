# lifetime_offer

利用開始から1年ごと、年会費の更新が近づく約1ヶ月前の時期に、割引版の買い切り(lifetime)プランを期間限定で訴求するオファー機能。

## 役割

- 月額・年額を払い続けてきたユーザーの、買い切りプランへの乗り換え(CV)を狙う
- 表示対象は課金・非課金を問わず全ユーザー。ただし買い切り購入済みユーザーは除外
- 買い切りはiOSのみ実装のため、Androidでは表示されない（`lifetimeDiscountPackageProvider` がnullになるため表示条件で弾かれる）
- 365日周期（うるう年による1日程度のずれは許容）で毎年同じ時期に表示される。周期ごとに、オファーが初めて画面に表示された時刻から `lifetimeOfferDurationHours`（既定24時間）の表示期限があり、期限を過ぎるとバー・モーダルとも自動で非表示になる

## 構成

- `provider.dart`
  - `shouldShowLifetimeOfferProvider`: 表示条件。Remote Configの `lifetimeOfferEnabled` と、365日周期に換算した利用日数（`usageDays % 365`）が `lifetimeOfferUserCreationDaysSince < n < lifetimeOfferUserCreationDaysUntil`（排他境界、既定 335 < n < 355）で判定する。上限は1年の年会費更新と重なる課金トラブルを避けるため、更新直前を除外する意図で設定されている。加えてその周期の表示期限（`isOverLifetimeOfferDeadlineProvider`）を過ぎたら非表示になる
  - `lifetimeOfferUsageDaysProvider`: `firebaseAuthUser.metadata.creationTime` からの経過日数
  - `lifetimeOfferCycleProvider`: 周期番号（利用開始からの経過年数, 0始まり）。初回表示時刻・モーダル表示済みフラグのキーに使う
  - `lifetimeOfferDeadlineProvider`: その周期の初回表示時刻（`lifetimeOfferFirstDisplayedDateTimeKey`）+ `lifetimeOfferDurationHours` 時間の表示期限。周期が変わると新しい表示期限が始まる。その周期で初回表示前はnull
  - `lifetimeOfferRemainingDurationProvider`: 表示期限までの残り時間。`tickProvider` により毎秒更新されるため、カウントダウン表示するWidget内でのみwatchする
  - `setLifetimeOfferFirstDisplayedDateTimeIfAbsent`: その周期の初回表示時刻のset-if-absent永続化。バー・モーダルどちらが先に表示されても同じ起点になる
- `page.dart`: オファー画面。割引版買い切り（Discount offering）の価格と通常価格・割引率、利用日数、残り時間カウントダウン、月額・年額課金中ユーザーへの解約誘導文言を表示する

## 導線

1. お知らせバー常設: `lib/features/record/components/announcement_bar/components/lifetime_offer.dart`。残り時間を毎秒カウントダウン表示し、表示期限を過ぎると自動で消える（閉じるボタンはない）
2. 起動時自動モーダル: `lib/features/root/resolver/show_lifetime_offer_on_app_launch.dart`。周期番号付きキー（`lifetimeOfferAutoModalShownKey`）で周期ごとに1回のみ。起動時ペイウォール（`ShowPaywallOnAppLaunch`）と同一起動で重ならないよう制御する

## 開発者オプション

設定タブ（非production限定）の「買い切りオファー Paywall」から、解約誘導文言あり/なしの2パターンをProviderScopeのoverrideで確認できる（`lib/features/settings/components/rows/lifetime_offer_paywall_row.dart`）。

## 関連する外部設定

- RevenueCat: `Discount` offeringのlifetime package（割引価格）と `Premium3` offeringのlifetime package（通常価格）
- Firebase Remote Config: `lifetimeOfferEnabled` / `lifetimeOfferUserCreationDaysSince` / `lifetimeOfferUserCreationDaysUntil` / `lifetimeOfferDurationHours`
