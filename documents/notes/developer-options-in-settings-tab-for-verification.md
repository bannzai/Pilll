---
scope: repository
recorded: 2026-11-10
---
# 画面の確認は、開発用ビルドの設定タブ末尾にある開発者向けの項目から目的の画面へ入り、初期設定へ戻す時は DebugRow (日本語の表示は「COPY DEBUG INFO」) をダブルタップする

開発用ビルド (`Environment.isDevelopment` が true。`lib/main.dev.dart` で起動したもの) の設定タブには、本番ビルドに出ない項目がある (2026-11-10 にコードで確認)。

- 設定タブ末尾の「開発者オプション」の節 (`lib/features/settings/page.dart` の `SettingSection.developer`。並ぶ項目はこの case が正): FeatureAppeal の全 HelpPage への一覧 (`FeatureAppealHelpPageListRow`) などがある
- `DebugRow` (`lib/features/settings/components/rows/debug_row.dart`。`SettingSection.other` の節の末尾で、「開発者オプション」の節の直前にある。表示は `L.copyDebugInfo` で言語ごとに変わり、日本語は「COPY DEBUG INFO」、英語は「Copy debug info」。Semantics の identifier は `debug_row`): タップでデバッグ情報をコピー、ダブルタップでサインアウトの確認ダイアログ、長押しでユーザー削除の確認ダイアログを出す

サインアウトの中身は `lib/main.dev.dart` の `Environment.signOutUser` で、`BoolKey.didEndInitialSetting` を false に戻し、予約済みのリマインダーのローカル通知を取り消してから `FirebaseAuth.instance.signOut()` を呼ぶ。AlarmKit のリマインダーは取り消さない (同関数のコメント「local notificationのみ解除」)。ダイアログの文言は「サインアウトあとはアプリを再起動してお試しください。初期設定から始まります」。

**なぜ:** `flutter analyze` と `flutter test` は、レイアウトの崩れ・文言の食い違い・遷移の動きを検知しない (`lib/features/feature_appeal/CLAUDE.md` に、`bottomNavigationBar` の中の `Center` で body の高さが 0 になる例と、未実装の「検索」を Feature Card に書いた例がある)。ダブルタップと長押しは `GestureDetector` のハンドラーで、画面には `L.copyDebugInfo` の文字しか出ない。

**どう使う:**

- 新しいページは作りかけでも開発者向けの一覧 (HelpPage なら `feature_appeal_help_page_list_page.dart` の `pages`) に足し、1 機能を実装するたびに開いてスクリーンショットで文言・レイアウト・他機能との食い違いを見る。最後にまとめて確認しない
- 初期設定からやり直す時は、`DebugRow` をダブルタップしてサインアウトし、アプリを起動し直す。日本語以外の表示は `lib/l10n/app_<言語コード>.arb` の `copyDebugInfo` で確かめる
- 確認に使う Simulator は `AGENTS.md`「プログラムテスト方針」の指定 (simtunnel) に従う
