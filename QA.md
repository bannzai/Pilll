---
feature: _root
verification: mobile-mcp
last_verified_commit: dc641fb93f5a2657d16a06010a688486b8d76e21
last_verified_at: 2026-10-16
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
- アプリをアンインストールして再インストールしても、同じ匿名アカウントで起動し、Firestore のデータは復元される。初期設定フローは再表示され、通し直すとトライアル状態も付き直ることがある。新しいアカウントで始めたい時は再インストールではなく開発者専用の「アカウント削除」を使う
  - 2026-10-08: `xcrun simctl uninstall` → `install` → 起動で、同じ匿名アカウントで起動し Firestore のデータ（ピルシート・トライアル解除の状態）がそのまま復元された
  - 2026-10-16: 同じ手順 (トライアル解除済みのアカウント) で初期設定を通し直すと、設定画面に「機能無制限の期間について」の行があり、トライアル中になっていた。再インストール前に記録した 10/15 の日記と 10/20 の予定はカレンダーに残っていたため、アカウントは同じで、トライアル状態だけが付き直ったと考えられる (付き直る条件は未確認)

## 動作確認手段

- iOS シミュレータの起動・管理: `/sim-manager`（`sim-boot` / `sim-list` / `sim-shutdown`）。`sim-boot` は毎回 `SIMSLIM_EXCEPT=store,health,icloud,widgets` を指定する（`SIMSLIM_EXCEPT=store,health,icloud,widgets sim-boot`）。ホーム画面 Widget の確認では `widgets` も残す (2026-10-15 はこの指定でホーム画面に Widget を追加して表示を確認できた)。`health` が無いと「ヘルスケア連携」の許可シートがタップに反応せず、`icloud` が無いと Apple 連携と StoreKit の購入ボタンが OS のサインインダイアログに到達せずに即座に失敗する（2026-07-06 の記録にあった「HealthKit 許可シートが反応しない」事象は health カテゴリの無効化が原因だった）
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

### Xcode 27.1 でビルドする（2026-10-10）

- Pods の `IPHONEOS_DEPLOYMENT_TARGET < 15.0` は `ios/Podfile` の post_install が 15.0 に揃えるため、Xcode 26.5 を `DEVELOPER_DIR` に指定する回避は不要になった（2026-10-04 の記録を置き換え）
- Simulator 向けのビルド（`flutter build ios --simulator`）は Flutter 3.44.9（CI の `flutter-version` と同じ版）でそのまま通る。3.41.9 では arm64 と x86_64 を 1 回の `lipo -verify_arch` で検証し、Xcode 27 の lipo が `-verify_arch requires exactly one input file` で拒否して `debug_unpack_ios` が失敗していた（ https://github.com/flutter/flutter/issues/188461 ）。1 アーキテクチャずつ検証する修正（ https://github.com/flutter/flutter/pull/189792 ）が stable 3.44.8 以降に入っており、`FLUTTER_XCODE_ARCHS=arm64` を付けて arm64 だけをビルドする回避策は要らない（2026-10-10 に Flutter 3.44.9 と Xcode 27.1 (27A9275) で `flutter build ios --simulator --debug -t lib/main.dev.dart --dart-define-from-file=environment/dev.json` を `FLUTTER_XCODE_ARCHS` なしで実行し、`✓ Built build/ios/iphonesimulator/Runner.app` で終了。成果物の `Runner` と `Flutter.framework/Flutter` は `lipo -info` で x86_64 と arm64 の fat binary。https://github.com/bannzai/Pilll/pull/1902 ）
- アプリは UIScene ライフサイクルに移行済み（`ios/Runner/Info.plist` の `UIApplicationSceneManifest`、`AppDelegate.swift` の `didInitializeImplicitFlutterEngine`）。iOS 27 SDK でビルドしたアプリは UIScene 未対応だと起動直後に落ちる（ https://docs.flutter.dev/release/breaking-changes/uiscenedelegate ）

### iPhone Duo（iOS 27.1）の外側・内側ディスプレイを確認する（2026-10-10）

- 起動は `SIM_DEVICE_TYPE="iPhone Duo" SIMSLIM_EXCEPT=store,health,icloud,widgets sim-boot`（iOS 27.1 のランタイムは iPhone Duo だけが対応）。姿勢の切り替えと撮影は ios-simulator skill Phase 2「折りたたみ端末の外側・内側ディスプレイを切り替える」に従う（`duo-pose.sh set --udid <UDID> open|closed`、内側は `xcrun simctl io <UDID> screenshot --display=primary-1`）
- 外側ディスプレイでは OS が画面右端の約 84pt の列を占有し、SafeArea の右 inset になる。`MediaQuery.of(context).size.width`（画面全体の幅）を使った幅の計算は SafeArea 内の実際の幅とずれるため、`LayoutBuilder` の幅を使う（2026-10-10 に直した箇所: ピルシートの PageView、カレンダーの帯、設定の「ピルシートグループの自動追加」、初期設定後のプレミアム紹介）
- 閉じた姿勢の外側ディスプレイは `xcrun simctl io <UDID> screenshot --display=primary` と明示して撮る。2026-10-16 (Xcode 27.1 27A9275) には `--display` を省くと、閉じた姿勢でも真っ黒な内側ディスプレイ (2007×2853 px) が撮れた
- iOS 27.1 では `NSUserDefaults` に `NSNull` を書くと例外になる。`home_widget` は 0.10.0 から null をキーの削除として扱うため (https://github.com/ABausG/home_widget/pull/450 )、`lib/native/widget.dart` は null をそのまま `saveWidgetData` に渡している。`home_widget` を 0.10.0 より前に戻すと Widget の値の同期で落ちる

### 通知のアクション（「飲んだ」）を Simulator で確認する（2026-10-10）

- 通知時刻を待たずに `xcrun simctl push <UDID> <ペイロードの JSON>` で通知を届ける。ペイロードは `{"Simulator Target Bundle": "com.mizuki.Ohashi.Pilll.dev", "aps": {"alert": {"title": "💊の時間です", "body": "..."}, "category": "PILL_REMINDER", "sound": "default"}}`。`category` を `PILL_REMINDER` にすると `AppDelegate.swift` の `configureNotificationActionableButtons` が登録した「飲んだ」のアクションが出る
- 終了状態からの確認は `xcrun simctl terminate` で止めてから push し、ロック画面の通知を mobile-mcp で長押し（約 800ms）して「飲んだ」をタップする。結果は `xcrun simctl spawn <UDID> log show --last 2m --predicate 'process == "Runner"'` の `handle_recordPill_method_channel` と `quick_recorded` で確認する（アプリは前面に出ない）
- 通知本体のタップで起動する確認は、ホーム画面を表示した状態で push し、画面上部に出たバナーをタップする。ロック画面・通知センターに溜まった通知のタップは、mobile-mcp と Maestro のどちらでもアプリが起動しなかった（2026-10-15）
- 通知時刻の到達は、設定の「通知時間」で通知1 を 2〜3 分後にしてホーム画面で待つ。待つ間はバックグラウンドのコマンドで指定の時刻を過ぎてから `xcrun simctl io` で撮る
- Simulator では画面を開かない通知アクションでも `UIWindowScene` が接続されて画面の Flutter エンジンが初期化されるため、scene が接続されない時に起動する headless エンジン（`AppDelegate.swift` の `startHeadlessEngineIfNeeded`）の経路は Simulator では通らない

### ホーム画面 Widget を追加する（2026-10-15）

`SIMSLIM_EXCEPT` に `widgets` を入れて起動し、ホーム画面のアプリのアイコン (Pilll-dev) を長押しして出るメニューの上段のサイズ (小) をタップすると Widget がホーム画面に追加される。

### mobile-mcp のタップがボトムシートの下に抜ける（2026-10-08）

記録画面のピルシート設定シート（ボトムシート）を開いたまま別の要素の座標をタップすると、シートの下の要素に当たることがある。シートを閉じる時はスクリム部分（画面上部）をタップし、`mobile_list_elements_on_screen` でシートの要素が消えたことを確認してから次の操作に進む。

## 横断確認項目

確認環境 (2026-10-15〜16 の記録): iPhone 16 Pro シミュレータ (iOS 27.0、ローカル sim-boot、`SIMSLIM_EXCEPT=store,health,icloud,widgets`) と iPhone Duo シミュレータ (iOS 27.1) の dev ビルド (HEAD を Flutter 3.44.9・Xcode 27.1 でビルド)。確認日が 2026-10-05・2026-10-08 の項目 (Apple/Google 連携の導線) は、前回 (commit 75c754dd72 を Xcode 26.5 でビルド) の記録のまま。

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

**確認日: 2026-10-15**

iPhone 16 Pro シミュレータ (iOS 27.0、`SIMSLIM_EXCEPT=store,health,icloud,widgets`) に、HEAD を Flutter 3.44.9・Xcode 27.1 でビルドした dev ビルドを新規インストールして起動すると、通知許可のダイアログ (1 枚目) の後、認証情報の入力なしに初期設定 1/3 に進む (2 枚目)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/f0a518cc-e9be-4e8a-a65f-41eb16e3c003-ev-root-launch.png" width="640">

</details>

### **初期設定完了**: 初期設定（`lib/features/initial_setting/`）を最後まで完了すると、ホーム画面に到達しピルシートが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**

1/3 でピルシートを 3 枚 (28錠4錠偽薬・21錠・21錠) 選び、2/3 で 10 番、3/3 で通知時刻を設定して「アプリをはじめる」をタップすると、ホーム画面に「今日飲むピル 10番」のピルシートが表示される (3 枚目)。手順の詳細は `lib/features/initial_setting/QA.md`。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/f0a518cc-e9be-4e8a-a65f-41eb16e3c003-ev-root-launch.png" width="640">

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

**確認日: 2026-10-15**

`xcrun simctl terminate` でアプリを終了してから起動し直すと (通知のタップで起動)、匿名ログイン状態のまま、10/15 の服用済みの記録が残ったホーム画面が表示される (2 枚目)。再インストールの後の挙動は「ログイン方法」節の注記を参照。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/28af91dc-5ffe-41b0-9a82-0064d1973776-ev-root-notif-tap.png" width="640">

</details>

</details>

## 2. 通知・権限

- [x] **通知権限許可**: 初回起動時またはリマインダー設定時に通知許可ダイアログが表示され、許可するとリマインダー通知が有効になる
- [x] **服用リマインダー通知**: 設定した時刻にローカル通知（`flutter_local_notifications`）が届き、通知から服用記録ができる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **通知権限許可**: 初回起動時またはリマインダー設定時に通知許可ダイアログが表示され、許可するとリマインダー通知が有効になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**

新規インストール後の初回起動で通知許可ダイアログが表示され (1 枚目)、「許可」の後に初期設定フローへ進む (2 枚目)。許可した後は設定した時刻に通知が届いた (下の「服用リマインダー通知」)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/f0a518cc-e9be-4e8a-a65f-41eb16e3c003-ev-root-launch.png" width="640">

</details>

### **服用リマインダー通知**: 設定した時刻にローカル通知（`flutter_local_notifications`）が届き、通知から服用記録ができる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**

設定の「通知時間」で通知1 を 04:51 にしてホーム画面で待つと、04:51 に「💊 10/15 (木) 10番 Local」の通知がバナーで届いた (1 枚目)。1 日 2 回服用の対応で変わった `lib/utils/local_notification.dart` で、1 日 1 回のシートの通知が届くことを確かめた。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/4f31bca6-c01c-4cd2-b75b-4ef2ccc63c0d-root-reminder-arrived.png" width="320">

通知から服用記録: アプリを `xcrun simctl terminate` で終了してから `category` が `PILL_REMINDER` の通知を `xcrun simctl push` で届け、バナーを長押しして出る「飲んだ」を押すと (1 枚目)、`log show` に `handle_recordPill_method_channel` (04:45:44) → `quick_recorded` (04:45:51) が出て、開いた記録画面の今日の番号が服用済み (ボタンが「飲んでない」) になっていた (2 枚目)。Simulator では通知のアクションでも `UIWindowScene` が接続されるため、scene が接続されない時の headless の Flutter エンジンの経路 (実機だけで通る) はこの確認には含まれない。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/086c76fb-9d97-473f-9aee-c47bddd39fff-ev-root-notif-action.png" width="640">

</details>

</details>

## 3. 課金・プレミアム

- [x] **プレミアム導線表示**: 非プレミアムユーザーに `premium_introduction` への導線（プラン一覧・価格表示）が正しく表示される
- [x] **課金ゲート (非プレミアム時の制限)**: プレミアム限定機能が非プレミアムユーザーには制限される
- [ ] **課金ゲート (購入後の解放)**: 購入後にプレミアム限定機能が解放される
  - ⏭️ スキップ: 月額プランのタップで Apple Account のサインインダイアログは出るが、Sandbox テスターアカウントの認証情報が無く購入を完了できないため未実施
    - 起動条件: ローカル sim-boot。`SIMSLIM_EXCEPT=store,health,icloud` / `SLIM_STATUS=APPLIED`（2026-10-05）
    - デーモン: icloud カテゴリを有効にした状態で OS のサインインダイアログに到達しており、デーモン不足ではなく認証情報の不足が原因（`launchctl list` の出力は取っていない）
    - 試した手順: 設定 → プレミアムプランを見る → 月額プラン → サインインダイアログ → 認証情報が無く「キャンセル」で中断（`lib/features/premium_introduction/QA.md` の「購入ボタンタップで購入フロー開始」）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **プレミアム導線表示**: 非プレミアムユーザーに `premium_introduction` への導線（プラン一覧・価格表示）が正しく表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15〜16**

設定画面「プレミアムプランを見る」から `premium_introduction` のシートが開き、月額 $2.99・年額 $27.49・買い切り $69.99 のプランと価格が表示される (StoreKit テスト環境のため USD 表記)。「トライアル解除」後の無料ユーザーでは、ホーム画面のバーが「プレミアム登録で引き続きすべての機能が利用できます」と割引の残り時間に変わる (`lib/features/settings/QA.md` の「ピルシート破棄」の画像の 3 枚目。ピルシートを破棄した後の記録画面の上部に出ているバー)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8f8d2d44-fa21-4f80-acbc-11e861260304-st-premium-sheet-top.png" width="320">

</details>

### **課金ゲート (非プレミアム時の制限)**: プレミアム限定機能が非プレミアムユーザーには制限される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-16**

開発者オプション「トライアル解除」で無料ユーザーにした後、「ピルシートグループの自動追加」のトグルをタップすると ON にならずプレミアム紹介シートが表示される。カレンダーの月ロック・服用履歴のロック、生理履歴の平均値の🔒、機能紹介の HelpPage の「確認する」のペイウォールも同じ状態で確認した (各 feature の QA.md)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/ef0bef43-25ce-4c5e-9364-b0b957802010-free-autoadd-compare-crop.png" width="640">

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

**確認日: 2026-10-15**

「飲んだ」で今日 (10/15) の番号にチェックが付きボタンが「飲んでない」に切り替わり (1 枚目)、「飲んでない」で取り消されて元に戻る (2 枚目)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/7e1a630a-f18d-4538-b068-a0c345de2cc9-ev-root-record.png" width="640">

</details>

### **生理記録**: `menstruation` から生理の記録・編集ができる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**

生理タブの「生理を記録」→「今日から生理」で 10/15 開始の生理が記録され「1日目」が表示され (上の画像の 3 枚目)、「生理期間を編集」で 10/13-10/16 に変えると「生理期間を編集しました」が表示されて週表示の帯が変わる (下の画像の 4 枚目)。詳細は `lib/features/menstruation/QA.md`。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/cb0b4f7c-e004-4dea-9bc8-667226078cfd-ev-mn-record.png" width="640">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/588fa1a0-b318-4dac-a0c8-a3b1a9b23437-ev-mn-edit.png" width="640">

</details>

</details>

## 5. iPhone Duo（外側・内側ディスプレイ）での主要画面の表示

- [x] **外側・内側ディスプレイで主要画面が崩れない**: iPhone Duo（iOS 27.1）の Simulator で、閉じた姿勢（外側）・開いた姿勢（内側）・閉じ直した姿勢の順に主要画面（初期設定 1/3〜3/3・プレミアム紹介・記録・ピルシートの設定シート・生理・生理を記録シート・カレンダー・日記の投稿・設定・ピル番号の変更・プレミアムプランのシート・買い切りオファー）を撮り、見切れ・重なり・固定幅による偏り・サイドバー化が無い

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **外側・内側ディスプレイで主要画面が崩れない**: iPhone Duo（iOS 27.1）の Simulator で、閉じた姿勢（外側）・開いた姿勢（内側）・閉じ直した姿勢の順に主要画面（初期設定 1/3〜3/3・プレミアム紹介・記録・ピルシートの設定シート・生理・生理を記録シート・カレンダー・日記の投稿・設定・ピル番号の変更・プレミアムプランのシート・買い切りオファー）を撮り、見切れ・重なり・固定幅による偏り・サイドバー化が無い

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-16**

HEAD を Flutter 3.44.9・Xcode 27.1 (27A9275) でビルドした dev ビルドを iPhone Duo の Simulator (`pilll-issue-497-iOS27.1`、ローカル sim-boot) に入れ、2026-10-10 に崩れを直した 4 画面 (初期設定 2/3 のピルシートの PageView・プレミアム紹介の画像・設定の自動追加の行・カレンダー 11 月の帯) を、閉じた姿勢 (外側)・開いた姿勢 (内側)・閉じ直した姿勢の順に撮った (各画像の左から順)。見切れ・重なり・固定幅による偏りは無かった。他の画面は 2026-10-10 の記録のまま (commit 6a7e22d7fa、全画面の画像は https://github.com/bannzai/Pilll/pull/1900 の表)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/fae23b1c-d927-4c36-9fd4-139991c172b0-duo-initial-2.png" width="640">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/0bbea126-4545-4a82-b468-f52751063b9b-duo-premium-intro.png" width="640">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/0edcca11-25b4-4692-ad00-d1a9b10a6cd8-duo-settings-autoadd.png" width="640">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/b03154f6-8eb5-445c-837c-7b0b4956ca80-duo-calendar-nov.png" width="640">

</details>

</details>

## 6. アプリのライフサイクル・ホーム画面 Widget

- [x] **バックグラウンドからの復帰**: 記録画面を開いた状態でホーム画面に戻し、アプリを開き直すと、同じ画面・状態のまま表示され、白画面やクラッシュにならない
- [x] **終了状態から通知バナーのタップで起動**: アプリを終了した状態で届いた服用リマインダー通知を、画面上部のバナーの本体でタップすると、アプリが起動して記録画面が表示される
- [ ] **終了状態から通知センターの通知のタップで起動**: アプリを終了した状態で届き通知センター (ロック画面) に溜まった服用リマインダー通知をタップすると、アプリが起動して記録画面が表示される
  - ⏭️ スキップ: 2026-10-15 に Simulator で、通知センターに溜まった通知を mobile-mcp のタップ・Maestro の `tapOn` のどちらでタップしてもアプリが起動しなかった。同じ通知をバナーでタップすると起動したため、Simulator の操作の制約か OS の挙動かを切り分けられていない
- [x] **ホーム画面 Widget の表示**: ホーム画面に追加した Pilll の Widget (小) に今日のピル番号が表示され、アプリで服用記録すると「服用済み」とチェックの表示に変わる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **バックグラウンドからの復帰**: 記録画面を開いた状態でホーム画面に戻し、アプリを開き直すと、同じ画面・状態のまま表示され、白画面やクラッシュにならない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**

ホーム画面に Widget を追加するために記録画面からホーム画面に戻し、アプリを開き直すと、同じ記録画面 (今日飲むピル 10番) のまま表示された。白画面にならず、`~/Library/Logs/DiagnosticReports` に Runner のクラッシュレポートは出ていない。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d7b41b59-3f8e-47c5-8ef2-5579392262cb-root-resume.png" width="320">

</details>

### **終了状態から通知バナーのタップで起動**: アプリを終了した状態で届いた服用リマインダー通知を、画面上部のバナーの本体でタップすると、アプリが起動して記録画面が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**

`xcrun simctl terminate` でアプリを終了してから `xcrun simctl push` で通知を届け (1 枚目は通知センターに溜まった同じ通知)、ホーム画面上部に出たバナーの本体をタップすると、アプリが起動して記録画面が表示された (2 枚目)。通知センターに溜まった通知のタップでは、mobile-mcp と Maestro のどちらでもアプリが起動しなかった (Simulator の操作の制約か OS の挙動かは切り分けていない)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/28af91dc-5ffe-41b0-9a82-0064d1973776-ev-root-notif-tap.png" width="640">

</details>

### **ホーム画面 Widget の表示**: ホーム画面に追加した Pilll の Widget (小) に今日のピル番号が表示され、アプリで服用記録すると「服用済み」とチェックの表示に変わる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**

ホーム画面に Pilll-dev の Widget (小) を追加すると「15 木曜日 / 10番」が表示され (1 枚目)、アプリで「飲んだ」をタップした後 (2 枚目) にホーム画面に戻ると「10番 服用済み」とチェックの表示に変わった (3 枚目)。今日のピル番号を 12 番に変えた後は Widget も 12番になった (`lib/features/settings/QA.md` の「今日のピル番号変更」の 3 枚目)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/e10de658-ed28-4e0c-a609-56c5e7911197-ev-root-widget.png" width="640">

</details>

### **終了状態から通知センターの通知のタップで起動**: アプリを終了した状態で届き通知センター (ロック画面) に溜まった服用リマインダー通知をタップすると、アプリが起動して記録画面が表示される

<details><summary>動作確認スクショ</summary>

⏭️ スキップ: 2026-10-15 に操作を試したが起動せず、原因を切り分けられていない (チェックリスト側を参照)。通知センターに溜まった通知は「終了状態から通知バナーのタップで起動」の画像の 1 枚目

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
