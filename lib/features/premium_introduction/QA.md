---
feature: premium_introduction
verification: mobile-mcp
last_verified_commit: c827d4be46d15d8f4b573af8be8e356c24d8b710
last_verified_at: 2026-10-09
---

# premium_introduction QA

確認環境 (2026-10-05 の記録): iPhone 16 Pro シミュレータ (iOS 27.0、ローカル sim-boot、`SIMSLIM_EXCEPT=store,health,icloud`) の dev ビルド (commit 75c754dd72 を Xcode 26.5 でビルド。`lib/features` は HEAD と同一)。トライアル中の新規匿名アカウントで確認した。

## シートまでの到達手順

新規インストール直後は初期設定を完了しないと設定タブに到達できず、シートを開くまでの操作が長い。
既存の Maestro サブフロー `.maestro/flows/feature_appeal/subflows/initial_setup.yaml` が初期設定を最後まで自動化しているため、これを `runFlow` で呼んでから設定タブ(座標 `point: "88%,95%"`)へ切り替え、`scrollUntilVisible` で「プレミアムプランを見る」を出してタップするとシートに到達できる(`.maestro/flows/lifetime_offer/lifetime_offer_paywall_variants.yaml` が同じ導線を使っている)。

シート内の操作で座標指定が必要なもの:

- シート左上の×: tooltip / semanticLabel が未設定で text セレクタから検出できない。`point: "7%,7%"` でタップする
- フッターまでのスクロール: `swipe: start "50%,80%" → end "50%,20%"` を4回繰り返すと末尾の「以前購入した方はこちら」まで到達する

## 1. 表示・基本レイアウト

- [x] **シート表示**: 設定画面のプレミアム紹介行など任意の起動経路からタップすると、`PremiumIntroductionSheet` が画面下からモーダル(DraggableScrollableSheet)で表示される
- [x] **ヘッダーロゴ表示**: シート上部に pilll premium のロゴ画像(`pillll_premium_logo.svg`)が表示される
- [x] **閉じるボタン**: シート左上の×アイコンをタップするとシートが閉じてもとの画面に戻る
- [x] **フッター法的リンク表示**: フッターにプライバシーポリシー・利用規約・特定商取引法・詳細ページへのリンクが表示され、各リンクをタップすると inAppBrowser で対応する外部ページが開く

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **シート表示**: 設定画面のプレミアム紹介行など任意の起動経路からタップすると、`PremiumIntroductionSheet` が画面下からモーダル(DraggableScrollableSheet)で表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

設定画面の「プレミアムプランを見る」からシートがモーダルで表示されることを確認。2026-10-08 には記録画面の表示モード・設定の自動追加トグル・カレンダーのロック表示の各経路からも同じシートが開くことを確認した (各 feature の QA.md を参照)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/7f9c0b3a-1b99-4378-9e57-41fcdf139dc0-premium-sheet.png" width="320">

</details>

### **ヘッダーロゴ表示**: シート上部に pilll premium のロゴ画像(`pillll_premium_logo.svg`)が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

シート上部に Pilll Premium のロゴが表示されることを確認 (シート表示のスクショと同一画面)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/7f9c0b3a-1b99-4378-9e57-41fcdf139dc0-premium-sheet.png" width="320">

</details>

### **閉じるボタン**: シート左上の×アイコンをタップするとシートが閉じてもとの画面に戻る

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

左上の × をタップするとシートが閉じ、設定画面に戻ることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/d62820b8-bf34-4896-bc97-e575d0a62028-premium-closed.png" width="320">

</details>

### **フッター法的リンク表示**: フッターにプライバシーポリシー・利用規約・特定商取引法・詳細ページへのリンクが表示され、各リンクをタップすると inAppBrowser で対応する外部ページが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

フッターにプライバシーポリシー / 利用規約 / 特定商取引法に基づく表示 / 詳細はこちら / 以前購入した方はこちら のリンクが表示されること (1 枚目)、「プライバシーポリシー」をタップすると bannzai.github.io の「Pilllプライバシーポリシー」がアプリ内ブラウザで開くこと (2 枚目) を確認。他のリンクも同じ `launchUrl(..., mode: LaunchMode.inAppBrowserView)` の実装。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/e1880156-5d44-4d05-a5a0-d3a51b0b80c7-premium-footer.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/e512296f-c640-4491-af8b-2bd2eade44ca-premium-privacy-crop.png" width="320">

</details>

</details>

---

## 2. 購入プラン表示

- [x] **月額/年額ボタン表示**: 非プレミアムユーザーがシートを開くと、月額プラン・年額プランのボタンが価格と日割り額付きで表示される
- [x] **年額の割引バッジ表示**: 年額プランボタンの右上に月額比の割引率バッジ(例: 「◯％OFF」)が表示される
- [x] **買い切りプラン表示 (iOSのみ)**: iOS では月額・年額に加えて買い切り(lifetime)プランのボタンが表示される (Android で表示されないことの確認は Android 環境が無く本 QA の対象外)
- [ ] **プレミアム会員時の表示切り替え**: 既にプレミアムのユーザーでシートを開くと購入ボタン一式が表示されず、代わりにジュエル画像と「プレミアム会員です」の感謝メッセージが表示される
  - ⏭️ スキップ: dev 環境でプレミアム状態を再現する手段がない。実購入には Sandbox テスターアカウントが必要 (本 QA では未提供)。コードレビューでは `premium_introduction_sheet.dart` の `if (user.isPremium)` 分岐で `PremiumUserThanksRow` に切り替わることを確認済み

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **月額/年額ボタン表示**: 非プレミアムユーザーがシートを開くと、月額プラン・年額プランのボタンが価格と日割り額付きで表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

月額プラン ($2.99/月・¥0.10/日) と年額プラン ($27.49/年・¥0.08/日) が日割り額付きで表示されることを確認 (StoreKit テスト環境のため USD 表記)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/7f9c0b3a-1b99-4378-9e57-41fcdf139dc0-premium-sheet.png" width="320">

</details>

### **年額の割引バッジ表示**: 年額プランボタンの右上に月額比の割引率バッジ(例: 「◯％OFF」)が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

年額プランボタン右上に「通常月額と比べて42%OFF」バッジが表示されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/7f9c0b3a-1b99-4378-9e57-41fcdf139dc0-premium-sheet.png" width="320">

</details>

### **買い切りプラン表示 (iOSのみ)**: iOS では月額・年額に加えて買い切り(lifetime)プランのボタンが表示される (Android で表示されないことの確認は Android 環境が無く本 QA の対象外)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

iOS シミュレータで買い切りプラン ($69.99・「一度の購入でずっとプレミアム」) が表示されることを確認。Android での非表示は未確認 (iOS シミュレータでの QA のため)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/7f9c0b3a-1b99-4378-9e57-41fcdf139dc0-premium-sheet.png" width="320">

</details>

### **プレミアム会員時の表示切り替え**: 既にプレミアムのユーザーでシートを開くと購入ボタン一式が表示されず、代わりにジュエル画像と「プレミアム会員です」の感謝メッセージが表示される

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: チェックリスト側に記載の理由によりプレミアム状態を再現できず未実行

</details>

</details>

---

## 3. 購入・復元操作

- [x] **購入ボタンタップで購入フロー開始**: 月額/年額/買い切りボタンのいずれかをタップすると StoreKit の購入フロー (シミュレータでは Apple Account のサインインダイアログ) が起動する。タップ直後の HUD ローディングはスクリーンショットに捉えていない
  - 実課金確認は本番環境では不可のため、Sandbox テスターアカウントでの購入フローの遷移確認に留める
- [ ] **購入完了ダイアログ**: 購入成功時に「登録が完了しました」ダイアログがジュエル画像付きで表示され、OKタップでダイアログとシートの両方が閉じる
  - ⏭️ スキップ: Sandbox テスターアカウント (Apple Account の認証情報) が本 QA では提供されておらず実購入が完了できないため未実行
    - 起動条件: ローカル sim-boot。`SIMSLIM_EXCEPT=store,health,icloud` / `SLIM_STATUS=APPLIED` (2026-10-05)
    - デーモン: icloud カテゴリを有効にした状態で OS の「Apple Account にサインイン」ダイアログに到達しており、デーモン不足ではなく認証情報の不足が原因 (`launchctl list` の出力は取っていない。`SIMSLIM_EXCEPT=store` だけで起動した 2026-10-04 の記録ではダイアログが出ずに `Purchase was cancelled.` で即座に失敗したと前のセッションがメモしているが、本セッションではその差を再現して確かめていない)
    - 試した手順: 月額プランをタップ → サインインダイアログ → 認証情報が無く「キャンセル」で中断 (「購入ボタンタップでローディング表示」のスクショ)
- [ ] **購入エラー時のアラート表示**: 購入失敗(Sandbox でのキャンセル操作等)時にエラーアラートが表示され、シートは閉じずに操作をやり直せる
  - ⏭️ スキップ: 月額プランボタンタップ後の Apple Account サインインダイアログで「キャンセル」を選ぶとエラーアラートは表示されない (仕様どおり。`map_to_error.dart` の `purchaseCancelledError` は意図的に `null` を返す)。Sandbox テスターアカウントが無く、購入ボタン経由の実際の購入失敗 (無効レシート等) を再現できないため未確認。同じ `showErrorAlert` の機構は「復元購入」でアラートが表示されることを確認済み
    - 起動条件・デーモン・試した手順: 「購入完了ダイアログ」と同じ
- [x] **復元購入**: フッターの「以前に購入した内容を復元」をタップし、購入履歴がない Sandbox アカウントではエラーアラートが表示されることを確認する。有効な購入がある場合は復元成功のスナックバーが表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **購入ボタンタップで購入フロー開始**: 月額/年額/買い切りボタンのいずれかをタップすると StoreKit の購入フロー (シミュレータでは Apple Account のサインインダイアログ) が起動する。タップ直後の HUD ローディングはスクリーンショットに捉えていない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

`SIMSLIM_EXCEPT=store,health,icloud` で icloud デーモンを有効にしたシミュレータで月額プランをタップすると、StoreKit 購入フローの一部として「Apple Account にサインイン」ダイアログが起動すること (1 枚目) を確認。「キャンセル」を選ぶとダイアログが閉じ、シートはそのまま残りアラートは出ないこと (2 枚目) を確認。icloud デーモンを無効にした 2026-10-04 の起動では、タップから約 0.2 秒で `Purchase was cancelled.` (PURCHASE_CANCELLED) のログだけが出て購入シートは表示されなかった。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/2831ead4-d10a-4d0f-97c1-4d5fe981b4c1-premium-purchase.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/7591177c-f2a9-46fa-b745-ac149cca7d30-premium-purchase-cancel.png" width="320">

</details>

### **購入完了ダイアログ**: 購入成功時に「登録が完了しました」ダイアログがジュエル画像付きで表示され、OKタップでダイアログとシートの両方が閉じる

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: Sandbox テスターアカウントが本 QA では提供されておらず実購入が完了できないため未実行

</details>

### **購入エラー時のアラート表示**: 購入失敗(Sandbox でのキャンセル操作等)時にエラーアラートが表示され、シートは閉じずに操作をやり直せる

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: サインインキャンセル操作ではアラートが出ない (意図した挙動) ため、購入ボタン経由でのエラーアラート表示は未確認

</details>

### **復元購入**: フッターの「以前に購入した内容を復元」をタップし、購入履歴がない Sandbox アカウントではエラーアラートが表示されることを確認する。有効な購入がある場合は復元成功のスナックバーが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

「以前購入した方はこちら」をタップし、購入履歴がないため「エラーが発生しました / 以前の購入情報が見つかりません。アカウントをお確かめの上再度お試しください」のアラートが表示され、シートは閉じずに残ることを確認。有効な購入がある場合の復元成功スナックバーは、有効な購入がないため未確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/d3f2ee5c-c635-4acb-85fc-be4226fcfec4-premium-restore.png" width="320">

</details>

</details>

---

## 4. その他導線・エッジケース

- [x] **プレミアム機能一覧へのリンク**: 「プレミアム機能を見る」ボタンをタップすると外部ブラウザでプレミアム機能紹介ページが開く
- [x] **期間限定割引の表示 (該当ユーザーのみ)**: 割引権限(`hasDiscountEntitlement`)を持つユーザーでは、通常価格に取り消し線を引いた割引訴求と期限までのカウントダウンが月額プランボタンの上部に表示される
  - 訂正: この割引権限はバックエンド側の個別付与が不要で、初期設定完了時(`EndInitialSetting`, lib/provider/user.dart)に全ユーザーへ自動的に`discountEntitlementDeadlineDate`が設定される(Remote Configのオフセット日数に基づく)。新規アカウントで初期設定を完了するだけで通常操作で再現できることを確認した
- [ ] **オファリング取得失敗時のエラー画面**: 機内モード等でオファリング取得に失敗した状態でシートを開くと、エラーページが表示され、再読み込み操作でオファリング再取得を試みられる
  - ⏭️ スキップ: この iOS シミュレータの Settings アプリに Wi-Fi/機内モードのトグルが存在せず、シミュレータ単体でネットワークを切断する手段がない。Mac 本体のネットワークを切ると並行して動く他のセッションに影響するため実施を見送った。コードレビューでは `premium_introduction_sheet.dart` の `AsyncValueGroup.group2(...).when(error: ...)` が `UniversalErrorPage` を表示し、reload で `purchaseOfferingsProvider` / `refreshAppProvider` を再取得することを確認済み
    - 起動条件: ローカル sim-boot。`SIMSLIM_EXCEPT=store,health,icloud` / `SLIM_STATUS=APPLIED` (2026-10-05)
    - デーモン: ネットワークの切断はデーモンの有無に依らない操作のため該当なし
    - 試した手順: シミュレータの Settings アプリで Wi-Fi / 機内モードのトグルを探したが存在しなかった。Mac 本体のネットワーク切断は他のセッションへの影響のため行っていない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **プレミアム機能一覧へのリンク**: 「プレミアム機能を見る」ボタンをタップすると外部ブラウザでプレミアム機能紹介ページが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

「プレミアム機能を見る」をタップすると pilll.notion.site の「プレミアム機能」ページがアプリ内ブラウザで開くことを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/48809161-f041-4abe-876c-ad23bbd97f58-premium-features.png" width="320">

</details>

### **期間限定割引の表示 (該当ユーザーのみ)**: 割引権限(`hasDiscountEntitlement`)を持つユーザーでは、通常価格に取り消し線を引いた割引訴求と期限までのカウントダウンが月額プランボタンの上部に表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

初期設定完了後の匿名アカウントで「今なら限定価格でずっと使える」の割引訴求 (通常 月額プラン $3.99 の取り消し線) とカウントダウン (1150:09:28) が表示されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/7f9c0b3a-1b99-4378-9e57-41fcdf139dc0-premium-sheet.png" width="320">

</details>

### **オファリング取得失敗時のエラー画面**: 機内モード等でオファリング取得に失敗した状態でシートを開くと、エラーページが表示され、再読み込み操作でオファリング再取得を試みられる

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: チェックリスト側に記載の理由によりネットワーク切断を再現できず未実行

</details>

</details>
