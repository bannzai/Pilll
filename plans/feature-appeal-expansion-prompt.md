# FeatureAppeal HelpPage 追加タスク プロンプト

このファイルは「別の Claude タスクに HelpPage を追加させるためのプロンプト」です。以下の内容を丸ごとコピーして新しい Claude タスクに渡してください。

---

## タスク内容（Claude にそのまま渡すプロンプト）

Pilll (Flutter) プロジェクトで FeatureAppeal 機能の HelpPage を追加する作業をお願いします。

### 前提・必読ドキュメント

1. **必ず最初に `/Users/bannzai/ghq/github.com/bannzai/pilll/lib/features/feature_appeal/CLAUDE.md` を読んで実装ルールを理解する**
   - ページ構成、レイアウト禁止事項、タブ移動の統一ルール、L10n命名、touch_app アイコンの配置等が書かれている
2. 既存 8 ページの実装を参考にする
   - `lib/features/feature_appeal/{feature}/{feature}_help_page.dart`
   - `lib/features/feature_appeal/{feature}/{feature}_announcement_bar.dart`
3. プロジェクト全体のコーディング規約: `.claude/rules/` 配下のファイル

### 既存 HelpPage（参考・重複しないように確認）

1. critical_alert (Premium) - サイレントモードでも通知を受け取る
2. reminder_notification_customize_word (Premium) - 通知メッセージカスタマイズ
3. appearance_mode_date (Premium) - ピルシート日付表示
4. record_pill (Free) - ピル記録・服用履歴
5. menstruation (Free) - 生理記録
6. calendar_diary (Free) - カレンダー・日記
7. future_schedule (Free) - 未来の予定
8. health_care_integration (Free) - ヘルスケア連携

### 追加候補の機能（優先度順・必要に応じて取捨選択）

以下の機能は HelpPage 未実装。実装前に **本当に HelpPage が必要な機能か判断してから作業する** こと。不要なら追加しない。

1. **クイックレコード (Premium)**
   - ファイル: `lib/features/settings/components/rows/quick_record.dart`
   - 内容: 通知画面から直接ピルを服用記録できる
   - 遷移先タブ: 設定タブ

2. **ピルシートグループの自動追加 (Premium)**
   - ファイル: `lib/features/settings/components/rows/creating_new_pillsheet.dart`
   - 内容: ピルシートグループが終了したら自動で新しいシートを追加
   - 遷移先タブ: 設定タブ

3. **AlarmKit (Premium / iOS のみ)**
   - ファイル: `lib/features/settings/components/rows/alarm_kit.dart`
   - 内容: iOS 26+ の AlarmKit を使った通知
   - 遷移先タブ: 設定タブ

4. **休薬期間通知 / 通知時間カスタマイズ**
   - 機能説明の価値があるか要判断（基本的な通知設定なので優先度低）

5. **データ移行・アカウント連携**
   - `lib/features/settings/components/rows/account_link.dart`
   - 機種変更時のデータ引き継ぎ。ユーザー訴求価値あり
   - 遷移先タブ: 設定タブ

6. **表示番号カスタマイズ (beginPillNumber/endPillNumber)**
   - ピルシートの表示開始・終了番号を変えられる。優先度低〜中

### 作業手順（1機能あたり）

1. **既存機能の実装を調査**: 機能のコード・UI・設定行の実装を読む
2. **HelpPage 追加が妥当か判断**: ユーザー訴求価値があるか。なければスキップ
3. **ディレクトリ作成**: `lib/features/feature_appeal/{feature_snake_case}/`
4. **HelpPage 作成**: 既存ページ（例: `critical_alert/critical_alert_help_page.dart`）をコピーして改変
   - Premium 機能なら Premium チェック付き
   - `_mockTabBar(selectedIndex: ...)` で該当タブを選択表示
   - `ref.read(homeTabControllerProvider)` でタブ移動
5. **AnnouncementBar 作成**: 既存（例: `critical_alert/critical_alert_announcement_bar.dart`）をコピーして改変
6. **L10n 追加**: `lib/l10n/app_ja.arb` と `lib/l10n/app_en.arb` に以下のキーを追加
   - `{feature}FeatureAppealTitle`
   - `{feature}FeatureAppealHeadline`
   - `{feature}FeatureAppealBody`（将来用）
   - `{feature}FeatureAppealPoint1/2/3`
   - AnnouncementBar 用: `{feature}AnnouncementBarTitle`, `{feature}AnnouncementBarDescription`
7. **L10n 生成**: `flutter gen-l10n`
8. **FeatureAppealBarsContainer に登録**: `lib/features/feature_appeal/feature_appeal_bars_container.dart` の候補リストに追加
9. **開発者オプションに登録**: `lib/features/settings/components/rows/feature_appeal_help_page_list_page.dart` の `pages` リストに追加
10. **テスト作成**: `test/features/feature_appeal/{feature}/{feature}_help_page_test.dart` と `{feature}_announcement_bar_test.dart` を既存に倣って作成
11. **検証**:
    - `flutter analyze lib/features/feature_appeal/` で error/warning なし
    - `flutter test test/features/feature_appeal/` で全パス
    - シミュレータで HelpPage の表示・タブ移動を確認（開発者オプション経由）

### 重要な規約まとめ（CLAUDE.md より抜粋・必ず遵守）

- **`bottomNavigationBar` 内に `Center` を入れない**（body が 0 高さになる）
- **`hasValue` + `SizedBox.shrink()` のローディングガード禁止**
- **ボタン文言は `L.featureAppealTryFeature` =「確認する」**
- **遷移先はタブ移動のみ**（個別ページへの push は禁止）
- **`Icons.arrow_downward`（size:28, primary）を使う**（`keyboard_arrow_down` は NG）
- **touch_app アイコンは対象の下側に配置**
- **Feature Card の文言は実機能と齟齬がないか必ず確認**（過去の事例: 未実装の「検索」機能が記載されていた）

### 成果物

- 新規 HelpPage 一式（HelpPage + AnnouncementBar + L10n + 登録 + テスト）
- どの機能を追加したか、なぜその機能を選んだかのサマリ
- 検証結果（analyze/test/シミュレータ確認）のスクリーンショット

### 禁止事項

- 既存 8 ページを変更しない（このタスクは「追加」のみ）
- CLAUDE.md のルールを破らない
- 実機能と齟齬のある説明文を書かない

### 質問・判断に迷ったら

- AskUserQuestion で user に確認
- 実装前にどの機能を追加対象とするか提案 → 承認を得てから実装

---

## このプロンプトを使う側の注意（bannzai 用メモ）

- 上記の「タスク内容」セクションを新しい Claude Code セッションに貼り付ける
- 必要に応じて追加したい機能を絞り込んでから渡す（例: 「クイックレコードだけ追加して」）
- 完了後は `/commit-create-pr` で PR を作成させる
