# 0001. FeatureAppealの設計

## Status

Accepted

## Context

トライアル期間中のユーザーがPilllの有料機能と認証機能をほとんど触っていないことが課題になっていた。
ホーム画面 (RecordPage) のAnnouncementBar領域は当時「トライアル期間 x 日目」が優先的に占有しており、機能訴求に使われていなかった。

要件として以下が示された:

- 認証 / 有料機能 / 無料機能 をローテーションで紹介する「FeatureAppeal」をAnnouncementBarに導入
- タップでヘルプページに遷移し、その場で実機能を試せる導線を作る
- 同日に1種類のみ表示し、× ボタンで「以降表示しない」を永続化
- BigQueryで課金率・機能利用率・継続率の効果測定ができるようイベントを追加

導入する機能は8つ (有料3つ・無料5つ)、それぞれBar Widget・HelpPage Widget・dismissed key・analyticsイベント・ナビゲーション処理が必要になる。
これらをどう設計するかについて、いくつかの選択肢がトレードオフを伴って存在した。

## Decision

以下の5つの設計決定を採用する。

### 1. 中間表現クラスを作らず、機能ごとに独立Widgetを作る

`class FeatureAppeal` のようなデータコンテナを作って `featureAppealCatalog` のconst配列で管理する案を一度検討したが、廃止する。
代わりに 8機能 × (Bar Widget + HelpPage Widget) = 16個の独立したWidgetをそれぞれ別ファイルで作る。
SharedPreferences key も機能ごとに個別の `const` で `BoolKey` extension に追加する (動的に組み立てた `'feature_appeal_${key}_dismissed'` のような複合キーは使わない)。
共通化したのは「複数のBarから1つを選ぶコンテナ」のみ (`FeatureAppealBarsContainer`)。これは共通化テンプレートではなく、個別Barをまとめる選択ロジックを担うWidget。

**Why:**

- 中間表現を作ると「データと振る舞いが分離する」「ジャンプ先が増える」「リファクタ時の影響範囲が広い」など、後から追いづらくなる
- 機能を追加・削除する際の変更箇所が局所化しない (catalog の中身、データ駆動のswitchロジック、L10n、テスト、navigationヘルパー全部を行ったり来たりする必要がある)
- 「機能ごとのファイル/Widget/Key」という素直な構造の方が、新しい機能を追加・削除するときに変更箇所がディレクトリ単位で完結する

### 2. 「同日1種類・日跨ぎローテーション」を決定論的計算で達成

「今日表示済みの feature_key」を保持するグローバルなSharedPreferences keyは作らない。
代わりに `FeatureAppealBarsContainer` 内で `daysBetween(_featureAppealEpoch, today()) % candidates.length` で当日表示するindexを決定する。

- 同じ日に何度ビルドしても同じ index が選ばれる → 「同日1種類」を満たす
- 翌日には index が +1 → 別の候補に切り替わる → 「日跨ぎローテーション」を満たす
- ユーザーが × で1つを dismiss すると candidates が縮み、自動的に異なる候補が表示される

**Why:**

- 「今日見たkey」と「dismiss key」の二重管理を避ける (Single Source of Truth)
- グローバルな日付付きcomposite key (`'2026-04-11:critical_alert'` など) を作るより、各機能の dismissed key だけで両方の要件を満たせる
- 副作用なしの純関数で計算できるため、テストで `today()` を mock するだけで網羅的に検証できる

### 3. HelpPage の screen_view を FirebaseAnalyticsObserver に委譲

各 HelpPage の `useEffect` で `analytics.logScreenView(screenName: ...)` を手動で呼ぶのではなく、`Route extension` の `RouteSettings(name: 'CriticalAlertHelpPage')` で名前を設定するだけにする。
`lib/app.dart` で MaterialApp の `navigatorObservers` に登録された `FirebaseAnalyticsObserver` が自動で screen_view を送信する。

**Why:**

- HelpPage 側の `useEffect` を完全に排除でき、`ConsumerWidget` で実装できる (`HookConsumerWidget` 不要)
- screen_view 送信の責務を1箇所 (`lib/app.dart`) に集約できる
- 将来別の画面を追加したときも、Route に名前を付けるだけで自動的に screen_view が送信される統一的な仕組みになる
- 副作用フックの数が減ると、何が副作用なのかが追いやすくなる
- Bar Widget 側は viewed イベントを送らない設計にすることで、Bar も `StatelessWidget` で実装でき、ファネル分析の上端は `tapped` になる (CTRは別途算出不可だが、useEffect 廃止のメリットを優先)

### 4. homeTabControllerProvider (StateProvider) で TabController を外部公開

無料機能のヘルプページから「実際に試す」を押した際に、ホームの該当タブ (record / menstruation / calendar / setting) に切り替える必要がある。
このため `lib/features/home/page.dart` に `final homeTabControllerProvider = StateProvider<TabController?>((ref) => null);` を追加し、`HomePageBody.build` の `useEffect` で TabController を Provider に登録する (dispose時はnullに戻す)。
無料機能ヘルプページの `onPressed` では `Navigator.of(context).popUntil((r) => r.isFirst)` でホームまで戻り、 `ref.read(homeTabControllerProvider)?.animateTo(HomePageTabType.<対応>.index)` でタブ切替する。

**Why:**

- HomePage の TabController は `useTabController` で生成された hook 内部の値であり、外部から触る正規の手段がない
- callback を子孫に渡す方式 (props drilling) は CLAUDE.md の「コールバックは使わない、ValueNotifier を共有する」方針に反する
- グローバル singleton を作るよりも Riverpod の StateProvider を使う方がライフサイクルが管理しやすい
- `StateProvider<TabController?>` は CLAUDE.md の `StateNotifier`/`ChangeNotifier` 禁止ルールには該当しない (Riverpod 標準のStateProviderは別物)

### 5. AnnouncementBar の優先度: 認証 → FeatureAppeal → 既存フォールバック (ただし実利用警告系は保護)

非Premiumユーザーの優先度を以下に変更:

```text
DiscountPriceDeadline (実利用警告)
→ EndedPillSheet     (実利用警告)
→ FeatureAppealBarsContainer             (★ 機能アピール・候補あり & 当日未閉じ)
→ PremiumTrialLimitAnnouncementBar       (トライアル残り10日以内)
→ RecommendSignupGeneralAnnouncementBar  (★ 認証推奨・未認証時)
→ PremiumTrialLimitAnnouncementBar       (トライアル残り10日以上)
→ PilllAds / SpecialOffering / AdMob     (既存)
```

Premiumユーザーの優先度:

```text
LifetimeSubscriptionWarning  (既存)
→ RecommendSignupForPremium  (既存)
→ RestDuration               (実利用警告)
→ EndedPillSheet             (実利用警告)
→ FeatureAppealBarsContainer (★ 機能アピール・候補あり & 当日未閉じ)
```

**Why:**

- 機能訴求を最優先とし、全dismiss or 当日×で閉じた場合にのみ認証推奨にフォールバックする
- トライアル期限が10日以内に迫っている場合は認証推奨より優先する (ユーザーがアクションすべき期限が近い)
- トライアル期限まで余裕がある (10日以上) 場合は、認証推奨の方が優先度が高い
- 実利用警告系 (DiscountPriceDeadline・EndedPillSheet・RestDuration) は「ユーザーが今すぐ何かするべき」というアクション要請であり、すべてのFeatureAppeal/認証推奨より優先度が高い

### 6. 当日 dismiss 判定: FeatureAppeal を × で閉じたら残りの当日は再表示しない

FeatureAppeal の Bar を × で閉じた際に `featureAppealLastDismissedDate` (ISO 8601) を SharedPreferences に保存する。
AnnouncementBar 構築時に `isSameDay(featureAppealLastDismissedDate, today())` で当日かどうかを判定し、当日なら FeatureAppeal をスキップしてフォールバック (認証推奨 or トライアル期限) に進む。

**Why:**

- 「1日1種類」の設計意図に合致: × で閉じた後に別の機能訴求を即座に表示するのはユーザー体験として押し付けがましい
- 翌日になると `isSameDay` が false になり、自動的に次の候補が表示される
- グローバルな日付付き composite key を作るのではなく、シンプルな「最後に閉じた日付」1本で判定できる

## Consequences

### Good

- 機能を追加・削除する際にディレクトリ単位 (`lib/features/feature_appeal/<feature>/`) で変更が完結する。Bar/HelpPage/test の4ファイルだけ作って `FeatureAppealBarsContainer` の `candidates` リストに1行追加すれば終わる
- グローバル「shown today」key が無いため、SharedPreferences の状態管理がシンプル
- HelpPage 側に `useEffect` がなく、実装が宣言的でテストしやすい
- BigQueryクエリ (`feature_appeal_funnel.sql` など) も `STRUCT` の配列で featureKey と HelpPage 名を対応付けるだけで済む
- 既存の実利用警告系の挙動が保護されているため、リグレッションが小さい
- 当日 dismiss 判定が `featureAppealLastDismissedDate` 1本で済むため、「今日見たkey」と「dismiss key」の二重管理が不要
- PremiumTrialLimit の10日閾値分割により、期限間近のユーザーには適切に緊急性を伝えつつ、余裕があるユーザーには機能訴求/認証推奨を優先できる

### Bad

- ファイル数が多い (Flutter側で 18ファイル新規 + 6ファイル変更、テストも18ファイル新規)
- 8機能の Bar/HelpPage は構造がほぼ同じで重複コードに見える。共通化すれば数百行削減できるが、その代わりに「追いやすさ」を失う
- ファネル分析の上端を `tapped` にしたため、CTR (impression → click) は別途算出不可。 viewed が必要になった時には改めて useEffect を追加する必要がある
- BigQuery の `featureKey → HelpPage 名` マッピング (`feature_appeal_funnel.sql` 内の STRUCT 配列) と Flutter の Bar/HelpPage 実装の同期を運用ルールで担保する必要がある (片方だけ更新すると不整合になる)
- `homeTabControllerProvider` は HomePageBody がまだ build されていない瞬間 (起動直後など) は null。 `?.animateTo` で no-op として扱う前提で、無料機能ヘルプページから即タブ切替できないエッジケースは存在する
