# Paywall 導線(paywall_source) と 課金率分析の実装プラン

## Context

Pilll では PremiumIntroductionSheet (通常 Paywall) が 21箇所、SpecialOfferingPage / SpecialOfferingPage2 (キャンペーン Paywall) が 2箇所、計 23 箇所から呼ばれているが、現状「どこから来たか」を識別する `paywall_source` は実装されていない。Firebase Analytics 上では各 caller 個別の `pressed_xxx` イベントから直前イベントの逆引きで経路を推定している (`PilllBackend/bigquery/queries/paywall_entry_route_conversion.sql`) が、精度が低く `unknown_or_app_launch` などに丸まる。

加えて「購入が完了した」ことを示す Analytics イベントも存在せず、`pressed_*_purchase_button` (ボタン押下) を購入の代理指標にしているため、ユーザーキャンセル・PlatformException を含めて CV 数を過大評価する。

本プランでは以下を満たす:
1. Flutter 側で `PaywallSource` enum を一級市民として導入し、表示時イベント `paywall_viewed` に明示的に乗せる
2. 購入実完了時の `purchase_succeeded` イベントを新規追加し、同じ `paywall_source` を乗せる
3. 既存 `pressed_*_purchase_button` にも `paywall_source` を付与し、表示 → 押下 → 完了のファネル分析を可能にする
4. 集計 SQL は PilllBackend 側に Issue を立てて別タスクとして引き継ぐ

## 現状の関連コード

| 役割 | パス |
|---|---|
| Paywall 起動関数 | `lib/features/premium_introduction/premium_introduction_sheet.dart:168` `showPremiumIntroductionSheet(BuildContext context)` |
| Paywall 本体 | `lib/features/premium_introduction/premium_introduction_sheet.dart` `PremiumIntroductionSheet` / `PremiumIntroductionSheetBody` |
| 購入ボタン群 | `lib/features/premium_introduction/components/purchase_buttons.dart` |
| キャンペーン Paywall | `lib/features/special_offering/page.dart` `SpecialOfferingPage` / `lib/features/special_offering/page2.dart` `SpecialOfferingPage2` |
| キャンペーン Paywall 起動 | `lib/features/record/components/announcement_bar/components/special_offering.dart:32` / `special_offering2.dart:35` (`showModalBottomSheet` 直書き) |
| 購入実行 | `lib/provider/purchase.dart:165-205` `class Purchase { Future<bool> call(Package package) }` |
| Analytics ラッパー | `lib/utils/analytics.dart` `analytics.logEvent({required String name, Map<String, Object?>? parameters})` |
| Offering 種別 enum (購入プラン構成、別概念) | `lib/provider/purchase.dart:20` `enum OfferingType { discount, specialOffering, premium }` |

## 実装

### Step 1. PaywallSource enum 新規作成

新規ファイル: `lib/features/premium_introduction/paywall_source.dart`

```dart
// Firebase Analytics の paywall_viewed / purchase_succeeded / pressed_*_purchase_button
// に paywall_source パラメータとして送出され、BigQuery で経路別 CV 率を集計する。
//
// 値の追加・変更時は PilllBackend/bigquery/queries/paywall_source_conversion.sql の
// 集計対象と整合させること。
enum PaywallSource {
  // アプリ初回起動時の自動表示
  appLaunch,
  // HomePage 月次自動表示 (Trial 終了後の再アピール)
  homeMonthly,
  // カレンダー画面のオーバーレイ
  calendarOverlay,
  // 服用履歴カード本体
  pillSheetModifiedHistoryCard,
  // 服用履歴カードの More ボタン
  pillSheetModifiedHistoryMore,
  // 生理履歴カード本体
  menstruationHistoryCard,
  // 生理履歴カードの「もっと見る」
  menstruationHistoryMore,
  // 日記投稿の体調詳細
  diaryPhysicalConditionDetail,
  // レコード画面の表示モード切替モーダル
  appearanceModeSelect,
  // 割引キャンペーン announcement bar
  discountAnnouncementBar,
  // PilllAds bar 閉じる時
  pilllAdsAnnouncementBarClose,
  // ピルシート終了 bar
  endedPillSheetBar,
  // 設定画面 - プレミアムプラン行
  settingsPremiumIntroductionRow,
  // 設定画面 - 緊急通知行 (Premium ロック)
  settingsCriticalAlertRow,
  // 設定画面 - 新規ピルシート作成行 (Premium ロック)
  settingsCreatingNewPillSheetRow,
  // 設定画面 - クイック記録行 (Premium ロック)
  settingsQuickRecordRow,
  // 設定画面 - リマインダー文言カスタマイズ行 (Premium ロック)
  settingsReminderCustomizeRow,
  // 機能訴求 - AlarmKit
  featureAppealAlarmKit,
  // 機能訴求 - 表示モード日付
  featureAppealAppearanceMode,
  // 機能訴求 - 新規ピルシート作成
  featureAppealCreatingPillSheet,
  // 機能訴求 - 緊急通知
  featureAppealCriticalAlert,
  // 機能訴求 - クイック記録
  featureAppealQuickRecord,
  // 機能訴求 - リマインダー文言カスタマイズ
  featureAppealReminderCustomize,
  // SpecialOfferingPage 起動 announcement bar (年額)
  specialOfferingBar,
  // SpecialOfferingPage2 起動 announcement bar (月額)
  specialOfferingBar2,
}

extension PaywallSourceFunction on PaywallSource {
  String get value {
    switch (this) {
      case PaywallSource.appLaunch:
        return 'app_launch';
      case PaywallSource.homeMonthly:
        return 'home_monthly';
      case PaywallSource.calendarOverlay:
        return 'calendar_overlay';
      case PaywallSource.pillSheetModifiedHistoryCard:
        return 'pill_sheet_modified_history_card';
      case PaywallSource.pillSheetModifiedHistoryMore:
        return 'pill_sheet_modified_history_more';
      case PaywallSource.menstruationHistoryCard:
        return 'menstruation_history_card';
      case PaywallSource.menstruationHistoryMore:
        return 'menstruation_history_more';
      case PaywallSource.diaryPhysicalConditionDetail:
        return 'diary_physical_condition_detail';
      case PaywallSource.appearanceModeSelect:
        return 'appearance_mode_select';
      case PaywallSource.discountAnnouncementBar:
        return 'discount_announcement_bar';
      case PaywallSource.pilllAdsAnnouncementBarClose:
        return 'pilll_ads_announcement_bar_close';
      case PaywallSource.endedPillSheetBar:
        return 'ended_pill_sheet_bar';
      case PaywallSource.settingsPremiumIntroductionRow:
        return 'settings_premium_introduction_row';
      case PaywallSource.settingsCriticalAlertRow:
        return 'settings_critical_alert_row';
      case PaywallSource.settingsCreatingNewPillSheetRow:
        return 'settings_creating_new_pill_sheet_row';
      case PaywallSource.settingsQuickRecordRow:
        return 'settings_quick_record_row';
      case PaywallSource.settingsReminderCustomizeRow:
        return 'settings_reminder_customize_row';
      case PaywallSource.featureAppealAlarmKit:
        return 'feature_appeal_alarm_kit';
      case PaywallSource.featureAppealAppearanceMode:
        return 'feature_appeal_appearance_mode';
      case PaywallSource.featureAppealCreatingPillSheet:
        return 'feature_appeal_creating_pill_sheet';
      case PaywallSource.featureAppealCriticalAlert:
        return 'feature_appeal_critical_alert';
      case PaywallSource.featureAppealQuickRecord:
        return 'feature_appeal_quick_record';
      case PaywallSource.featureAppealReminderCustomize:
        return 'feature_appeal_reminder_customize';
      case PaywallSource.specialOfferingBar:
        return 'special_offering_bar';
      case PaywallSource.specialOfferingBar2:
        return 'special_offering_bar2';
    }
  }
}
```

設計意図:
- enum 名の rename / 難読化に影響されないよう `value` は明示列挙
- 25 値だが、ユーザー指示の「細粒度 23値」+ SpecialOffering 起動 2 値で構成
- `feature_appeal_*` / `settings_*` も個別値にして drill down 不要 (BigQuery で素直に GROUP BY できる)

### Step 2. showPremiumIntroductionSheet の signature 更新 + paywall_viewed 送出

`lib/features/premium_introduction/premium_introduction_sheet.dart` の修正:

```dart
// L27 付近
class PremiumIntroductionSheet extends HookConsumerWidget {
  const PremiumIntroductionSheet({super.key, required this.source});
  final PaywallSource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ... (既存のロジックはそのまま)
    return PremiumIntroductionSheetBody(source: source);
  }
}

// L50 付近
class PremiumIntroductionSheetBody extends HookConsumerWidget {
  const PremiumIntroductionSheetBody({super.key, required this.source});
  final PaywallSource source;
  // ... (build 内で PurchaseButtons(source: source, ...) を渡す)
}

// L168 (showPremiumIntroductionSheet)
Future<void> showPremiumIntroductionSheet(
  BuildContext context, {
  required PaywallSource source,
}) async {
  analytics.logScreenView(screenName: 'PremiumIntroductionSheet');
  analytics.logEvent(
    name: 'paywall_viewed',
    parameters: {'paywall_source': source.value},
  );
  await showModalBottomSheet(
    context: context,
    builder: (_) => PremiumIntroductionSheet(source: source),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
```

ポイント:
- `BuildContext` は positional 維持、`source` は **named required** (CLAUDE.md ルール)。これにより 23 箇所の caller 修正漏れがコンパイルエラーで検知される
- `paywall_viewed` イベント名は新規。既存の `screen_PremiumIntroductionSheet` (`logScreenView` 由来) は互換のため残す

### Step 3. SpecialOfferingPage / SpecialOfferingPage2 の signature 更新 + ヘルパー追加

`lib/features/special_offering/page.dart` (`SpecialOfferingPage`):

```dart
class SpecialOfferingPage extends HookConsumerWidget {
  const SpecialOfferingPage({
    super.key,
    required this.source,
    required this.specialOfferingIsClosed,
  });
  final PaywallSource source;
  final ValueNotifier<bool> specialOfferingIsClosed;
  // ... 既存ロジック維持。purchase 呼び出し箇所で source を渡す
}

Future<void> showSpecialOfferingPage(
  BuildContext context, {
  required PaywallSource source,
  required ValueNotifier<bool> specialOfferingIsClosed,
}) async {
  analytics.logScreenView(screenName: 'SpecialOfferingPage');
  analytics.logEvent(
    name: 'paywall_viewed',
    parameters: {'paywall_source': source.value},
  );
  await showModalBottomSheet(
    context: context,
    builder: (_) => SpecialOfferingPage(
      source: source,
      specialOfferingIsClosed: specialOfferingIsClosed,
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
  );
}
```

`page2.dart` の `SpecialOfferingPage2` / `showSpecialOfferingPage2` も同様の構造。

呼び出し側 `lib/features/record/components/announcement_bar/components/special_offering.dart:30-39` を:

```dart
// before (showModalBottomSheet 直書き)
await showModalBottomSheet(
  context: context,
  builder: (_) => SpecialOfferingPage(specialOfferingIsClosed: specialOfferingIsClosed),
  ...
);

// after
await showSpecialOfferingPage(
  context,
  source: PaywallSource.specialOfferingBar,
  specialOfferingIsClosed: specialOfferingIsClosed,
);
```

`special_offering2.dart:33-43` も同様に `showSpecialOfferingPage2(... source: PaywallSource.specialOfferingBar2)` に置換。

### Step 4. 23 箇所の caller を更新

| ファイル | source 値 |
|---|---|
| `lib/features/root/resolver/show_paywall_on_app_launch.dart:39` | `PaywallSource.appLaunch` |
| `lib/features/home/page.dart:154` | `PaywallSource.homeMonthly` |
| `lib/features/calendar/page.dart:301` | `PaywallSource.calendarOverlay` |
| `lib/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart:152` | `PaywallSource.pillSheetModifiedHistoryCard` |
| `lib/features/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_more_button.dart:27` | `PaywallSource.pillSheetModifiedHistoryMore` |
| `lib/features/menstruation/history/menstruation_history_card.dart:38` | `PaywallSource.menstruationHistoryCard` |
| `lib/features/menstruation/history/menstruation_history_card.dart:75` | `PaywallSource.menstruationHistoryMore` |
| `lib/features/diary_post/physical_condition_details.dart:59` | `PaywallSource.diaryPhysicalConditionDetail` |
| `lib/features/record/components/setting/components/appearance_mode/select_appearance_mode_modal.dart:122` | `PaywallSource.appearanceModeSelect` |
| `lib/features/record/components/announcement_bar/announcement_bar.dart:155` | `PaywallSource.discountAnnouncementBar` |
| `lib/features/record/components/announcement_bar/announcement_bar.dart:204` | `PaywallSource.pilllAdsAnnouncementBarClose` |
| `lib/features/record/components/announcement_bar/components/ended_pill_sheet.dart:34` | `PaywallSource.endedPillSheetBar` |
| `lib/features/settings/components/rows/premium_introduction.dart:22` | `PaywallSource.settingsPremiumIntroductionRow` |
| `lib/features/settings/components/rows/critical_alert.dart:55` | `PaywallSource.settingsCriticalAlertRow` |
| `lib/features/settings/components/rows/creating_new_pillsheet.dart:67` | `PaywallSource.settingsCreatingNewPillSheetRow` |
| `lib/features/settings/components/rows/quick_record.dart:41` | `PaywallSource.settingsQuickRecordRow` |
| `lib/features/settings/components/rows/reminder_notification_customize_word.dart:57` | `PaywallSource.settingsReminderCustomizeRow` |
| `lib/features/feature_appeal/alarm_kit/alarm_kit_help_page.dart:140` | `PaywallSource.featureAppealAlarmKit` |
| `lib/features/feature_appeal/appearance_mode_date/appearance_mode_date_help_page.dart:118` | `PaywallSource.featureAppealAppearanceMode` |
| `lib/features/feature_appeal/creating_new_pillsheet/creating_new_pillsheet_help_page.dart:140` | `PaywallSource.featureAppealCreatingPillSheet` |
| `lib/features/feature_appeal/critical_alert/critical_alert_help_page.dart:136` | `PaywallSource.featureAppealCriticalAlert` |
| `lib/features/feature_appeal/quick_record/quick_record_help_page.dart:147` | `PaywallSource.featureAppealQuickRecord` |
| `lib/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_help_page.dart:134` | `PaywallSource.featureAppealReminderCustomize` |

修正例 (`settings/components/rows/premium_introduction.dart`):

```dart
// before
onTap: () => showPremiumIntroductionSheet(context),
// after
onTap: () => showPremiumIntroductionSheet(context, source: PaywallSource.settingsPremiumIntroductionRow),
```

### Step 5. Purchase.call の signature 更新 + purchase_succeeded 送出

`lib/provider/purchase.dart` の修正 (L165-205):

```dart
class Purchase {
  Future<bool> call(Package package, {required PaywallSource source}) async {
    try {
      final purchaserInfo = await Purchases.purchasePackage(package);
      final premiumEntitlement = purchaserInfo.entitlements.all[premiumEntitlements];
      if (premiumEntitlement == null) {
        throw AssertionError(L.unexpectedPremiumEntitlementsIsNotExists);
      }
      if (!premiumEntitlement.isActive) {
        throw AlertError(L.purchaseErrorPurchasePendingError);
      }
      analytics.logEvent(
        name: 'purchase_succeeded',
        parameters: {
          'paywall_source': source.value,
          'package_type': package.packageType.name,
          'product_identifier': package.storeProduct.identifier,
        },
      );
      await callUpdatePurchaseInfo(purchaserInfo);
      return Future.value(true);
    } on PlatformException catch (e) {
      // 既存の catched_purchase_exception 送出ロジックを維持
      // ...
      rethrow;
    }
  }
}
```

設計意図:
- `purchase_succeeded` は `Purchase.call` 内、`premiumEntitlement.isActive == true` 確定後に発火
- `Purchases.addCustomerInfoUpdateListener(callUpdatePurchaseInfo)` 経由 (`purchase.dart:284`) で発火する `callUpdatePurchaseInfo` は復元・他端末同期で走るパスのため、ここでは `purchase_succeeded` は発火しない (paywall_source が無いため)
- `package.packageType.name` は purchases_flutter の `PackageType` enum 標準名を文字列化

### Step 6. 購入ボタン群に source 伝搬 + pressed_*_purchase_button に paywall_source 付与

`lib/features/premium_introduction/components/purchase_buttons.dart`:

```dart
class PurchaseButtons extends HookConsumerWidget {
  const PurchaseButtons({
    super.key,
    required this.source,
    required this.offeringType,
    // ... 既存引数
  });
  final PaywallSource source;
  final OfferingType offeringType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // L48 付近 (月額ボタン)
    onPressed: () async {
      analytics.logEvent(
        name: 'pressed_monthly_purchase_button',
        parameters: {'paywall_source': source.value},
      );
      final purchase = ref.read(purchaseProvider);
      await purchase(monthlyPackage, source: source);
    },

    // L59 付近 (年額ボタン)
    analytics.logEvent(
      name: 'pressed_annual_purchase_button',
      parameters: {'paywall_source': source.value},
    );
    await purchase(annualPackage, source: source);

    // L74 付近 (買い切りボタン)
    analytics.logEvent(
      name: 'pressed_lifetime_purchase_button',
      parameters: {'paywall_source': source.value},
    );
    await purchase(lifetimePackage, source: source);
  }
}
```

`SpecialOfferingPage` / `SpecialOfferingPage2` の購入ボタンも同様に `source` を保持し、`purchase(package, source: source)` を呼ぶ。専用イベント (`special_offering_close_button_tapped` など) にも `paywall_source` パラメータを追加。

### Step 7. Unit Test 追加

新規ファイル: `test/features/premium_introduction/paywall_source_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';

void main() {
  group('#PaywallSourceFunction', () {
    test('全 PaywallSource の value がユニーク', () {
      final values = PaywallSource.values.map((e) => e.value).toList();
      expect(values.toSet().length, values.length, reason: '重複: $values');
    });

    test('全 PaywallSource の value が snake_case', () {
      final pattern = RegExp(r'^[a-z][a-z0-9_]*$');
      for (final s in PaywallSource.values) {
        expect(pattern.hasMatch(s.value), isTrue, reason: s.value);
      }
    });

    test('代表値の value が期待通り', () {
      expect(PaywallSource.appLaunch.value, 'app_launch');
      expect(PaywallSource.settingsPremiumIntroductionRow.value, 'settings_premium_introduction_row');
      expect(PaywallSource.featureAppealAlarmKit.value, 'feature_appeal_alarm_kit');
      expect(PaywallSource.specialOfferingBar2.value, 'special_offering_bar2');
    });

    test('value 文字列が Firebase Analytics の40字制限内', () {
      for (final s in PaywallSource.values) {
        expect(s.value.length, lessThanOrEqualTo(40), reason: s.value);
      }
    });
  });
}
```

### Step 8. 既存 Widget Test の修正

`test/features/premium_introduction/premium_introduction_sheet_test.dart` (既存) で `showPremiumIntroductionSheet` を呼んでいるテストに `source: PaywallSource.appLaunch` を追加。

23 caller の Widget Test を全部書くのは過剰なので、enum.values.length === 25 の不変条件 + named required によるコンパイラ強制で漏れ防止する方針。

### Step 9. PilllBackend 側 Issue 作成

PilllBackend リポジトリ (https://github.com/bannzai/PilllBackend) に Issue を新規作成する。Issue タイトル / 本文:

```
Title: paywall_source パラメータベースの Paywall 経路別 CV 率集計 SQL を追加

Body:
Pilll Flutter 側 (PR #xxx) で paywall_viewed / purchase_succeeded / pressed_*_purchase_button イベントに paywall_source パラメータを送出するようになる。
これに伴い、bigquery/queries/paywall_source_conversion.sql を新規追加して経路別の CV 率を集計したい。

集計したいメトリクス:
- paywall_source 別の paywall_viewed 数
- paywall_source 別の purchase_succeeded 数
- paywall_source 別の CV 率 (purchase_succeeded / paywall_viewed)
- paywall_source × deviceOS 別の CV 率
- ファネル: paywall_viewed → pressed_*_purchase_button → purchase_succeeded

実装の起点:
- 既存 bigquery/queries/paywall_entry_route_conversion.sql の構造を参考に
- イベント名は paywall_viewed / purchase_succeeded / pressed_monthly_purchase_button / pressed_annual_purchase_button / pressed_lifetime_purchase_button
- paywall_source の取り得る値は Pilll Flutter リポジトリの lib/features/premium_introduction/paywall_source.dart を参照

リリース後 1〜2ヶ月は paywall_entry_route_conversion.sql (逆引き) と paywall_source_conversion.sql (明示) を併用して精度差を比較する。
```

(Issue 作成自体はユーザーが gh CLI で実行 or 後続作業で手動)

## 検証

### コード生成 / 静的解析 / テスト
1. コード生成不要 (freezed / json_serializable は使わない)
2. `flutter analyze` でエラーなし (named required 必須なので 23 caller の修正漏れがあるとコンパイルエラー)
3. `flutter test test/features/premium_introduction/paywall_source_test.dart` 通過
4. `flutter test` 全件通過

### iOS / Android ビルド
5. `flutter build ios --flavor develop --no-codesign` 成功
6. `flutter build apk --flavor develop` 成功

### 手動 / E2E
7. iOS シミュレータで以下を確認 (`/sim-manager` + `/verify-ui-mobile-mcp`):
   - 設定 → プレミアムプラン行タップ → Paywall 表示
   - Firebase DebugView (or `kDebugMode` 時の `print` 出力) で `paywall_viewed` + `paywall_source: settings_premium_introduction_row` が送出されていること
   - 月額ボタン押下 → `pressed_monthly_purchase_button` + `paywall_source: settings_premium_introduction_row` が送出されていること
   - サンドボックス購入完了後 → `purchase_succeeded` + `paywall_source: settings_premium_introduction_row` + `package_type: monthly` が送出されていること
8. SpecialOfferingPage の announcement bar 経由でも同様に `paywall_source: special_offering_bar` が送出されていることを確認

### BigQuery 検証 (リリース後)
9. リリース後 1 週間の `paywall_viewed` イベント数と既存 `screen_PremiumIntroductionSheet` イベント数の比較。極端な乖離 (50% 以上) があれば送信漏れ箇所を疑う
10. PilllBackend Issue (Step 9) で SQL を作成後、`bash bigquery/scripts/run_query.sh bigquery/queries/paywall_source_conversion.sql --max_rows=100` で初回集計

## 影響範囲・リスク

- **過去データ**: 既存ユーザーのうちアプリ更新前のセッションは `paywall_source IS NULL` で残る。BigQuery 側で `COALESCE(paywall_source, 'unknown_legacy')` 扱い
- **23 caller 修正漏れ**: named required で**コンパイラが防御**。CI 通過 = 修正完了
- **既存 BigQuery view への影響**: 新規イベント `paywall_viewed` / `purchase_succeeded` を追加するだけで、既存 `screen_PremiumIntroductionSheet` / `pressed_*_purchase_button` / `start_update_purchase_info` 等は維持。既存 view への影響なし
- **`Purchase.call` listener 経由パス**: `Purchases.addCustomerInfoUpdateListener` 由来の `callUpdatePurchaseInfo` は復元・他端末同期で走るが、ここでは `purchase_succeeded` を発火しない。これは設計意図 (購入完了 ≠ 状態同期) に合致

## 作業順序

1. Step 1: PaywallSource enum 新規作成 + Step 7 の Unit Test 追加
2. Step 2: showPremiumIntroductionSheet signature 更新 (named required `source` 追加、`paywall_viewed` 送出)
3. Step 3: SpecialOfferingPage / SpecialOfferingPage2 signature 更新 + showSpecialOfferingPage ヘルパー追加
4. Step 4: 23 caller を一括修正 (コンパイルエラーが消えるまで)
5. Step 5: Purchase.call signature 更新 + `purchase_succeeded` 送出
6. Step 6: PurchaseButtons / SpecialOffering 系購入ボタンに source 伝搬 + `pressed_*_purchase_button` に `paywall_source` 付与
7. Step 8: 既存 Widget Test の修正
8. `flutter analyze` / `flutter test` / `flutter build ios` / `flutter build apk` 全通過確認
9. iOS シミュレータで手動検証
10. PR 作成
11. Step 9: PilllBackend リポジトリに Issue 作成

---

## チェックリスト

### 実装内容
- [ ] 変更対象ファイルごとに具体的なコード提案をコードブロックで記載している
- [ ] 既存コードのパターン・構成を確認し、同じパターンで実装している
- [ ] コード生成: 不要 (freezed / json_serializable 未使用)
- [ ] 静的解析: `flutter analyze` エラーなし
- [ ] テスト: `flutter test` 全件パス
- [ ] iOS ビルド: `flutter build ios` 成功
- [ ] Android ビルド: `flutter build apk` 成功
- [ ] 新規・変更機能に対するテストが存在する (PaywallSource Unit Test 新規追加)
- [ ] Maestro E2E: 該当する maestro flow があれば実行、なければ新規作成 (Paywall 表示・購入導線の既存 flow があれば paywall_source 送出を含む形に更新確認)
- [ ] Entity 命名: フィールド名が省略されていない (PaywallSource enum 値は full name)
- [ ] DB 操作: Firestore 操作は `call` クラスの Provider 経由 (本タスクでは Firestore 操作なし)
- [ ] 引数: 関数・コンストラクタの引数に `{required}` あり (showPremiumIntroductionSheet / showSpecialOfferingPage / Purchase.call / PurchaseButtons の `source`)
- [ ] ref 使い分け: build 内は `ref.watch`、コールバック・操作は `ref.read` (PurchaseButtons の `purchaseProvider` は `ref.read`)
- [ ] サブコレクション Entity に親ドキュメント ID フィールドあり (該当なし)
- [ ] エラーメッセージはそのまま表示 (`Purchase.call` の例外処理は既存ロジック維持)

### 追加確認
- [ ] PilllBackend リポジトリに「paywall_source 集計 SQL 追加」Issue を作成した
- [ ] 23 caller すべてに source 引数を追加し、コンパイルエラーがないことを確認した
- [ ] iOS シミュレータで Firebase Analytics DebugView もしくは kDebugMode の print 出力で `paywall_viewed` / `pressed_*_purchase_button` / `purchase_succeeded` がそれぞれ正しい `paywall_source` 値を送出していることを目視確認した
