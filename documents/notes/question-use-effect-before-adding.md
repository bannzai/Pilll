---
scope: repository
recorded: 2026-11-10
---
# useEffect を足す前に、useEffect 無しで書けないかを先に検討する

FeatureAppeal の実装プランに対して、owner から「useEffectは本当に使う必要はありますか？」と訂正された。

その結果の決定は `documents/adr/0001-feature-appeal-design.md` の「3. HelpPage の screen_view を FirebaseAnalyticsObserver に委譲」にある。現物では、`lib/features/feature_appeal/` 配下の各機能の `*_announcement_bar.dart` と `*_help_page.dart` に `useEffect` は 1 つも無い (2026-11-10 に `grep -rn -c "useEffect" lib/features/feature_appeal` で確認。`useEffect` があるのは `feature_appeal_bars_container.dart` の 2 か所だけで、うち 1 つは `AGENTS.md` が許容している SharedPreferences との同期の `addListener`)。

**なぜ:** owner の発言は上の質問だけで、理由は述べられていない。訂正を受けた agent が当時 memory に書いた解釈は「`useEffect` は副作用がいつ走るかがコードから読み取りにくく、依存配列の誤りで 2 回走る・走らないが起きる」。

**どう使う:**

- `PageRoute` で遷移する画面 (FeatureAppeal の HelpPage 等) を開いた時のログは、`useEffect` ではなく Route の `RouteSettings(name: ...)` を設定して `FirebaseAnalyticsObserver` に送らせる (`lib/features/feature_appeal/CLAUDE.md`「Route 定義」)。`lib/app.dart` の `FirebaseAnalyticsObserver(analytics: firebaseAnalytics)` は絞り込みを指定しておらず、firebase_analytics 12.6.1 (`pubspec.lock` の版。2026-11-10 に pub cache の `lib/observer.dart` を読んで確認) の既定は `defaultRouteFilter(Route<dynamic>? route) => route is PageRoute` のため、それ以外には当てはまらない
- `showModalBottomSheet` で出す画面は、開く関数の中で `analytics.logScreenView` を呼ぶ (例: `lib/features/premium_introduction/premium_introduction_sheet.dart`)
- ホームのタブの切り替えは `lib/features/home/page.dart` の `_screenTracking` が記録する
- 押した時に自分の表示を消すだけなら `useState` の値を `onPressed` で書き換える
- それでも `useEffect` が要る時は、なぜ要るかをプランかコードのコメントに 1 行書く
