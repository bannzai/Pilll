# FeatureAppeal HelpPage 5 機能追加

## Context

Pilll の FeatureAppeal は「未認知の既存機能を Bar で訴求 → HelpPage で説明 → 該当タブに遷移」という動線。現在 8 ページ (Premium 3 / Free 5) が揃っているが、以下 5 機能がまだ HelpPage 化されていない。本タスクで 5 機能分の HelpPage + AnnouncementBar + テストを追加する。

| # | 機能 | 区分 | 遷移先タブ | 未作成の理由/訴求価値 |
|---|---|---|---|---|
| 1 | クイックレコード | Premium | setting | 通知からワンタップ服用記録。UI 上で便利さが非常に伝わりにくい |
| 2 | ピルシートグループ自動追加 | Premium | setting | シート終了時の自動切替。説明せずに気づくのが難しい |
| 3 | AlarmKit (iOS 26+) | Premium | setting | 目覚ましレベルの確実な通知。設定行が L10n 未対応 (範囲外) |
| 4 | 今日の服用番号変更 | Free | setting | Premium ではないが、ズレ補正手段の認知を上げたい |
| 5 | 服用おやすみ | Free | record | Premium ではないが、休薬・中断の正しい記録方法として訴求価値あり |

既存 8 ページは本タスクでは変更しない (禁止事項)。設定行の L10n 化 (AlarmKit) や `_mockTabBar` / `_featureCard` の共通化は後続タスクに分離する。

## アプローチ

実装の SSOT は `lib/features/feature_appeal/CLAUDE.md`。これを守り、既存 HelpPage を雛形にしてコピー差替えで進める。

- Premium 3 機能: `critical_alert_help_page.dart` を雛形
- Free 2 機能: `health_care_integration_help_page.dart` を雛形
- AnnouncementBar 全 5: `critical_alert_announcement_bar.dart` を雛形
- テスト全 10 本: `critical_alert_{help_page,announcement_bar}_test.dart` を雛形
- `_mockTabBar` / `_featureCard` は既存通り各ページにコピペ (既存 8 ページと同流儀)
- AlarmKit は「Android・iOS 25 以下でも Bar を表示し、FeatureCard Point3 で `iOS 26 以降` と明示」方針で `Platform.isIOS` 等の追加判定は入れない (候補リスト拡張の複雑性を避ける)

候補数は **8 → 13** に増える。`daysBetween(epoch, today()) % candidates.length` のローテ周期が 13 日になる。

## 追加 5 機能仕様

### 共通ルール
- HelpPage クラス名: `{FeatureName}HelpPage` (PascalCase)。`RouteSettings.name` は同名文字列
- `AppBar` title = `L.{feature}FeatureAppealTitle`
- Headline = `L.{feature}FeatureAppealHeadline`
- FeatureCard 3 点 = `L.{feature}FeatureAppealPoint1/2/3`
- `feature_key` (analytics) = snake_case のディレクトリ名

### 1. quick_record (Premium, setting)

- ソース機能: `lib/features/settings/components/rows/quick_record.dart`
- ヘッダー SVG: `images/dots.svg` + `ColorFilter(AppColors.primary, srcIn)`
- FeatureCard Icons: `Icons.notifications_active`, `Icons.touch_app`, `Icons.settings`
- **機能デモ gif**: FeatureCard × 3 の後、LocationLabel の前に、プラットフォーム別の gif を大きめに挿入する。既存流用のため**新規アセット追加なし**。
  - asset: `Platform.isIOS ? 'images/ios-quick-record.gif' : 'images/android-quick-record.gif'`
  - 初出: `lib/features/initial_setting/premium_trial/page.dart:81` で同じアセットを使用済
  - ラップ: `ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(...))`
  - 前後に `const SizedBox(height: 24)` を入れる
  - `import 'dart:io' show Platform;` を追加
- `_mockTabBar(selectedIndex: 3)`
- プレビュー: `critical_alert_help_page.dart` L78-112 と同じ `IgnorePointer` の ListTile + PremiumBadge。title=L.quickRecord / subtitle=L.quickRecordDescription

### 2. creating_new_pillsheet (Premium, setting)

- ソース機能: `lib/features/settings/components/rows/creating_new_pillsheet.dart`
- ヘッダー SVG: `images/empty_pill_sheet_type.svg` + primary ColorFilter
- FeatureCard Icons: `Icons.auto_awesome`, `Icons.autorenew`, `Icons.toggle_on`
- `_mockTabBar(selectedIndex: 3)`
- プレビュー: `SwitchListTile` モック (title=L.autoAddPillSheetGroup / subtitle=L.autoAddNewSheetAfterCurrentEnds) + PremiumBadge。実ソースと同じ SwitchListTile 形式

### 3. alarm_kit (Premium, setting)

- ソース機能: `lib/features/settings/components/rows/alarm_kit.dart`
- ヘッダー SVG: `images/alerm.svg` + primary ColorFilter (critical_alert と同 asset だが許容。訴求文言で差別化)
- FeatureCard Icons: `Icons.alarm`, `Icons.volume_up`, `Icons.phone_iphone`
- `_mockTabBar(selectedIndex: 3)`
- プレビュー: ListTile (title='アラーム機能', subtitle='目覚まし同様の通知が鳴ります。サイレント/集中モードでも確実に通知されます') + PremiumBadge + trailing に `Switch(value: false)` モック。**設定行側が L10n ハードコード日本語のため、プレビューも一貫性を取るためハードコード**。L10n 化は別タスクで実施

### 4. today_pill_number (Free, setting)

- ソース機能: `lib/features/settings/components/rows/today_pill_number.dart`
- ヘッダー SVG: `images/display_number_edit_icon.svg` (colorFilter なし / 必要なら primary)
- FeatureCard Icons: `Icons.edit`, `Icons.settings`, `Icons.touch_app`
- `_mockTabBar(selectedIndex: 3)`
- プレビュー: ListTile (title=L.changePillNumberForToday, trailing=chevron_right)。PremiumBadge なし

### 5. rest_duration (Free, record)

- ソース機能: `lib/features/record/components/setting/components/rest_duration/begin_manual_rest_duration.dart` 他
- ヘッダー SVG: `images/explain_rest_duration_date.svg` (既存イラストをそのまま流用。80x80 で潰れないか目視確認)
- FeatureCard Icons: `Icons.dark_mode_outlined`, `Icons.settings`, `Icons.event_repeat`
- `_mockTabBar(selectedIndex: 0)` — **record タブ**
- プレビュー: ListTile (title=L.startPauseTaking, leading=`Icon(Icons.settings)`) で「ピルシート設定シートからの導線」を暗示

## L10n キー追加 (7 × 5 = 35 キー)

命名: `{feature}FeatureAppeal{Title|ShortDescription|Headline|Body|Point1|Point2|Point3}`

### 配置
- `lib/l10n/app_ja.arb`:
  - `Title` / `ShortDescription` / `Headline` / `Body` を既存 `featureAppealLocationLabel` (L2562) の直前に追加
  - `Point1/2/3` を既存 `healthCareIntegrationFeatureAppealPoint3` (L2597) の直後に追加
- `lib/l10n/app_en.arb`: ja と同じ順序で追加

### 文言

#### quickRecord
| Key | ja | en |
|---|---|---|
| `quickRecordFeatureAppealTitle` | 通知からそのまま服用記録 | Record from the notification |
| `quickRecordFeatureAppealShortDescription` | アプリを開かず通知上で記録 | Log your dose right from the push |
| `quickRecordFeatureAppealHeadline` | 通知画面でワンタップ服用記録 | Tap the notification to record |
| `quickRecordFeatureAppealBody` | リマインダー通知を長押しすると「服用した」のアクションが表示され、アプリを開かずに服用を記録できます。 | Long-press the reminder notification to reveal a "Taken" action and log your dose without opening the app. |
| `quickRecordFeatureAppealPoint1` | 通知のアクションで服用記録 | Mark as taken from the push |
| `quickRecordFeatureAppealPoint2` | アプリを開かずに完了 | No need to open the app |
| `quickRecordFeatureAppealPoint3` | 設定タブ > クイックレコードで有効化 | Enable in Settings > Quick Record |

#### creatingNewPillSheet
| Key | ja | en |
|---|---|---|
| `creatingNewPillSheetFeatureAppealTitle` | ピルシートを自動で追加 | Automatically add a new pill sheet |
| `creatingNewPillSheetFeatureAppealShortDescription` | 次のシートを自動生成 | The next sheet appears automatically |
| `creatingNewPillSheetFeatureAppealHeadline` | 次のピルシートを自動で作成 | Start your next pill sheet automatically |
| `creatingNewPillSheetFeatureAppealBody` | 現在のピルシートグループが終わると、新しいピルシートグループが自動で作成されます。手動の切り替え操作が不要で、記録の抜けが起きません。 | When your current pill sheet group ends, a new one is created for you automatically so you never miss a record. |
| `creatingNewPillSheetFeatureAppealPoint1` | ピルシート終了で自動切り替え | Auto-switches when a sheet ends |
| `creatingNewPillSheetFeatureAppealPoint2` | 手動の作成操作が不要 | No manual setup between sheets |
| `creatingNewPillSheetFeatureAppealPoint3` | 設定タブのスイッチで切り替え | Toggle it from the Settings tab |

#### alarmKit
| Key | ja | en |
|---|---|---|
| `alarmKitFeatureAppealTitle` | 目覚ましのように鳴るアラーム | Wake-up style medication alarm |
| `alarmKitFeatureAppealShortDescription` | サイレントでも確実に鳴る通知 | Rings even on silent or focus mode |
| `alarmKitFeatureAppealHeadline` | 目覚まし同様の服用アラーム | Medication alarm like your wake-up |
| `alarmKitFeatureAppealBody` | iOS 26 以降で利用できる AlarmKit を使って、サイレントモードや集中モードでも確実に鳴るアラームでピルの服用を知らせます。 | Powered by AlarmKit on iOS 26+, this alarm rings through silent mode and focus modes so you won't miss a dose. |
| `alarmKitFeatureAppealPoint1` | サイレント/集中モードでも鳴る | Breaks through silent and focus |
| `alarmKitFeatureAppealPoint2` | 目覚まし同様のアラーム音 | Classic wake-up alarm sound |
| `alarmKitFeatureAppealPoint3` | iOS 26 以降・設定タブから有効化 | iOS 26+ only, toggle in Settings |

#### todayPillNumber
| Key | ja | en |
|---|---|---|
| `todayPillNumberFeatureAppealTitle` | 今日の服用番号を合わせる | Align today's pill number |
| `todayPillNumberFeatureAppealShortDescription` | 番号がずれたら設定で修正 | Fix the number if it drifted |
| `todayPillNumberFeatureAppealHeadline` | 今日飲むピル番号を変更できる | Change today's pill number |
| `todayPillNumberFeatureAppealBody` | 飲み忘れや取り違えでピルシート上の番号と実際の服用がずれたときに、今日飲むピル番号を手動で合わせ直せます。ホームのピル数字表示からも同じ画面を開けます。 | If your pill number and what you actually took get out of sync, realign today's number in one tap. You can also open this from the pill number on the home screen. |
| `todayPillNumberFeatureAppealPoint1` | 無料で使える番号合わせ機能 | Free, no paywall |
| `todayPillNumberFeatureAppealPoint2` | 設定タブから変更できる | Update it from the Settings tab |
| `todayPillNumberFeatureAppealPoint3` | ホームの数字タップでも開ける | Also reachable by tapping the number |

#### restDuration
| Key | ja | en |
|---|---|---|
| `restDurationFeatureAppealTitle` | 服用お休み期間を記録 | Log a pause in your medication |
| `restDurationFeatureAppealShortDescription` | 休薬・中断を正確に管理 | Track breaks and interruptions |
| `restDurationFeatureAppealHeadline` | ピルの服用をお休みする | Pause your pill schedule |
| `restDurationFeatureAppealBody` | しばらく服用をやめる期間をピルシートに記録できます。お休み中は服用番号が進まず、再開時にすぐ記録を再開できます。 | Record a pause in your medication. The pill number stops advancing while you're on break and resumes the moment you restart. |
| `restDurationFeatureAppealPoint1` | 無料で使える休薬記録 | Free, built into every plan |
| `restDurationFeatureAppealPoint2` | ピルシート右上の歯車から開始 | Start it from the gear on the sheet |
| `restDurationFeatureAppealPoint3` | 期間の編集・再開もかんたん | Easy to edit the range and resume |

## 新規ファイル (20 本)

各 feature ディレクトリ配下に `{feature}_help_page.dart` と `{feature}_announcement_bar.dart`、test も同様。

```
lib/features/feature_appeal/quick_record/quick_record_help_page.dart
lib/features/feature_appeal/quick_record/quick_record_announcement_bar.dart
lib/features/feature_appeal/creating_new_pillsheet/creating_new_pillsheet_help_page.dart
lib/features/feature_appeal/creating_new_pillsheet/creating_new_pillsheet_announcement_bar.dart
lib/features/feature_appeal/alarm_kit/alarm_kit_help_page.dart
lib/features/feature_appeal/alarm_kit/alarm_kit_announcement_bar.dart
lib/features/feature_appeal/today_pill_number/today_pill_number_help_page.dart
lib/features/feature_appeal/today_pill_number/today_pill_number_announcement_bar.dart
lib/features/feature_appeal/rest_duration/rest_duration_help_page.dart
lib/features/feature_appeal/rest_duration/rest_duration_announcement_bar.dart
test/features/feature_appeal/quick_record/quick_record_help_page_test.dart
test/features/feature_appeal/quick_record/quick_record_announcement_bar_test.dart
test/features/feature_appeal/creating_new_pillsheet/creating_new_pillsheet_help_page_test.dart
test/features/feature_appeal/creating_new_pillsheet/creating_new_pillsheet_announcement_bar_test.dart
test/features/feature_appeal/alarm_kit/alarm_kit_help_page_test.dart
test/features/feature_appeal/alarm_kit/alarm_kit_announcement_bar_test.dart
test/features/feature_appeal/today_pill_number/today_pill_number_help_page_test.dart
test/features/feature_appeal/today_pill_number/today_pill_number_announcement_bar_test.dart
test/features/feature_appeal/rest_duration/rest_duration_help_page_test.dart
test/features/feature_appeal/rest_duration/rest_duration_announcement_bar_test.dart
```

## 変更ファイル (6 本)

### 1. `lib/utils/shared_preference/keys.dart`

L35 の `}` 直前に以下 5 件を追加 (document コメント必須)。

```dart
/// クイックレコード (Premium機能: 通知アクションでの服用記録) のアピール Bar を × で閉じたかどうか。
static const quickRecordFeatureAppealIsClosed = 'quickRecordFeatureAppealIsClosed';

/// ピルシートグループ自動追加 (Premium機能) のアピール Bar を × で閉じたかどうか。
static const creatingNewPillSheetFeatureAppealIsClosed = 'creatingNewPillSheetFeatureAppealIsClosed';

/// AlarmKit (Premium機能: iOS 26+) のアピール Bar を × で閉じたかどうか。
static const alarmKitFeatureAppealIsClosed = 'alarmKitFeatureAppealIsClosed';

/// 今日の服用番号変更 (無料機能) のアピール Bar を × で閉じたかどうか。
static const todayPillNumberFeatureAppealIsClosed = 'todayPillNumberFeatureAppealIsClosed';

/// 服用おやすみ (無料機能) のアピール Bar を × で閉じたかどうか。
static const restDurationFeatureAppealIsClosed = 'restDurationFeatureAppealIsClosed';
```

### 2. `lib/features/feature_appeal/feature_appeal_bars_container.dart`

4 箇所を更新:

**(a) import 5 本追加 (L4-11 付近の既存 import と同順で)**

```dart
import 'package:pilll/features/feature_appeal/alarm_kit/alarm_kit_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/creating_new_pillsheet/creating_new_pillsheet_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/quick_record/quick_record_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/rest_duration/rest_duration_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/today_pill_number/today_pill_number_announcement_bar.dart';
```

**(b) L48 の直後に useState 5 本追加**

```dart
final quickRecordIsClosed = useState(sharedPreferences.getBool(BoolKey.quickRecordFeatureAppealIsClosed) ?? false);
final creatingNewPillSheetIsClosed = useState(sharedPreferences.getBool(BoolKey.creatingNewPillSheetFeatureAppealIsClosed) ?? false);
final alarmKitIsClosed = useState(sharedPreferences.getBool(BoolKey.alarmKitFeatureAppealIsClosed) ?? false);
final todayPillNumberIsClosed = useState(sharedPreferences.getBool(BoolKey.todayPillNumberFeatureAppealIsClosed) ?? false);
final restDurationIsClosed = useState(sharedPreferences.getBool(BoolKey.restDurationFeatureAppealIsClosed) ?? false);
```

**(c) useEffect 内の listener 5 本定義 + addListener/removeListener 5 ペア追加** (L97 (`onHealthCareIntegration`) の直後、L106 の `addListener` 末尾と L115 の `removeListener` 末尾に追加)

```dart
void onQuickRecord() {
  sharedPreferences.setBool(BoolKey.quickRecordFeatureAppealIsClosed, quickRecordIsClosed.value);
  if (quickRecordIsClosed.value) markDismissedToday();
}
// creatingNewPillSheet / alarmKit / todayPillNumber / restDuration も同パターン
```

**(d) candidates リスト末尾に 5 件追加 (L128 直後)**

```dart
if (!quickRecordIsClosed.value) QuickRecordAnnouncementBar(isClosed: quickRecordIsClosed),
if (!creatingNewPillSheetIsClosed.value) CreatingNewPillSheetAnnouncementBar(isClosed: creatingNewPillSheetIsClosed),
if (!alarmKitIsClosed.value) AlarmKitAnnouncementBar(isClosed: alarmKitIsClosed),
if (!todayPillNumberIsClosed.value) TodayPillNumberAnnouncementBar(isClosed: todayPillNumberIsClosed),
if (!restDurationIsClosed.value) RestDurationAnnouncementBar(isClosed: restDurationIsClosed),
```

**(e) `hasAnyCandidate` 内のリスト末尾に 5 件追加 (L162 直後)**

```dart
!(sharedPreferences.getBool(BoolKey.quickRecordFeatureAppealIsClosed) ?? false),
!(sharedPreferences.getBool(BoolKey.creatingNewPillSheetFeatureAppealIsClosed) ?? false),
!(sharedPreferences.getBool(BoolKey.alarmKitFeatureAppealIsClosed) ?? false),
!(sharedPreferences.getBool(BoolKey.todayPillNumberFeatureAppealIsClosed) ?? false),
!(sharedPreferences.getBool(BoolKey.restDurationFeatureAppealIsClosed) ?? false),
```

### 3. `lib/features/settings/components/rows/feature_appeal_help_page_list_page.dart`

import 5 本追加 (alphabetical)、`pages` リスト (L19-28) の末尾に以下 5 エントリ追加。

```dart
(label: 'クイックレコード', type: 'premium', routeFactory: QuickRecordHelpPageRoute.route),
(label: 'ピルシート自動追加', type: 'premium', routeFactory: CreatingNewPillSheetHelpPageRoute.route),
(label: 'AlarmKit (iOS 26+)', type: 'premium', routeFactory: AlarmKitHelpPageRoute.route),
(label: '今日の服用番号変更', type: 'free', routeFactory: TodayPillNumberHelpPageRoute.route),
(label: '服用おやすみ', type: 'free', routeFactory: RestDurationHelpPageRoute.route),
```

### 4. `lib/l10n/app_ja.arb`

前述「L10n キー追加」の通り、Title/ShortDescription/Headline/Body の 4×5=20 キーを L2562 直前、Point1/2/3 の 3×5=15 キーを L2597 直後に追加。各キーに `@` 付き description も併記 (既存パターン通り)。

### 5. `lib/l10n/app_en.arb`

ja と同じキー順・同じ位置に英語文言を追加。

### 6. `test/features/feature_appeal/feature_appeal_bars_container_test.dart`

- import 5 本追加
- `expectedBarTypeForIndex` の Type リスト末尾に 5 型追加 (8→13)
- 既存の「全 dismiss → shrink」「hasAnyCandidate の true/false」テストで 13 機能分の setMockInitialValues を更新

## 実装テンプレート (HelpPage Premium / Free)

### Premium 版 雛形 (critical_alert をコピー → 差替え)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/premium_badge.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/home/page.dart';
import 'package:pilll/features/premium_introduction/util/premium_and_trial.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/premium_introduction_sheet.dart';

/// クイックレコード (Premium機能) のアピールページ。
/// 通知アクションから服用記録できる機能を説明し、設定タブに誘導する。
class QuickRecordHelpPage extends ConsumerWidget {
  const QuickRecordHelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.quickRecordFeatureAppealTitle, style: const TextStyle(fontFamily: FontFamily.japanese, color: TextColor.main)),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SvgPicture.asset(
                'images/dots.svg',
                width: 80,
                height: 80,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                l10n.quickRecordFeatureAppealHeadline,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, fontFamily: FontFamily.japanese, color: TextColor.main),
              ),
            ),
            const SizedBox(height: 24),
            _featureCard(Icons.notifications_active, l10n.quickRecordFeatureAppealPoint1),
            const SizedBox(height: 8),
            _featureCard(Icons.touch_app, l10n.quickRecordFeatureAppealPoint2),
            const SizedBox(height: 8),
            _featureCard(Icons.settings, l10n.quickRecordFeatureAppealPoint3),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                Platform.isIOS ? 'images/ios-quick-record.gif' : 'images/android-quick-record.gif',
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.featureAppealLocationLabel,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: TextColor.darkGray),
            ),
            const SizedBox(height: 12),
            _mockTabBar(selectedIndex: 3),
            const SizedBox(height: 8),
            const Center(child: Icon(Icons.arrow_downward, size: 28, color: AppColors.primary)),
            const SizedBox(height: 8),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Row(children: [Text(l10n.quickRecord), const SizedBox(width: 8), const PremiumBadge()]),
                  subtitle: Text(l10n.quickRecordDescription),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            text: l10n.featureAppealTryFeature,
            onPressed: () async {
              final user = ref.read(userProvider).requireValue;
              analytics.logEvent(name: 'feature_appeal_try_tapped', parameters: {
                'feature_key': 'quick_record',
                'feature_type': 'premium',
                'is_paywall_shown': !user.premiumOrTrial ? 1 : 0,
              });
              if (!user.premiumOrTrial) {
                analytics.logEvent(name: 'feature_appeal_paywall_shown', parameters: {'feature_key': 'quick_record'});
                await showPremiumIntroductionSheet(context);
                return;
              }
              ref.read(homeTabControllerProvider)?.animateTo(HomePageTabType.setting.index);
              if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
            },
          ),
        ),
      ),
    );
  }
}

// _mockTabBar / _featureCard は critical_alert_help_page.dart L149-224 と完全同一の実装をコピー

/// FirebaseAnalyticsObserver が自動で screen_view を送信するため、RouteSettings.name は必ず設定する。
extension QuickRecordHelpPageRoute on QuickRecordHelpPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'QuickRecordHelpPage'),
        builder: (_) => const QuickRecordHelpPage(),
      );
}
```

### Free 版 雛形 (health_care_integration をコピー → 差替え)

`userProvider.requireValue` / ペイウォール分岐を削除し、`feature_type: 'free'`, `is_paywall_shown: 0` で analytics を 1 回だけ送信する形。その他は Premium 版と同じ。

### AnnouncementBar 雛形

`critical_alert_announcement_bar.dart` をコピーし、以下のみ差替え:

- クラス名・コンストラクタ
- 遷移先 Route: `{Feature}HelpPageRoute.route()`
- analytics `feature_key` / `feature_type`
- タイトル / 説明 L10n キー: `L.{feature}FeatureAppeal{Title|ShortDescription}`

## AlarmKit 特有の扱い

- **設定行の L10n 化は本タスク範囲外**: `lib/features/settings/components/rows/alarm_kit.dart` の 'アラーム機能' / 'サイレント/集中モードでも...' はハードコードのまま。HelpPage 用 L10n キーのみ新規追加する
- **AnnouncementBar は Platform 判定なし**で candidates に積む: Android / iOS 25 以下でも表示されるが、Headline / Point3 で "iOS 26 以降" を明示するため迷子は発生しない
- **後続タスク候補**: 「alarm_kit.dart の文言 L10n 化」と「Container に `AlarmKitService.isAvailable()` の非同期判定を組み込んで iOS 25 以下で Bar 非表示」

## 実装順序

**各機能の実装直後に必ず「設定タブ > 一番下の debug 画面 (FeatureAppeal HelpPage 一覧)」から新規ページを開き、mobile-mcp または xcodebuildmcp でスクショを撮って UI / 文言 / 遷移を目視確認する**。

1. **インフラ**: `keys.dart` に BoolKey 5 件追加 → `app_ja.arb` / `app_en.arb` に 35 キー追加 → `flutter gen-l10n` → `L.xxx` が解決することを確認
2. **Free 1 機能 (todayPillNumber)**: HelpPage + AnnouncementBar + テスト 2 本 → **`feature_appeal_help_page_list_page.dart` の `pages` に先に追加** → シミュレータで debug 画面から開き、mobile-mcp でスクショ確認 (ヘッダー SVG / Headline / FeatureCard / プレビュー ListTile / ↓矢印の配置、AppBar・戻るボタン、「確認する」タップで setting タブに遷移)
3. **Premium 1 機能 (quickRecord)**: 同上 → debug 画面からスクショ確認。追加で `images/ios-quick-record.gif` / `android-quick-record.gif` が正しく再生されるか、「確認する」ボタンで非 Premium ユーザーならペイウォールが開くか、Premium ユーザーなら setting タブに遷移するか確認
4. **Container 先行登録**: Step 2-3 の 2 機能を `feature_appeal_bars_container.dart` に登録 → container test を 10 件対応に更新 → SharedPreferences 空のフレッシュ起動で AnnouncementBar にローテーション表示されるか mobile-mcp でスクショ確認
5. **残り 3 機能並列**: creatingNewPillSheet / alarmKit / restDuration を Step 2-3 のテンプレートでコピー展開 → 各機能を debug 画面に追加 → 都度スクショ確認
   - alarmKit: iOS 26 未満のシミュレータで Point3 "iOS 26 以降" が視認できるか、遷移先 setting タブで設定行が非表示でも違和感ないか
   - restDuration: record タブに遷移することを確認、歯車 → 服用をお休みする の動線が辿れるか
   - creatingNewPillSheet: SwitchListTile モックと実機設定行が見た目一致しているか
6. **最終 test 更新**: `feature_appeal_bars_container_test.dart` を 13 件対応に (expectedBarTypeForIndex / hasAnyCandidate / shrink テスト)
7. **最終目視**: シミュレータで 5 機能すべての HelpPage を debug 画面から再度開き、スクショを揃えて全機能の UI トーン・文言齟齬がないか総点検

## 検証

### 静的検証
```bash
# L10n 生成
flutter gen-l10n

# 静的解析・フォーマット
flutter analyze
dart format lib test

# テスト
flutter test test/features/feature_appeal/
flutter test

# ビルド
flutter build ios --no-codesign
flutter build apk
```

### シミュレータ目視 (mobile-mcp / xcodebuildmcp でスクショ撮影しながら)

必ず **設定タブの一番下にある debug 画面** (`FeatureAppealHelpPageListPage` — 「FeatureAppeal HelpPage 一覧」) 経由で各ページを開いて検証する。機能 1 つ実装ごとに都度行う (最後にまとめない)。

```
手順:
1. xcodebuildmcp で iOS シミュレータを起動 (iPhone 16 Pro 等)
2. flutter run で dev ビルドを起動
3. 設定タブ (index:3) にスワイプ → 一番下までスクロール → 「FeatureAppeal HelpPage 一覧」をタップ
4. 各機能の行をタップ → HelpPage が開く
5. mobile-mcp の mobile_take_screenshot で撮影 → スクショを Read で開いて以下を確認
   - AppBar タイトル / 戻るボタン
   - ヘッダー SVG (80x80, primary)
   - Headline (22pt w700, 中央)
   - FeatureCard × 3 の Icon と文言が実機能と齟齬なし
   - quickRecord の gif が再生されているか
   - 「アプリ内の場所」ラベル → _mockTabBar で該当タブが選択色 → ↓ 矢印 → プレビュー の順で表示
   - プレビューの ListTile 文言と実機の設定行が一致
   - bottomNavigationBar の「確認する」ボタンが安全領域内に収まり、body 領域が潰れていない
6. 「確認する」ボタンをタップ → mobile-mcp のタップ操作で動作確認
   - Premium 3 機能 (非 Premium ユーザー): ペイウォールが開く
   - Premium 3 機能 (Premium / Trial ユーザー): 設定タブに遷移、HelpPage は pop される
   - Free 2 機能: 該当タブに遷移
7. AnnouncementBar 表示確認: SharedPreferences を空にしたフレッシュ起動でホーム画面の AnnouncementBar が 13 機能のいずれかを表示しているか確認 (日付を変えてローテが動くかも検証)
```

個別に注意する観点:
- **AlarmKit**: iOS 26 未満のシミュレータで HelpPage を開いて Point3 の "iOS 26 以降" 文言が視認できるか、「確認する」で設定タブに遷移後に設定行が非表示でも違和感が無いか
- **restDuration**: 「確認する」で record タブに遷移 (setting ではない)。その後ピルシート右上の歯車から「服用をお休みする」にたどり着けるか手動確認
- **quickRecord の gif**: `Platform.isIOS` で iOS 用 / Android 用が切り替わるので Android シミュレータ (Emulator) でも 1 度目視確認すると良い
- **Feature Card の文言齟齬**: 過去事例 (未実装の「検索」機能を書いた) の再発防止。実ソースの `quick_record.dart` / `creating_new_pillsheet.dart` / `alarm_kit.dart` / `today_pill_number.dart` / rest_duration 系のサブタイトル / description を必ず読んでから Point の文言を決める

## 残課題 (本タスク範囲外)

- `lib/features/settings/components/rows/alarm_kit.dart` の日本語ハードコード 2 箇所の L10n 化
- `_mockTabBar` / `_featureCard` の `lib/features/feature_appeal/components/` への共通化 (13 ページ分のリファクタ)
- iOS 25 以下 / Android で AlarmKit AnnouncementBar を非表示にする判定追加 (必要になれば)

## 重要な規約 (CLAUDE.md / rules より)

- `bottomNavigationBar` 内に `Center` を入れない
- `hasValue` + `SizedBox.shrink()` のローディングガード禁止
- ボタン文言は `L.featureAppealTryFeature` = 「確認する」で統一
- 遷移先はタブ移動のみ (個別ページへの push 禁止)
- `Icons.arrow_downward` (size: 28, primary) を使う (`keyboard_arrow_down` は NG)
- FeatureCard の文言は実機能と齟齬がないか必ず確認
- `ConsumerWidget` を使う (hooks 不要なので `HookConsumerWidget` は避ける)
- 関数の引数は `{required}` でラベル付与
- `ref.watch` は状態同期、`ref.read` は操作系のみ
- analytics イベント名は 40 文字以内、parameters は snake_case

---

## チェックリスト

### 実装内容
- [ ] 変更対象ファイルごとに具体的なコード提案をコードブロックで記載している
- [ ] 既存コードのパターン・構成を確認し、同じパターンで実装している
- [ ] コード生成: `flutter gen-l10n` で L10n 生成ファイル更新
- [ ] 静的解析: `flutter analyze` エラーなし
- [ ] テスト: `flutter test` 全件パス
- [ ] iOS ビルド: `flutter build ios --no-codesign` 成功
- [ ] Android ビルド: `flutter build apk` 成功
- [ ] 新規・変更機能に対するテストが存在する (新規 10 ファイル + container test 更新)
- [ ] Maestro E2E: 該当する maestro flow があれば実行、なければ新規作成
- [ ] 設定タブの debug 画面 (`FeatureAppealHelpPageListPage`) に 5 機能を追加し、シミュレータから都度開いて mobile-mcp / xcodebuildmcp でスクショ確認
- [ ] スクショで全ページの AppBar / Headline / FeatureCard / ↓ 矢印 / プレビュー / 「確認する」ボタン領域のレイアウト崩れがないことを目視確認
- [ ] 「確認する」タップで Premium 3 機能 (非 Premium) ペイウォール表示 / Premium 3 機能 (Premium) タブ遷移 / Free 2 機能 タブ遷移を mobile-mcp のタップ操作で動作確認
- [ ] quickRecord の gif が iOS シミュレータで再生される / Android シミュレータで Android 用 gif が再生されるのを確認
- [ ] AlarmKit を iOS 26 未満シミュレータで開いて Point3 "iOS 26 以降" が見えることを確認
- [ ] AnnouncementBar が 13 機能ローテの 1 つを表示していることをフレッシュ起動で確認
- [ ] Entity命名: フィールド名が省略されていない
- [ ] DB操作: 本タスクでは Firestore 操作なし (該当なし)
- [ ] 引数: 関数・コンストラクタの引数に `{required}` あり (timestamp 等メタデータ除く)
- [ ] ref使い分け: build内は `ref.watch`、コールバック・操作は `ref.read`
- [ ] サブコレクションEntityに親ドキュメントIDフィールドあり (該当なし)
- [ ] エラーメッセージはそのまま表示 (加工・プレフィックス除去なし)

### FeatureAppeal 個別
- [ ] `bottomNavigationBar` 内に `Center` を入れていない
- [ ] `hasValue` + `SizedBox.shrink()` のローディングガードを使っていない
- [ ] ボタン文言が `L.featureAppealTryFeature` で統一
- [ ] 遷移先はタブ移動のみ (個別ページ push なし)
- [ ] 矢印は `Icons.arrow_downward` size:28 / primary
- [ ] FeatureCard の文言が実機能と齟齬なし (AlarmKit の iOS 26+ 条件明記)
- [ ] ConsumerWidget を使用している (HookConsumerWidget ではない)
- [ ] SharedPreferences キー `{feature}FeatureAppealIsClosed` を 5 件追加
- [ ] `feature_appeal_bars_container.dart` の 5 箇所 (import / useState / listener / candidates / hasAnyCandidate) を全て更新
- [ ] `feature_appeal_help_page_list_page.dart` の pages に 5 エントリ追加
- [ ] `feature_appeal_bars_container_test.dart` の expectedBarTypeForIndex と setMockInitialValues を 13 機能対応に更新
- [ ] 既存 8 ページに一切の変更を加えていない
