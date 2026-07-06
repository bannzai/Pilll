---
feature: _root
verification: mobile-mcp
last_verified_commit: 34b7e05eb0ed73e5ee0caa2a91a96147e2edaded
last_verified_at: 2026-07-06
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
- dev ビルドの設定画面「開発者オプション」に「トライアル解除」がある（`lib/features/settings/components/rows/end_trial_for_debug.dart`）。タップすると Firestore の `trialDeadlineDate` が過去日・`isTrial` が false に更新され、無料ユーザー（非トライアル）限定のロック UI・プレミアム訴求の QA ができる。匿名アカウントは新規登録時に自動でトライアル状態になるため、無料ユーザー向け表示を確認する項目ではこれを使う

## 動作確認手段

- iOS シミュレータの起動・管理: `/sim-manager`（`sim-boot` / `sim-list` / `sim-shutdown`）
- シミュレータ上での UI 操作・スクリーンショット確認: `/verify-ui-mobile-mcp`（mobile-mcp 経由）
- QA.md に基づく一連の動作確認の実行・記録: `/run-qa`
- Maestro E2E フロー（`.maestro/` 配下）がある場合は `/maestro-flutter` を併用する

## 横断確認項目

## 1. 起動・アカウント

- [x] **匿名起動**: アプリを新規インストール・起動すると匿名ユーザーとして自動サインインし、初期設定フローに進める
- [x] **初期設定完了**: 初期設定（`lib/features/initial_setting/`）を最後まで完了すると、ホーム画面に到達しピルシートが表示される
- [ ] **Apple/Google 連携**: `sign_in_sheet` から Apple または Google と連携すると、匿名アカウントのデータを引き継いだまま連携済み状態になる
- [x] **サインアウト/再起動後の復元**: アプリを終了して再起動しても、直前のログイン状態・データが保持されている

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **匿名起動**: アプリを新規インストール・起動すると匿名ユーザーとして自動サインインし、初期設定フローに進める

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/2cdc4703-3f5e-48fe-bfdf-c8a373ab9ba3.png" width="320">

</details>

### **初期設定完了**: 初期設定（`lib/features/initial_setting/`）を最後まで完了すると、ホーム画面に到達しピルシートが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/091926d3-f32a-4779-92b8-d04718d2e07d.png" width="320">

</details>

### **Apple/Google 連携**: `sign_in_sheet` から Apple または Google と連携すると、匿名アカウントのデータを引き継いだまま連携済み状態になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

導線（設定 → アカウント設定 → 連携する → Apple/Googleで登録）までは到達を確認。Apple 連携はシミュレータに Apple Account が未サインインのため OS ダイアログで止まり、そのダイアログを閉じると `[firebase_auth/unknown] An unknown error has occurred.` という汎用エラーが表示された（Apple Account 未設定という限定的な環境要因のため、アプリのバグとは断定せずここに記録のみ行う）。Google 連携は実際の Google ログイン画面（accounts.google.com）まで到達したが、テストアカウント認証情報がないため以降は未実施。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/16705907-2124-425f-996e-2290efdaed5b.png" width="320">

</details>

### **サインアウト/再起動後の復元**: アプリを終了して再起動しても、直前のログイン状態・データが保持されている

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

mobile_terminate_app でアプリを完全終了後に再起動し、匿名ログイン状態・ピルシート・生理記録（7/6-7/10）がいずれも保持されたままホーム画面に到達することを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/2fc60daf-4aee-493b-8b5e-495ddf874a43.png" width="320">

</details>

</details>

## 2. 通知・権限

- [x] **通知権限許可**: 初回起動時またはリマインダー設定時に通知許可ダイアログが表示され、許可するとリマインダー通知が有効になる
- [ ] **服用リマインダー通知**: 設定した時刻にローカル通知（`flutter_local_notifications`）が届き、通知から服用記録ができる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **通知権限許可**: 初回起動時またはリマインダー設定時に通知許可ダイアログが表示され、許可するとリマインダー通知が有効になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

初回起動の初期設定フロー内で通知許可ダイアログが表示され、「許可」タップ後にダイアログが閉じて初期設定フローへ正常に進んだ（許可ダイアログの前後のスクショ）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/2cdc4703-3f5e-48fe-bfdf-c8a373ab9ba3.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/979647fa-2e14-488b-aea1-87f120914d50.png" width="320">

</details>

### **服用リマインダー通知**: 設定した時刻にローカル通知（`flutter_local_notifications`）が届き、通知から服用記録ができる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

設定→通知時間で通知1を11:50に変更し、実機時刻が11:50になった時点でロック画面通知「💊の時間です」とアプリアイコンの通知バッジが表示されることを確認（通知到達は確認済み）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/536e1a73-63e8-473b-8547-253f81cc7292.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/94f170f0-50b4-4e42-a751-4beeb43942f5.png" width="320">

- ⏭️ スキップ: 「通知から服用記録ができる」部分は、通知からの服用記録（クイックレコード）が Premium 限定機能であり、本セッションでは課金ゲート確認のため「トライアル解除」で非プレミアム状態にしていたため、通知の長押し/スワイプでは標準の iOS 通知アクション（オプション/表示/消去）のみが表示され、アプリ独自の服用記録アクションは検証できなかった

</details>

</details>

## 3. 課金・プレミアム

- [x] **プレミアム導線表示**: 非プレミアムユーザーに `premium_introduction` への導線（プラン一覧・価格表示）が正しく表示される
- [ ] **課金ゲート**: プレミアム限定機能が非プレミアムユーザーには制限され、購入後に解放される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **プレミアム導線表示**: 非プレミアムユーザーに `premium_introduction` への導線（プラン一覧・価格表示）が正しく表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

設定画面「プレミアムプランを見る」から `premium_introduction` に遷移し、月額/年額/買い切りプランと価格が表示されることを確認（価格表示はStoreKitテスト環境のためUSD表記）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/28d59b7c-1e7d-4891-a9c7-8d4b155cfdf9.png" width="320">

</details>

### **課金ゲート**: プレミアム限定機能が非プレミアムユーザーには制限され、購入後に解放される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

開発者オプション「トライアル解除」で非プレミアムユーザー状態にした後、Premium機能「ピルシートグループの自動追加」のスイッチをONにしようとすると、機能が有効化されず `premium_introduction` のペイウォールが表示されることを確認（制限側は確認済み）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/24929731-266a-44ae-a77c-0d0be7fe8005.png" width="320">

- ⏭️ スキップ: 「購入後に解放される」側は、月額プランタップ時に Apple Account サインインダイアログが表示され、StoreKit サンドボックスのテストアカウント認証情報が本セッションにないため購入完了まで検証できず未実施

</details>

</details>

## 4. コアデータ操作

- [x] **服用記録**: `record` からピルの服用記録・取り消しができ、ピルシートの表示に反映される
- [x] **生理記録**: `menstruation` から生理の記録・編集ができる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **服用記録**: `record` からピルの服用記録・取り消しができ、ピルシートの表示に反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

「飲んだ」タップでピルシートの7/6にチェックマークが反映され、「飲んでない」タップで取り消され通常表示に戻ることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/0e3ecabf-f893-427d-8a8c-ffc18d07b701.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/ea23980c-eee8-4128-ac0f-7b57d80725fa.png" width="320">

</details>

### **生理記録**: `menstruation` から生理の記録・編集ができる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

「今日から生理」で記録後、生理期間を編集（7/6-7/9 → 7/6-7/10）して反映されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/d4c52f80-0eba-4d66-bf2f-0dde5adc51df.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/6e7603a7-a923-4827-9412-0f832bce5d01.png" width="320">

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
