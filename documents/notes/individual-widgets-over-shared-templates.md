---
scope: repository
recorded: 2026-11-10
---
# 似た機能が並ぶ設計では、共通テンプレートやデータの入れ物より先に、機能ごとの個別の Widget・Page・SharedPreferences のキーを提案する

FeatureAppeal の実装プランに対して、owner から次の訂正を受けた。

- 「class FeatureAppealのような中間表現は不必要なら作らない。便利という理由では定義しない。追いづらくなります」
- 「FeatureAppealHelpPage のように共通化しない」「個別のコンポーネントを作ること」
- 「SharedPreferencesのKeyも個別のkeyをconstで定義すること」

決定の内容と理由は `documents/adr/0001-feature-appeal-design.md` の「1. 中間表現クラスを作らず、機能ごとに独立Widgetを作る」にある。現物もそのとおりになっている (2026-11-10 に確認)。

- `lib/features/feature_appeal/<機能>/` に機能ごとの `*_announcement_bar.dart` と `*_help_page.dart` がある
- `lib/utils/shared_preference/keys.dart` に `criticalAlertFeatureAppealIsClosed`・`menstruationFeatureAppealIsClosed` のように機能ごとの const がある
- 複数の Bar から 1 つを選ぶ `FeatureAppealBarsContainer` (`lib/features/feature_appeal/feature_appeal_bars_container.dart`) だけが上位の Widget としてある

**なぜ:** owner の理由は上の発言の「便利という理由では定義しない。追いづらくなります」。ADR 0001 は FeatureAppeal の決定として書かれているが、FeatureAppeal に限らない設計の好みとして扱う (この扱いと下の「どう使う」は、訂正を受けた agent が当時 memory に書いた解釈で、owner の発言の引用ではない)。

**どう使う:**

- プランで `XxxCatalog`・`XxxEntry`・`XxxConfig` のような入れ物や、`XxxHelpPage(content: ...)` のような共通テンプレートを書きたくなったら、機能ごとに別ファイルの Widget・Page・const のキーを作る案を先に出す
- SharedPreferences のキーは `'feature_appeal_${key}_dismissed'` のように組み立てず、機能ごとの const で宣言する
- 個別の Widget をまとめて選択や優先度の判定を担う上位の Widget は作ってよい (現物に `FeatureAppealBarsContainer` がある)
- 入れ物の class を足す時は、継承・Freezed・JsonSerializable・フレームワークの要求のような必然性をプランに書く
