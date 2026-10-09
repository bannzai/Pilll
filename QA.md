---
feature: _root
verification: mobile-mcp
last_verified_commit: 823738c52e32155e88214f4cc0663a9a85f0d5c4
last_verified_at: 2026-10-09
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

1. `/sim-manager` skill 経由で project 固有のシミュレータを起動する（`sim-boot`。指定する `SIMSLIM_EXCEPT` は「動作確認手段」を参照）
2. 依存取得: `flutter pub get`
3. dev ビルドを起動:
   ```
   flutter run --debug -t lib/main.dev.dart --dart-define-from-file=environment/dev.json
   ```
   - `-t lib/main.dev.dart`: dev flavor のエントリーポイント
   - `--dart-define-from-file=environment/dev.json`: dev 用の dart-define 一式（`environment/dev.json` は secret 化されており repo には実体が無い。`Makefile` の `make secret` ターゲット、または各自の手元の値を使う）
   - CI (`.github/workflows/ci.yml`) の `build-ios-debug` / `build-android-debug` と同じ target/dart-define を使用しており、この組み合わせが dev 環境向けの正規のビルド方法
   - シミュレータ向けにビルドだけ先に済ませて `xcrun simctl install` で入れる場合は `flutter build ios --simulator --debug -t lib/main.dev.dart --dart-define-from-file=environment/dev.json`（成果物は `build/ios/iphonesimulator/Runner.app`）

## ログイン方法

- アプリ起動時に `lib/provider/auth.dart` の `firebaseSignInOrCurrentUserProvider` が自動的に `FirebaseAuth.instance.signInAnonymously()` を呼ぶため、追加の認証情報なしで匿名ユーザーとして起動できる。これを QA の基本の入り口として推奨する
- Apple / Google アカウントとの連携（`lib/features/sign_in/sign_in_sheet.dart`）を確認する場合は、実機・シミュレータにサインイン済みの Apple ID / Google アカウントを使う。テストアカウントの認証情報はここに書かない（必要な場合はパスワードマネージャ等の参照のみとし、担当者に確認する）
- dev ビルドには開発者専用の「アカウント削除」「サインアウト」操作がある（`lib/main.dev.dart` の `Environment.deleteUser` / `Environment.signOutUser`、設定画面から呼び出し）。ログイン状態をリセットして初期設定フローから QA したい場合はこれを使う
- dev ビルドの設定画面「開発者オプション」に「トライアル解除」がある（`lib/features/settings/components/rows/end_trial_for_debug.dart`）。タップすると Firestore の `trialDeadlineDate` が過去日・`isTrial` が false に更新され、無料ユーザー（非トライアル）限定のロック UI・プレミアム訴求の QA ができる。匿名アカウントは新規登録時に自動でトライアル状態になるため、無料ユーザー向け表示を確認する項目ではこれを使う
- アプリをアンインストールして再インストールしても、同じ匿名アカウントで起動し Firestore のデータ（ピルシート・トライアル解除の状態）がそのまま復元される。初期設定フローは再表示される（2026-10-08 に `xcrun simctl uninstall` → `install` → 起動で実測。横断確認項目「サインアウト/再起動後の復元」のスクショ）。新しいアカウントで始めたい時は再インストールではなく開発者専用の「アカウント削除」を使う

## 動作確認手段

- iOS シミュレータの起動・管理: `/sim-manager`（`sim-boot` / `sim-list` / `sim-shutdown`）。`sim-boot` は毎回 `SIMSLIM_EXCEPT=store,health,icloud` を指定する（`SIMSLIM_EXCEPT=store,health,icloud sim-boot`）。`health` が無いと「ヘルスケア連携」の許可シートがタップに反応せず、`icloud` が無いと Apple 連携と StoreKit の購入ボタンが OS のサインインダイアログに到達せずに即座に失敗する（2026-07-06 の記録にあった「HealthKit 許可シートが反応しない」事象は health カテゴリの無効化が原因だった）
- シミュレータ上での UI 操作・スクリーンショット確認: `/verify-ui-mobile-mcp`（mobile-mcp 経由）
- QA.md に基づく一連の動作確認の実行・記録: `/run-qa`
- Maestro E2E フロー（`.maestro/` 配下）がある場合は `/maestro-flutter` を併用する
- 課金・サブスクリプション状態の再現: 無料ユーザーは開発者オプション「トライアル解除」で作れる。課金中・期限切れの状態を dev 環境で再現する手段は未整備（Sandbox テスターアカウントの認証情報が無い）

### 再現が難しい操作の手順

- 前回のピルシートグループ（終了済み）: 設定タブ →「開発者オプション」→「終了済みの前回ピルシートグループを作成」。現在のグループを過去にずらして 21 番まで服用済みの終了状態にし、今日から始まる新しいグループを作る。破棄したグループを前回グループにしたい時は、記録画面のピルシート設定シートの「ピルシートをすべて破棄」の後に新しいグループを追加する
- 買い切りオファー / 月額 300 円オファーの画面: 設定タブ →「開発者オプション」→「買い切りオファー Paywall」。利用日数の条件を満たさなくても `ProviderScope` の override で開ける
- 周期表示の開始番号の入力欄: ピルシートの設定シートで表示モードを「服用日数」にし、グループを破棄してから「＋ ピルシートを追加」を開くと「服用 n 番からスタート」と前回のシートの最後の番号が表示される
- リリースノートダイアログの再表示: アプリを終了してから、アプリコンテナの SharedPreferences から既読フラグを消して起動し直し、「飲んだ」をタップする（`PREFS="$(xcrun simctl get_app_container <UDID> com.mizuki.Ohashi.Pilll.dev data)/Library/Preferences/com.mizuki.Ohashi.Pilll.dev"` に対して `xcrun simctl spawn <UDID> defaults delete "$PREFS" flutter.release_notes_shown_202608.04.x`）
- 深夜服用の注意ダイアログの 2 回目以降（「二度と表示しない」付き）: 同じ要領で `flutter.midnightTakenWarningDialogLastShownDateTime` を 40 日前のミリ秒（`-float`）に書き換えてから 0:00〜2:00 に服用記録する

## 実行ナレッジ

### Xcode 27 では Pods の deployment target でビルドが落ちる（2026-10-04）

Xcode 27 は Pods の `IPHONEOS_DEPLOYMENT_TARGET < 15.0` をエラーにするため、環境変数 `DEVELOPER_DIR` に Xcode 26.5 の `Contents/Developer` を指定してビルドする。シミュレータのランタイムは iOS 27.0 のままでよい。

### mobile-mcp のタップがボトムシートの下に抜ける（2026-10-08）

記録画面のピルシート設定シート（ボトムシート）を開いたまま別の要素の座標をタップすると、シートの下の要素に当たることがある。シートを閉じる時はスクリム部分（画面上部）をタップし、`mobile_list_elements_on_screen` でシートの要素が消えたことを確認してから次の操作に進む。

## 横断確認項目

確認環境 (2026-10-05 と 2026-10-08 の記録): iPhone 16 Pro シミュレータ (iOS 27.0、ローカル sim-boot、`SIMSLIM_EXCEPT=store,health,icloud`) の dev ビルド (commit 75c754dd72 を Xcode 26.5 でビルド。`lib/features` は HEAD と同一)。

## 1. 起動・アカウント

- [x] **匿名起動**: アプリを新規インストール・起動すると匿名ユーザーとして自動サインインし、初期設定フローに進める
- [x] **初期設定完了**: 初期設定（`lib/features/initial_setting/`）を最後まで完了すると、ホーム画面に到達しピルシートが表示される
- [ ] **Apple/Google 連携**: `sign_in_sheet` から Apple または Google と連携すると、匿名アカウントのデータを引き継いだまま連携済み状態になる
  - ⏭️ スキップ: 連携の完了には Apple Account / Google アカウントの認証情報が要り、シミュレータには用意していないため未検証。Apple は OS の「Apple Account にサインインしてください」ダイアログまで、Google は accounts.google.com のログイン画面まで到達することを確認した（`lib/features/settings/QA.md` の「アカウント連携導線」）
    - 起動条件: ローカル sim-boot。`SIMSLIM_EXCEPT=store,health,icloud` / `SLIM_STATUS=APPLIED`（2026-10-05）、`ALREADY_SLIM`（2026-10-08）
    - デーモン: icloud カテゴリを有効にした状態で Apple の OS のサインインダイアログは表示される（`launchctl list` の出力は取っていない）。ダイアログを閉じるとアプリ側に `AuthorizationError Code=1000` の汎用エラーが出る（Apple Account 未サインインの環境要因）
    - 試した手順: 設定 → アカウント設定 → 連携する → Appleで登録 → サインインダイアログで停止。Google アカウントで登録 → ログイン画面で停止
- [x] **サインアウト/再起動後の復元**: アプリを終了して再起動しても、直前のログイン状態・データが保持されている

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **匿名起動**: アプリを新規インストール・起動すると匿名ユーザーとして自動サインインし、初期設定フローに進める

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

アプリをアンインストールしてから再インストールして起動すると、認証情報の入力なしにサインインされ初期設定フロー（1/3「処方されるシートについて教えてください」）に進むことを確認。再インストールではキーチェーンの認証情報から既存の匿名アカウントが復元されるため、新規の匿名アカウントが作られる経路（開発者専用の「アカウント削除」の後の起動）は本ラウンドでは確認していない。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/b661ac29-e131-4a10-acd4-d671d357d0bd-root-initial-setting-1.png" width="320">

</details>

### **初期設定完了**: 初期設定（`lib/features/initial_setting/`）を最後まで完了すると、ホーム画面に到達しピルシートが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

1/3 でピルの種類を選択 → 次へ → 2/3「まだ分からない」→ 3/3 次へ → 「アプリをはじめる」でホーム画面に到達し、ピルシートが表示されることを確認。再インストールのため匿名アカウントが復元され、表示されたのは既存のピルシートグループで、初期設定で選んだピルの種類から新しいグループが作られる経路は本ラウンドでは確認していない（新規アカウントでの初期設定は `lib/features/initial_setting/QA.md` の記録を参照）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/43fd250f-9341-4d4a-a229-a0654c97525a-root-home-after-reinstall.png" width="320">

</details>

### **Apple/Google 連携**: `sign_in_sheet` から Apple または Google と連携すると、匿名アカウントのデータを引き継いだまま連携済み状態になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

導線（設定 → アカウント設定 → 連携する → Apple/Googleで登録）の到達を確認。Apple は「Apple Account にサインインしてください」の OS ダイアログ（1 枚目）で止まり、閉じるとアプリの汎用エラー `AuthorizationError Code=1000`（2 枚目）が出る。Google は accounts.google.com のログイン画面（3 枚目）で止まり、以降は未実施。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/8df9944a-69ac-4daa-b901-bfa848d24bea-root-apple-signin.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/e21e63e3-a3ed-4d34-9c43-5fdb172bc186-root-apple-signin-closed.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/1f157723-03c8-458c-bf80-c211105bce0e-root-google-signin.png" width="320">

⏭️ スキップ: 連携の完了は認証情報が無いため未検証（チェックリスト側を参照）

</details>

### **サインアウト/再起動後の復元**: アプリを終了して再起動しても、直前のログイン状態・データが保持されている

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

アプリを完全終了して再起動しても匿名ログイン状態・ピルシート・服用記録が保持されたままホーム画面に到達すること（1 枚目、2026-10-05）、アンインストールして再インストールした後もキーチェーンの認証情報から同じアカウントで起動し、Firestore のデータ（34 日目まで服用済みのグループ）が復元されること（2 枚目、2026-10-08）を確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/79ff4085-a304-4451-b7f8-86a8e5238b96-root-relaunch.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/43fd250f-9341-4d4a-a229-a0654c97525a-root-home-after-reinstall.png" width="320">

</details>

</details>

## 2. 通知・権限

- [x] **通知権限許可**: 初回起動時またはリマインダー設定時に通知許可ダイアログが表示され、許可するとリマインダー通知が有効になる
- [ ] **服用リマインダー通知**: 設定した時刻にローカル通知（`flutter_local_notifications`）が届き、通知から服用記録ができる
  - ⏭️ スキップ: 本ラウンドでは通知時刻まで待つ確認を行っていない（2026-07-06 にロック画面通知「💊の時間です」とアイコンバッジの到達を確認済み）。通知の登録処理 `lib/utils/local_notification.dart` は前回の確認の後に 1 日 2 回服用 (`pillTakenCount`) に対応する変更が入っているため、再確認が要る項目として残す。mobile-mcp では通知時刻のピッカーを狙った時刻に合わせられず（通知の追加は既定の時刻になる）、通知到達の確認を本ラウンドで実施できなかった。「通知から服用記録ができる」部分はクイックレコードがプレミアム限定で、無料ユーザー状態では標準の通知アクションだけが出るため未検証

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **通知権限許可**: 初回起動時またはリマインダー設定時に通知許可ダイアログが表示され、許可するとリマインダー通知が有効になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

再インストール後の初回起動で初期設定画面の上に通知許可ダイアログが表示され、「許可」の後に初期設定フローへ進むことを確認。設定画面の「ピルの服用通知」が ON になっている（`lib/features/settings/QA.md` の「服薬リマインダーのON/OFF」）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/a3fe9c22-77ad-49c6-9cf7-3da13d73291e-root-notification-permission.png" width="320">

</details>

### **服用リマインダー通知**: 設定した時刻にローカル通知（`flutter_local_notifications`）が届き、通知から服用記録ができる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

設定→通知時間で通知1を11:50に変更し、実機時刻が11:50になった時点でロック画面通知「💊の時間です」とアプリアイコンの通知バッジが表示されることを確認（通知到達は確認済み）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/536e1a73-63e8-473b-8547-253f81cc7292.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/94f170f0-50b4-4e42-a751-4beeb43942f5.png" width="320">

⏭️ スキップ: 2026-10 のラウンドでは再確認していない（チェックリスト側を参照）

</details>

</details>

## 3. 課金・プレミアム

- [x] **プレミアム導線表示**: 非プレミアムユーザーに `premium_introduction` への導線（プラン一覧・価格表示）が正しく表示される
- [x] **課金ゲート (非プレミアム時の制限)**: プレミアム限定機能が非プレミアムユーザーには制限される
- [ ] **課金ゲート (購入後の解放)**: 購入後にプレミアム限定機能が解放される
  - ⏭️ スキップ: 月額プランのタップで Apple Account のサインインダイアログは出るが、Sandbox テスターアカウントの認証情報が無く購入を完了できないため未実施
    - 起動条件: ローカル sim-boot。`SIMSLIM_EXCEPT=store,health,icloud` / `SLIM_STATUS=APPLIED`（2026-10-05）
    - デーモン: icloud カテゴリを有効にした状態で OS のサインインダイアログに到達しており、デーモン不足ではなく認証情報の不足が原因（`launchctl list` の出力は取っていない）
    - 試した手順: 設定 → プレミアムプランを見る → 月額プラン → サインインダイアログ → 認証情報が無く「キャンセル」で中断（`lib/features/premium_introduction/QA.md` の「購入ボタンタップでローディング表示」）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **プレミアム導線表示**: 非プレミアムユーザーに `premium_introduction` への導線（プラン一覧・価格表示）が正しく表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

設定画面「プレミアムプランを見る」から `premium_introduction` のシートが開き、月額/年額/買い切りプランと価格が表示されることを確認（価格は StoreKit テスト環境のため USD 表記）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/7f9c0b3a-1b99-4378-9e57-41fcdf139dc0-premium-sheet.png" width="320">

</details>

### **課金ゲート (非プレミアム時の制限)**: プレミアム限定機能が非プレミアムユーザーには制限される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

開発者オプション「トライアル解除」で無料ユーザーにした後、「ピルシートグループの自動追加」のトグルをタップすると ON にならずプレミアム紹介シートが表示されることを確認。カレンダーの月ロック・履歴カードのロック、記録画面の日付表示の制限も同じ状態で確認した（各 feature の QA.md）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/34466766-1aab-4bc7-a122-45376985ad33-free-settings-autoadd-premium.png" width="320">

</details>

### **課金ゲート (購入後の解放)**: 購入後にプレミアム限定機能が解放される

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: Sandbox テスターアカウントが無く購入を完了できないため未実施（理由はチェックリスト側を参照）

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

**確認日: 2026-10-05**

「飲んだ」で 1 番にチェックが付き「飲んでない」に切り替わること、「飲んでない」で取り消されて元に戻ることを確認（`lib/features/record/QA.md` の「服用ボタンで記録」「シート上マーク直接タップで服用/取消」）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/85c00f7d-4eb4-40b8-ad2b-d9d81313f2e6-record-midnight-4.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/579e051c-4dcb-4037-bf45-d5b936b42618-record-tap-revert.png" width="320">

</details>

### **生理記録**: `menstruation` から生理の記録・編集ができる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

生理タブの「生理を記録」で 10/5 開始の生理が記録され「1日目」が表示されること（1 枚目）、「生理期間を編集」で期間を延ばすと週表示の帯が伸びること（2 枚目）を確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/20d3b099-ab9c-4d28-9e0e-63185c09b5ce-root-menstruation-recorded.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/4904e22d-0462-4517-8a5c-bfbf450b2c57-root-menstruation-edited.png" width="320">

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
- [lib/features/ended_pill_sheet_dialog/QA.md](lib/features/ended_pill_sheet_dialog/QA.md)
- [lib/features/feature_appeal/QA.md](lib/features/feature_appeal/QA.md)
- [lib/features/inquiry/QA.md](lib/features/inquiry/QA.md)
- [lib/features/lifetime_offer/QA.md](lib/features/lifetime_offer/QA.md)
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

QA.md を作らない feature ディレクトリ。release-app の `check_qa_gate.sh` はこの表の 1 列目を `no-qa-md` の検出から外す。

| feature | 理由 |
| --- | --- |
| `error` | 個別機能ではなく共通のエラー表示基盤（`error_alert.dart` 等）。各機能の QA.md 内でエラー表示を確認する |
| `localizations` | 翻訳文字列を定義する基盤（`l.dart` 等）。UI 文言としての確認は各機能の QA.md で行う |
| `root` | アプリ起動時のルーティング基盤。ルーティングの結果は「横断確認項目」の起動・初期設定完了の確認でカバーする |
| `appstore_screenshot` | App Store スクリーンショット生成用のモック画面（`.github/workflows/appstore-screenshots.yml` と `.maestro/flows/appstore_screenshot/` が使う）。ユーザーに見える画面ではなく、生成物の確認はストア掲載の作業で行う |
