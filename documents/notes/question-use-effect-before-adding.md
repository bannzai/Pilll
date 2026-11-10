---
scope: repository
recorded: 2026-11-10
---
# useEffect を足す前に、useEffect 無しで書けないかを先に検討する

FeatureAppeal の実装プランに対して、owner から「useEffectは本当に使う必要はありますか？」と訂正された。

その結果の決定は `documents/adr/0001-feature-appeal-design.md` の「3. HelpPage の screen_view を FirebaseAnalyticsObserver に委譲」にある。現物では、`lib/features/feature_appeal/` 配下の各機能の `*_announcement_bar.dart` と `*_help_page.dart` に `useEffect` は 1 つも無い (2026-11-10 に `grep -rn -c "useEffect" lib/features/feature_appeal` で確認。`useEffect` があるのは `feature_appeal_bars_container.dart` の 2 か所だけで、うち 1 つは `AGENTS.md` が許容している SharedPreferences との同期の `addListener`)。

**なぜ:** `useEffect` は副作用がいつ走るかがコードから読み取りにくく、依存配列の誤りで 2 回走る・走らないが起きる。owner は、別の書き方があるならそちらを選ぶ。

**どう使う:**

- 画面を開いた時のログは、`useEffect` ではなく Route の `RouteSettings(name: ...)` を設定して `FirebaseAnalyticsObserver` に送らせる (`lib/features/feature_appeal/CLAUDE.md`「Route 定義」)
- 押した時に自分の表示を消すだけなら `useState` の値を `onPressed` で書き換える
- それでも `useEffect` が要る時は、なぜ要るかをプランかコードのコメントに 1 行書く
