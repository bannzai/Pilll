---
feature: _root
verification: mobile-mcp
last_verified_commit: null
last_verified_at: null
---

# QA 全体ガイド

## 対象環境

- Firebase project: `pilll-dev`（dev 環境）に対して QA を行う。prod (`pilll-9afb8`) には行わない
  - Android: `android/app/src/dev/google-services.json` の `project_id: pilll-dev`
  - iOS: `ios/Firebase/GoogleService-Info-dev.plist` の `PROJECT_ID: pilll-dev`
- ビルド種別: デバッグビルド（`Environment.flavor = Flavor.DEVELOP`, `lib/main.dev.dart`）
  - `Environment.isDevelopment` が true になり、設定画面からアカウント削除・サインアウト等の開発者専用デバッグ操作が使える
- flavor には `LOCAL`（`lib/main.local.dart`、Firebase emulator 接続）もあるが、実機の Firebase dev プロジェクトで確認したいため QA では `DEVELOP` を対象とする

## 起動方法

1. `/sim-manager` skill 経由で project 固有のシミュレータを起動する（`sim-boot`）
2. 依存取得: `flutter pub get`
3. dev ビルドを起動:
   ```
   flutter run --debug -t lib/main.dev.dart --dart-define-from-file=environment/dev.json
   ```
   - `-t lib/main.dev.dart`: dev flavor のエントリーポイント
   - `--dart-define-from-file=environment/dev.json`: dev 用の dart-define 一式（`environment/dev.json` は secret 化されており repo には実体が無い。`Makefile` の `make secret` ターゲット、または各自の手元の値を使う）
   - CI (`.github/workflows/ci.yml`) の `build-ios-debug` / `build-android-debug` と同じ target/dart-define を使用しており、この組み合わせが dev 環境向けの正規のビルド方法

## ログイン方法

- アプリ起動時に `lib/provider/auth.dart` の `firebaseSignInOrCurrentUserProvider` が自動的に `FirebaseAuth.instance.signInAnonymously()` を呼ぶため、追加の認証情報なしで匿名ユーザーとして起動できる。これを QA の基本の入り口として推奨する
- Apple / Google アカウントとの連携（`lib/features/sign_in/sign_in_sheet.dart`）を確認する場合は、実機・シミュレータにサインイン済みの Apple ID / Google アカウントを使う。テストアカウントの認証情報はここに書かない（必要な場合はパスワードマネージャ等の参照のみとし、担当者に確認する）
- dev ビルドには開発者専用の「アカウント削除」「サインアウト」操作がある（`lib/main.dev.dart` の `Environment.deleteUser` / `Environment.signOutUser`、設定画面から呼び出し）。ログイン状態をリセットして初期設定フローから QA したい場合はこれを使う

## 動作確認手段

- iOS シミュレータの起動・管理: `/sim-manager`（`sim-boot` / `sim-list` / `sim-shutdown`）
- シミュレータ上での UI 操作・スクリーンショット確認: `/verify-ui-mobile-mcp`（mobile-mcp 経由）
- QA.md に基づく一連の動作確認の実行・記録: `/run-qa`
- Maestro E2E フロー（`.maestro/` 配下）がある場合は `/maestro-flutter` を併用する

## 横断確認項目

## 1. 起動・アカウント

- [ ] **匿名起動**: アプリを新規インストール・起動すると匿名ユーザーとして自動サインインし、初期設定フローに進める
- [ ] **初期設定完了**: 初期設定（`lib/features/initial_setting/`）を最後まで完了すると、ホーム画面に到達しピルシートが表示される
- [ ] **Apple/Google 連携**: `sign_in_sheet` から Apple または Google と連携すると、匿名アカウントのデータを引き継いだまま連携済み状態になる
- [ ] **サインアウト/再起動後の復元**: アプリを終了して再起動しても、直前のログイン状態・データが保持されている

## 2. 通知・権限

- [ ] **通知権限許可**: 初回起動時またはリマインダー設定時に通知許可ダイアログが表示され、許可するとリマインダー通知が有効になる
- [ ] **服用リマインダー通知**: 設定した時刻にローカル通知（`flutter_local_notifications`）が届き、通知から服用記録ができる

## 3. 課金・プレミアム

- [ ] **プレミアム導線表示**: 非プレミアムユーザーに `premium_introduction` への導線（プラン一覧・価格表示）が正しく表示される
- [ ] **課金ゲート**: プレミアム限定機能が非プレミアムユーザーには制限され、購入後に解放される

## 4. コアデータ操作

- [ ] **服用記録**: `record` からピルの服用記録・取り消しができ、ピルシートの表示に反映される
- [ ] **生理記録**: `menstruation` から生理の記録・編集ができる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **服用記録**: `record` からピルの服用記録・取り消しができ、ピルシートの表示に反映される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **生理記録**: `menstruation` から生理の記録・編集ができる

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

## 機能別 QA.md

重要・高頻度な機能から順に記載する。

- [lib/features/record/QA.md](lib/features/record/QA.md) — ピルの服用記録・取り消し（コア機能）
- [lib/features/home/QA.md](lib/features/home/QA.md) — ホーム画面（ピルシート表示の起点）
- [lib/features/settings/QA.md](lib/features/settings/QA.md) — 設定（アカウント・通知・各種設定の起点）
- [lib/features/menstruation/QA.md](lib/features/menstruation/QA.md) — 生理記録
- [lib/features/initial_setting/QA.md](lib/features/initial_setting/QA.md) — 初期設定（新規ユーザーの導線）
- [lib/features/before_pill_sheet_group_history/QA.md](lib/features/before_pill_sheet_group_history/QA.md)
- [lib/features/calendar/QA.md](lib/features/calendar/QA.md)
- [lib/features/diary_post/QA.md](lib/features/diary_post/QA.md)
- [lib/features/diary_setting_physical_condtion_detail/QA.md](lib/features/diary_setting_physical_condtion_detail/QA.md)
- [lib/features/feature_appeal/QA.md](lib/features/feature_appeal/QA.md)
- [lib/features/inquiry/QA.md](lib/features/inquiry/QA.md)
- [lib/features/menstruation_edit/QA.md](lib/features/menstruation_edit/QA.md)
- [lib/features/menstruation_list/QA.md](lib/features/menstruation_list/QA.md)
- [lib/features/pill_sheet_modified_history/QA.md](lib/features/pill_sheet_modified_history/QA.md)
- [lib/features/premium_introduction/QA.md](lib/features/premium_introduction/QA.md)
- [lib/features/release_note/QA.md](lib/features/release_note/QA.md)
- [lib/features/reminder_notification_customize_word/QA.md](lib/features/reminder_notification_customize_word/QA.md)
- [lib/features/reminder_times/QA.md](lib/features/reminder_times/QA.md)
- [lib/features/schedule_post/QA.md](lib/features/schedule_post/QA.md)
- [lib/features/sign_in/QA.md](lib/features/sign_in/QA.md)
- [lib/features/special_offering/QA.md](lib/features/special_offering/QA.md)
- [lib/features/store_review/QA.md](lib/features/store_review/QA.md)

## QA 対象外

- `lib/features/error/` — 個別機能ではなく共通のエラー表示基盤（`error_alert.dart` 等）。各機能の QA.md 内でエラー表示を確認する
- `lib/features/localizations/` — 翻訳文字列を定義する基盤（`l.dart` 等）。UI 文言としての確認は各機能の QA.md で行う
- `lib/features/root/` — アプリ起動時のルーティング基盤。ルーティングの結果は「横断確認項目」の起動・初期設定完了の確認でカバーする
- `lib/features/local_notification_migrate/` — ローカル通知の移行用ディレクトリで、中身が空のため QA 対象がない
