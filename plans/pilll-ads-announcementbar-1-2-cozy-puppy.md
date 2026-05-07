# pilll-ads AnnouncementBar の集計強化（インプレッション + 広告ID + UTM + BQ ビュー）

## Context

`AnnouncementBar` 内の他企業からの純広告（pilll-ads）について、アフィリエイト案件への対応を見据えてクリック率（CTR）と広告別パフォーマンスを計測可能にする必要がある。

**現状の課題**:
- `pilll_ads.dart` は **タップ/クローズの 4 イベント**を Firebase Analytics に送るだけで、`parameters` を一切付けていない（`destinationURL` も広告 ID も載っていない）
- 兄弟バー（`special_offering.dart` 等）は `useEffect` で `_viewed` イベントを送っているが、pilll_ads だけ抜けている → **CTR が算出できない**
- `PilllAds` Entity に識別子フィールドが無い（`globals/pilll_ads` 単一ドキュメント運用）→ 広告キャンペーン別の集計ができない
- `destinationURL` に UTM 付与なし → 広告主側で Pilll 流入が識別できない
- BigQuery に `pilll_ads` 専用の集計クエリが無い（`paywall_entry_route_conversion.sql` でペイウォール経路として流用されているのみ）

**目的**:
1. インプレッションを送ることで CTR を算出可能にする
2. 広告別の CTR/CVR を取れるよう `pilllAdID` で識別子を付与する
3. アフィリエイトに使えるよう UTM を `destinationURL` に自動付与する
4. BigQuery 側に集計ビュー/クエリを用意して定期 KPI を見られるようにする

---

## 変更対象ファイル

### 1. `lib/entity/pilll_ads.codegen.dart` — `pilllAdID` フィールド追加

既存の Firestore ドキュメント（運用者が Firebase Console で手動管理）にはこのフィールドが無いため、後方互換のため **nullable** にする。CLAUDE.md 規約に従い nullable でも `required` を付ける。命名は `coding-conventions.md` の「省略しない」ルールに従い `pilllAdID`（`adID` だと文脈が消える）。

```dart
@freezed
class PilllAds with _$PilllAds {
  @JsonSerializable(explicitToJson: true)
  factory PilllAds({
    /// 広告の識別子。キャンペーン別の集計に使用される
    /// 既存ドキュメントには存在しないため nullable。Firestore 側で運用者が手動セットする
    required String? pilllAdID,

    /// 広告の表示開始日時
    /// この時刻以降に広告が表示される
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime startDateTime,
    // ... 既存フィールドはそのまま
  }) = _PilllAds;
  PilllAds._();

  factory PilllAds.fromJson(Map<String, dynamic> json) => _$PilllAdsFromJson(json);
}
```

その後、コード生成を実行:

```bash
flutter pub run build_runner build --delete-conflicting-outputs && dart format lib
```

### 2. `lib/features/record/components/announcement_bar/components/pilll_ads.dart` — UI / Analytics / UTM 改修

主な変更:
- `PilllAdsAnnouncementBar` を `HookConsumerWidget` → `ConsumerWidget` に変更（hooks 未使用、`hooks-and-consumer-widget.md` 規約に従う）
- `PilllAdsImageAnnouncementBar` / `PilllAdsTextAnnouncementBar` を `StatelessWidget` → `HookWidget` に変更（`useEffect` でインプレッション送信するため）
- インプレッションイベント `pilll_ads_image_viewed` / `pilll_ads_text_viewed` を `useEffect(() {...}, const [])` 内で送信（`special_offering.dart:21-24` パターン踏襲）
- 既存の 4 イベント（`*_tapped` / `*_is_closed`）と新規 2 イベントの **すべての parameters** に `pilll_ad_id`・`destination_url`・`image_url` を載せる
- UTM 付与は `_pilllAdsLaunchURL` ヘルパーで `destinationURL` の既存 query parameters とマージし、上書きしない方針

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/pilll_ads.codegen.dart';
import 'package:pilll/utils/color.dart';
import 'package:url_launcher/url_launcher.dart';

/// pilll_ads の Analytics parameters を組み立てる
/// すべてのイベント（viewed/tapped/is_closed）で同じスコープの値を載せる
Map<String, Object?> _pilllAdsAnalyticsParameters(PilllAds pilllAds) {
  return {
    'pilll_ad_id': pilllAds.pilllAdID,
    'destination_url': pilllAds.destinationURL,
    'image_url': pilllAds.imageURL,
  };
}

/// destinationURL に UTM パラメータを付与した Uri を返す
/// 既存の query parameters があれば残し、UTM のキーが既に付いていればそちらを優先する
Uri _pilllAdsLaunchURL(PilllAds pilllAds) {
  final base = Uri.parse(pilllAds.destinationURL);
  return base.replace(
    queryParameters: {
      'utm_source': 'pilll',
      'utm_medium': 'announcement_bar',
      'utm_campaign': pilllAds.pilllAdID ?? 'pilll_ads',
      ...base.queryParameters,
    },
  );
}

class PilllAdsAnnouncementBar extends ConsumerWidget {
  final PilllAds pilllAds;
  final VoidCallback onClose;
  const PilllAdsAnnouncementBar({
    super.key,
    required this.pilllAds,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pilllAds.imageURL != null) {
      return PilllAdsImageAnnouncementBar(
        imageURL: pilllAds.imageURL!,
        pilllAds: pilllAds,
        onClose: onClose,
      );
    }
    return PilllAdsTextAnnouncementBar(pilllAds: pilllAds, onClose: onClose);
  }
}

class PilllAdsImageAnnouncementBar extends HookWidget {
  final PilllAds pilllAds;
  final String imageURL;
  final VoidCallback onClose;

  const PilllAdsImageAnnouncementBar({
    super.key,
    required this.pilllAds,
    required this.imageURL,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      analytics.logEvent(
        name: 'pilll_ads_image_viewed',
        parameters: _pilllAdsAnalyticsParameters(pilllAds),
      );
      return null;
    }, const []);

    return Container(
      color: HexColor.fromHex(pilllAds.hexColor),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(
            name: 'pilll_ads_image_tapped',
            parameters: _pilllAdsAnalyticsParameters(pilllAds),
          );
          launchUrl(_pilllAdsLaunchURL(pilllAds));
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: Icon(
                    Icons.close,
                    color: HexColor.fromHex(pilllAds.closeButtonColor),
                    size: 24,
                  ),
                  onPressed: () {
                    analytics.logEvent(
                      name: 'pilll_ads_image_is_closed',
                      parameters: _pilllAdsAnalyticsParameters(pilllAds),
                    );
                    onClose();
                  },
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                ),
                const Spacer(),
                SvgPicture.asset(
                  'images/arrow_right.svg',
                  colorFilter: ColorFilter.mode(
                    HexColor.fromHex(pilllAds.chevronRightColor),
                    BlendMode.srcIn,
                  ),
                  height: 20,
                  width: 20,
                ),
              ],
            ),
            Image.network(imageURL, height: 50),
          ],
        ),
      ),
    );
  }
}

class PilllAdsTextAnnouncementBar extends HookWidget {
  final PilllAds pilllAds;
  final VoidCallback onClose;

  const PilllAdsTextAnnouncementBar({
    super.key,
    required this.pilllAds,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      analytics.logEvent(
        name: 'pilll_ads_text_viewed',
        parameters: _pilllAdsAnalyticsParameters(pilllAds),
      );
      return null;
    }, const []);

    return Container(
      color: HexColor.fromHex(pilllAds.hexColor),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: () {
          analytics.logEvent(
            name: 'pilll_ads_text_tapped',
            parameters: _pilllAdsAnalyticsParameters(pilllAds),
          );
          launchUrl(_pilllAdsLaunchURL(pilllAds));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: const Icon(Icons.close, color: Colors.white, size: 24),
              onTap: () {
                analytics.logEvent(
                  name: 'pilll_ads_text_is_closed',
                  parameters: _pilllAdsAnalyticsParameters(pilllAds),
                );
                onClose();
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  for (final w in pilllAds.description.split('\\n'))
                    Text(
                      w,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset(
              'images/arrow_right.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
```

イベント名長さチェック:
- `pilll_ads_image_viewed` (22 文字) / `pilll_ads_text_viewed` (21 文字) → 40 文字制限内 OK

`@visibleForTesting` を `_pilllAdsLaunchURL` に付けてテストから呼べるようにする。

### 3. `test/features/record/announcement_bar/announcement_bar_test.dart` — 既存テスト更新

`PilllAds(...)` を生成しているすべての箇所（L558, L640, L722, L804, L886, L1286, L1369 ほか）に `pilllAdID: null` を追加。Entity 側で `required` にしたため、欠けるとコンパイルエラーになる。

```dart
pilllAdsProvider.overrideWith(
  (ref) => Stream.value(
    PilllAds(
      pilllAdID: null,                                 // ← 追加
      description: 'これは広告用のテキスト',
      destinationURL: 'https://github.com/bannzai',
      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
      hexColor: '#111111',
      imageURL: null,
    ),
  ),
),
```

少なくとも 1 件は `pilllAdID: 'campaign_2026_05'` を入れたケースを残す（Entity が値を保持できることを確認）。

### 4. `test/features/record/announcement_bar/components/pilll_ads_test.dart` — 新規

`testing.md` に従い「定数が自分自身に等しいことを確認」しないよう、UTM 付与ロジックの unit test と Widget の構造（`HookWidget` で `useEffect` 経由で発火、子 Widget のクラスが想定通りに分岐）の Widget Test を書く。

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pilll_ads.codegen.dart';
import 'package:pilll/features/record/components/announcement_bar/components/pilll_ads.dart';

void main() {
  group('#_pilllAdsLaunchURL', () {
    test('pilllAdID が null の時、utm_campaign は pilll_ads になる', () {
      final pilllAds = PilllAds(
        pilllAdID: null,
        description: 'desc',
        destinationURL: 'https://example.com/lp',
        endDateTime: DateTime(2026, 5, 31),
        startDateTime: DateTime(2026, 5, 1),
        hexColor: 'FF0000',
        imageURL: null,
      );
      final uri = pilllAdsLaunchURLForTest(pilllAds);
      expect(uri.queryParameters['utm_source'], 'pilll');
      expect(uri.queryParameters['utm_medium'], 'announcement_bar');
      expect(uri.queryParameters['utm_campaign'], 'pilll_ads');
    });

    test('pilllAdID が指定されている時、utm_campaign に値が入る', () {
      final pilllAds = PilllAds(
        pilllAdID: 'campaign_2026_05',
        description: 'desc',
        destinationURL: 'https://example.com/lp',
        endDateTime: DateTime(2026, 5, 31),
        startDateTime: DateTime(2026, 5, 1),
        hexColor: 'FF0000',
        imageURL: null,
      );
      final uri = pilllAdsLaunchURLForTest(pilllAds);
      expect(uri.queryParameters['utm_campaign'], 'campaign_2026_05');
    });

    test('destinationURL に既存の query があれば残る（utm_* は付与で上書きされない）', () {
      final pilllAds = PilllAds(
        pilllAdID: 'campaign_2026_05',
        description: 'desc',
        destinationURL: 'https://example.com/lp?ref=abc&utm_campaign=existing',
        endDateTime: DateTime(2026, 5, 31),
        startDateTime: DateTime(2026, 5, 1),
        hexColor: 'FF0000',
        imageURL: null,
      );
      final uri = pilllAdsLaunchURLForTest(pilllAds);
      expect(uri.queryParameters['ref'], 'abc');
      expect(uri.queryParameters['utm_campaign'], 'existing');
      expect(uri.queryParameters['utm_source'], 'pilll');
    });
  });
}
```

`pilll_ads.dart` 側に `@visibleForTesting Uri pilllAdsLaunchURLForTest(PilllAds pilllAds) => _pilllAdsLaunchURL(pilllAds);` を追加する（private 関数を直接 export はせず、テスト用エントリポイントを公開）。

### 5. `PilllBackend/bigquery/views/pilll_ads_events.sql` — 新規

`mart.event_logs` から pilll_ads の 6 イベントを抽出し、`event_params` から `pilll_ad_id` / `destination_url` / `image_url` を unnest して列化する。

```sql
-- pilll_ads 広告のイベントログビュー
-- Source: mart.event_logs (Firebase Analytics 経由)
-- 抽出対象: pilll_ads_{image,text}_{viewed,tapped,is_closed}
CREATE OR REPLACE VIEW `mart.pilll_ads_events`
OPTIONS(description = 'pilll_ads 純広告のインプレッション・タップ・クローズイベント')
AS
SELECT
  eventDateTime,
  event_name AS eventName,
  CASE
    WHEN event_name LIKE '%_viewed' THEN 'impression'
    WHEN event_name LIKE '%_tapped' THEN 'click'
    WHEN event_name LIKE '%_is_closed' THEN 'close'
  END AS eventCategory,
  CASE
    WHEN event_name LIKE 'pilll_ads_image_%' THEN 'image'
    WHEN event_name LIKE 'pilll_ads_text_%' THEN 'text'
  END AS adFormat,
  userID,
  userPseudoID,
  COALESCE(userID, userPseudoID) AS subjectID,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'pilll_ad_id') AS pilllAdID,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'destination_url') AS destinationURL,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'image_url') AS imageURL,
  deviceOS,
  appVersion
FROM `pilll-9afb8.mart.event_logs`
WHERE event_name IN (
  'pilll_ads_image_viewed',
  'pilll_ads_image_tapped',
  'pilll_ads_image_is_closed',
  'pilll_ads_text_viewed',
  'pilll_ads_text_tapped',
  'pilll_ads_text_is_closed'
);
```

### 6. `PilllBackend/bigquery/queries/pilll_ads_daily_kpi.sql` — 新規

日付・広告ID・フォーマット別に impressions/clicks/closes/CTR を集計。

```sql
-- pilll_ads 広告 日別 KPI（impressions, clicks, CTR, close 率）
-- Source: mart.pilll_ads_events
--
-- 目的:
--   広告ID（pilllAdID）ごとに日次の表示・クリック・クローズ数を集計し CTR を出す。
--   アフィリエイト案件の効果測定・媒体別レポートに使用。
--
-- 注意:
--   - mart.event_logs は直近 2 ヶ月のみ
--   - pilllAdID が NULL のイベント（既存 Firestore ドキュメントに ID 未設定）は 'unknown' に集約
SELECT
  DATE(eventDateTime, 'Asia/Tokyo') AS eventDate,
  COALESCE(pilllAdID, 'unknown') AS pilllAdID,
  adFormat,
  COUNTIF(eventCategory = 'impression') AS impressionCount,
  COUNTIF(eventCategory = 'click') AS clickCount,
  COUNTIF(eventCategory = 'close') AS closeCount,
  COUNT(DISTINCT IF(eventCategory = 'impression', subjectID, NULL)) AS uniqueImpressionUserCount,
  COUNT(DISTINCT IF(eventCategory = 'click', subjectID, NULL)) AS uniqueClickUserCount,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(eventCategory = 'click'),
      COUNTIF(eventCategory = 'impression')
    ),
    4
  ) AS ctr,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(eventCategory = 'close'),
      COUNTIF(eventCategory = 'impression')
    ),
    4
  ) AS closeRate
FROM `pilll-9afb8.mart.pilll_ads_events`
GROUP BY eventDate, pilllAdID, adFormat
ORDER BY eventDate DESC, pilllAdID, adFormat;
```

---

## 検証

### dev 動作確認

1. Firebase Console (pilll-dev) → Firestore → `globals/pilll_ads` ドキュメントに以下のフィールドをセット:
   - `pilllAdID`: `"dev_test_2026_05"` (string)
   - `startDateTime`: 過去日時 (timestamp)
   - `endDateTime`: 数日先 (timestamp)
   - `description`: `"テスト広告\nテキスト2行目"`
   - `imageURL`: `null` (テキスト版確認後、画像 URL に切り替えて画像版も確認)
   - `destinationURL`: `"https://example.com/lp?ref=abc"` (既存 query 残存テスト用)
   - `hexColor`: `"FF6B6B"`
2. dev ビルド起動:
   ```
   flutter run --debug -t lib/main.dev.dart --dart-define-from-file=environment/dev.json
   ```
3. 非 Premium / 非 Trial / 連携済み / 有効なピルシート / FeatureAppeal 全 dismiss 状態のユーザーでホーム画面を開く
4. ホーム画面に pilll_ads バーが表示されることを確認（テキスト版 → 画像版に切り替え）
5. デバッグコンソールで以下のログを確認:
   - `[INFO] logEvent name: pilll_ads_text_viewed, parameters: {pilll_ad_id: dev_test_2026_05, destination_url: https://example.com/lp?ref=abc, image_url: null}`
   - タップ時に `pilll_ads_text_tapped` 同パラメータが出ること
   - 起動された URL に `utm_source=pilll&utm_medium=announcement_bar&utm_campaign=dev_test_2026_05&ref=abc` が含まれていること
6. `feedback_ui_verification_with_screenshots.md` に従い mobile-mcp / xcodebuildmcp でホーム画面のスクショを撮影し、バーの表示を目視確認
7. Firebase Analytics DebugView で `pilll_ads_text_viewed` / `pilll_ads_text_tapped` が parameters 付きで届いていることを確認

### コード品質

- `dart run build_runner build --delete-conflicting-outputs` で `pilll_ads.codegen.freezed.dart` / `pilll_ads.codegen.g.dart` を再生成
- `flutter analyze` でエラーなし
- `flutter test test/features/record/announcement_bar/` で全件パス
- `flutter test` で全件パス
- iOS ビルド: `flutter build ios --no-codesign`
- Android ビルド: `flutter build apk`

### BigQuery ビュー検証

- pilll-9afb8 プロジェクトの BQ コンソールで `mart.pilll_ads_events` ビューを作成し、`SELECT * FROM mart.pilll_ads_events LIMIT 10` で結果が出ることを確認
- `pilll_ads_daily_kpi.sql` を BQ で実行し、impression/click/CTR が想定通り出ることを確認（dev 環境からの動作確認イベントが GA4→BQ export されるまで最大 24 時間程度のラグあり）

---

## 重要な変更ファイルパス一覧

| ファイル | 変更種別 |
|---|---|
| `lib/entity/pilll_ads.codegen.dart` | 修正（`pilllAdID` フィールド追加） |
| `lib/entity/pilll_ads.codegen.freezed.dart` | 自動生成更新 |
| `lib/entity/pilll_ads.codegen.g.dart` | 自動生成更新 |
| `lib/features/record/components/announcement_bar/components/pilll_ads.dart` | 修正（hooks 化・parameters・UTM・インプレッション） |
| `test/features/record/announcement_bar/announcement_bar_test.dart` | 修正（既存テスト全箇所に `pilllAdID:` 追加） |
| `test/features/record/announcement_bar/components/pilll_ads_test.dart` | 新規（UTM 付与ロジック unit test） |
| `PilllBackend/bigquery/views/pilll_ads_events.sql` | 新規 |
| `PilllBackend/bigquery/queries/pilll_ads_daily_kpi.sql` | 新規 |

## 既存の再利用ポイント

- インプレッション送信パターン: `lib/features/record/components/announcement_bar/components/special_offering.dart:21-24`
- Analytics ラッパー（snake_case 強制・40 文字 assert）: `lib/utils/analytics.dart`
- 親 `AnnouncementBar` 側の表示判定（変更不要）: `lib/features/record/components/announcement_bar/announcement_bar.dart:202-207`
- BQ ビュー作成テンプレート: `PilllBackend/bigquery/views/event_logs.sql`, `event_logs_feature_appeal.sql`
- BQ クエリヘッダー（仕様コメント記法）: `PilllBackend/bigquery/queries/paywall_entry_route_conversion.sql:1-34`

---

## チェックリスト

### 実装内容
- [ ] 変更対象ファイルごとに具体的なコード提案をコードブロックで記載している
- [ ] 既存コードのパターン・構成を確認し、同じパターンで実装している
- [ ] コード生成: `dart run build_runner build` で生成ファイル更新
- [ ] 静的解析: `flutter analyze` エラーなし
- [ ] テスト: `flutter test` 全件パス
- [ ] iOS ビルド: `flutter build ios` 成功
- [ ] Android ビルド: `flutter build apk` 成功
- [ ] 新規・変更機能に対するテストが存在する（なければ新規作成）
- [ ] Maestro E2E: 該当する maestro flow があれば実行、なければ新規作成
- [ ] Entity命名: フィールド名が省略されていない（`pilllAdID` であり `adID` ではない）
- [ ] DB操作: Firestore 書き込みは無し（運用者が Firebase Console から手動でフィールド追加する想定）
- [ ] 引数: 関数・コンストラクタの引数に `{required}` あり（nullable も含む）
- [ ] ref使い分け: build内は `ref.watch`、コールバック・操作は `ref.read`（本変更では新規 ref 使用なし）
- [ ] サブコレクションEntityに親ドキュメントIDフィールドあり（該当しない、`globals/pilll_ads` 単一ドキュメント）
- [ ] エラーメッセージはそのまま表示（該当箇所なし）
