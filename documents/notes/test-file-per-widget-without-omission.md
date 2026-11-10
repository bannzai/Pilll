---
scope: repository
recorded: 2026-11-10
---
# 新しい Widget・Page・関数を置いた実装ファイルごとに対応するテストファイルを書き、「代表の 1 ファイルだけ」「リスクが低い」「重複が多い」を省く理由にしない

FeatureAppeal の実装プランに対して、owner から次の訂正を受けた。

- 「「代表 1 ファイルだけ作る。残り 7 機能はリスクが低いのでテスト省略」良いわけがない。ちゃんと書きましょう」

現物は lib と test が 1 対 1 になっている (2026-11-10 に確認)。`lib/features/feature_appeal/critical_alert/` の `critical_alert_announcement_bar.dart`・`critical_alert_help_page.dart` に対して、`test/features/feature_appeal/critical_alert/` に `critical_alert_announcement_bar_test.dart`・`critical_alert_help_page_test.dart` があり、他の機能のディレクトリも同じ並びになっている。

**なぜ:** Pilll は日付の計算と状態の分岐が多く、機能ごとのテストが無いと改修の時に壊れたことに気づけない。同じ形のテストが並ぶことは、テストを省く理由として認められなかった。

**どう使う:**

- プランの段階で「16 個の実装ファイルに 16 個のテストファイル」のように 1 対 1 で書き出す。単位は実装ファイルで、1 つの実装ファイルにある Widget と関数のテストは同じテストファイルに書く (例: `feature_appeal_bars_container.dart` と `feature_appeal_bars_container_test.dart`)
- プランと PR 本文に「リスクが低いので省略」「代表の 1 ファイル」と書かない
- テストの中身と置き場所は `AGENTS.md`「プログラムテストについて」に従う (操作ではなく状態を用意して表示を検証する。ディレクトリは lib と同じ階層にする)
