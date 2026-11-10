# リポジトリのメモ

- [似た機能が並ぶ設計では、共通テンプレートやデータの入れ物より先に、機能ごとの個別の Widget・Page・SharedPreferences のキーを提案する](individual-widgets-over-shared-templates.md) — 似た形の機能を複数足す設計・プランを書く時
- [新しい Widget・Page・関数には 1 つずつテストファイルを書き、「代表の 1 ファイルだけ」「リスクが低い」「重複が多い」を省く理由にしない](test-file-per-widget-without-omission.md) — テストの範囲をプランに書く時、テストを省きたくなった時
- [useEffect を足す前に、useEffect 無しで書けないかを先に検討する](question-use-effect-before-adding.md) — flutter_hooks の `useEffect` を新しく書こうとした時
- [画面の確認は、開発用ビルドの設定タブ末尾にある開発者向けの項目から目的の画面へ入り、初期設定へ戻す時は「COPY DEBUG INFO」をダブルタップする](developer-options-in-settings-tab-for-verification.md) — Simulator で画面を確認する時、初期設定からやり直したい時
