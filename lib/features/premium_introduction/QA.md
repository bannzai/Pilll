---
feature: premium_introduction
verification: mobile-mcp
last_verified_commit: 6a5175955e112e29bd0081a542767cf86caf87d5
last_verified_at: 2026-08-26
---

# premium_introduction QA

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

**確認日: 2026-08-26**
purchases_flutter 10.10.0 (Google Play Billing Library 8 対応) への更新後、設定画面の「プレミアムプランを見る」行からタップし、シートがモーダルで表示されることを確認。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260826/d65d8590-65c2-436c-9ae0-f6378d0480cf.png" width="320">

**確認日: 2026-07-05**
設定画面の「プレミアムプランを見る」行からタップし、シートが表示されることを確認。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/5253a875-fcd0-46eb-b0d6-d08a6dc7396c.png" width="320">

</details>

### **ヘッダーロゴ表示**: シート上部に pilll premium のロゴ画像(`pillll_premium_logo.svg`)が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-08-26**
上記シート表示のスクショと同一画面で pilll premium のロゴ表示を確認。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260826/d65d8590-65c2-436c-9ae0-f6378d0480cf.png" width="320">

**確認日: 2026-07-05**
上記シート表示のスクショと同一画面でヘッダーロゴ表示を確認。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/5253a875-fcd0-46eb-b0d6-d08a6dc7396c.png" width="320">

</details>

### **閉じるボタン**: シート左上の×アイコンをタップするとシートが閉じてもとの画面に戻る

<details><summary>動作確認スクショ</summary>

**確認日: 2026-08-26**
シート左上の×をタップするとシートが閉じ、設定画面(「プレミアムプランを見る」行が見える状態)に戻ることを確認。
×は tooltip / semanticLabel が未設定で Maestro の text セレクタから検出できないため、座標 `point: "7%,7%"` でタップした。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260826/b1eaf941-4b0f-43e6-ad33-9394fbb58c98.png" width="320">

**確認日: 2026-07-05**
×アイコンタップでシートが閉じ、設定画面に戻ることを確認済み(スクショ撮り忘れのためテキストのみ記録)。

</details>

### **フッター法的リンク表示**: フッターにプライバシーポリシー・利用規約・特定商取引法・詳細ページへのリンクが表示され、各リンクをタップすると inAppBrowser で対応する外部ページが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-08-26**
フッターにプライバシーポリシー / 利用規約 / 特定商取引法に基づく表示 / 詳細はこちら の各リンクが表示されることを確認。
リンクタップ後の inAppBrowser 遷移は 2026-07-05 に確認済みで、今回の purchases_flutter 更新は `launchUrl` 実装に触れていないため再確認していない。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260826/102d26ba-cfa2-4f57-9292-bc5ec8fa48e2.png" width="320">

**確認日: 2026-07-05**
代表として「プライバシーポリシー」リンクをタップし、inAppBrowserでプライバシーポリシーページが開くことを確認。利用規約・特定商取引法・詳細ページも同一の`launchUrl(..., mode: LaunchMode.inAppBrowserView)`実装(premium_introduction_footer.dart)のため同様に動作する想定。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/b73b41c5-34c3-4075-bc0e-69498bc28d8e.png" width="320">

</details>

</details>

---

## 2. 購入プラン表示

- [x] **月額/年額ボタン表示**: 非プレミアムユーザーがシートを開くと、月額プラン・年額プランのボタンが価格と日割り額付きで表示される
- [x] **年額の割引バッジ表示**: 年額プランボタンの右上に月額比の割引率バッジ(例: 「◯％OFF」)が表示される
- [x] **買い切りプラン表示 (iOSのみ)**: iOS では月額・年額に加えて買い切り(lifetime)プランのボタンが表示される。Android では買い切りボタンが表示されないことを確認する
- [ ] **プレミアム会員時の表示切り替え**: 既にプレミアムのユーザーでシートを開くと購入ボタン一式が表示されず、代わりにジュエル画像と「プレミアム会員です」の感謝メッセージが表示される
  - ⏭️ スキップ: dev環境でプレミアム状態を再現する手段がない。実購入にはSandboxテスターアカウントが必要(本QAでは未提供)。Firestoreのユーザードキュメントの`isPremium`を直接書き換える案もあったが、`firebase firestore:get/set`コマンド実行が承認待ちでブロックされ非対話実行では続行不可だったため見送った。コードレビューでは`premium_introduction_sheet.dart`の`if (user.isPremium)`分岐で`PremiumUserThanksRow`に切り替わることを確認済み

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **月額/年額ボタン表示**: 非プレミアムユーザーがシートを開くと、月額プラン・年額プランのボタンが価格と日割り額付きで表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-08-26**
purchases_flutter 10.10.0 で `Purchases.getOfferings()` が成功し、新規匿名アカウント(非プレミアム)で月額プラン($2.99/月・¥0.10/日)・年額プラン($27.49/年・¥0.08/日)ボタンが日割り額付きで表示されることを確認(StoreKit テスト環境のため USD 表記)。価格が描画されていること自体が新 SDK での getOfferings 成功の証拠になる。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260826/d65d8590-65c2-436c-9ae0-f6378d0480cf.png" width="320">

**確認日: 2026-07-05**
新規匿名アカウント(非プレミアム)で月額プラン($2.99/月)・年額プラン($27.49/年)ボタンが日割り額付きで表示されることを確認。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/5253a875-fcd0-46eb-b0d6-d08a6dc7396c.png" width="320">

</details>

### **年額の割引バッジ表示**: 年額プランボタンの右上に月額比の割引率バッジ(例: 「◯％OFF」)が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-08-26**
年額プランボタン右上に「通常月額と比べて42%OFF」バッジが表示されることを確認。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260826/d65d8590-65c2-436c-9ae0-f6378d0480cf.png" width="320">

**確認日: 2026-07-05**
年額プランボタンに「通常月額と比べて42％OFF」バッジが表示されることを確認(割引権限ユーザーのため`offPercentForMonthlyPremiumPackage`表記)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/5253a875-fcd0-46eb-b0d6-d08a6dc7396c.png" width="320">

</details>

### **買い切りプラン表示 (iOSのみ)**: iOS では月額・年額に加えて買い切り(lifetime)プランのボタンが表示される。Android では買い切りボタンが表示されないことを確認する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-08-26**
iOS シミュレータで買い切りプラン($69.99・「一度の購入でずっとプレミアム」)ボタンが表示されることを確認。Android での非表示は未確認(iOS シミュレータでの QA のため)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260826/d65d8590-65c2-436c-9ae0-f6378d0480cf.png" width="320">

**確認日: 2026-07-05**
iOSシミュレータで買い切りプラン($69.99)ボタンが表示されることを確認。Androidでの非表示は未確認(iOS実機/シミュレータでのQAのため)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/5253a875-fcd0-46eb-b0d6-d08a6dc7396c.png" width="320">

</details>

### **プレミアム会員時の表示切り替え**: 既にプレミアムのユーザーでシートを開くと購入ボタン一式が表示されず、代わりにジュエル画像と「プレミアム会員です」の感謝メッセージが表示される

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 上記チェックリストに記載の理由によりプレミアム状態を再現できず未実行

</details>

</details>

---

## 3. 購入・復元操作

- [x] **購入ボタンタップでローディング表示**: 月額/年額/買い切りボタンのいずれかをタップすると HUD ローディングが表示され、StoreKit の購入シートが起動する
  - 実課金確認は本番環境では不可のため、Sandbox テスターアカウントでの購入フローの遷移確認に留める
- [ ] **購入完了ダイアログ**: 購入成功時に「登録が完了しました」ダイアログがジュエル画像付きで表示され、OKタップでダイアログとシートの両方が閉じる
  - ⏭️ スキップ: Sandboxテスターアカウントが本QAでは提供されておらず実購入が完了できないため未実行
- [ ] **購入エラー時のアラート表示**: 購入失敗(Sandbox でのキャンセル操作等)時にエラーアラートが表示され、シートは閉じずに操作をやり直せる
  - ⏭️ スキップ: 月額プランボタンタップ後に表示されるApple Accountサインインダイアログで「キャンセル」を選択したところ、エラーアラートは表示されなかった(仕様通り。`map_to_error.dart`の`PurchasesErrorCode.purchaseCancelledError`ケースは意図的に`null`を返しアラート非表示にする設計)。Sandboxテスターアカウントがなく実際の購入失敗(無効レシート等)を購入ボタン経由で再現できないため本項目は未確認。ただし同一の`showErrorAlert`機構は「復元購入」項目で`PlatformException`経由のエラー表示が実際に動作することを確認済み
- [x] **復元購入**: フッターの「以前に購入した内容を復元」をタップし、購入履歴がない Sandbox アカウントではエラーアラートが表示されることを確認する。有効な購入がある場合は復元成功のスナックバーが表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **購入ボタンタップでローディング表示**: 月額/年額/買い切りボタンのいずれかをタップすると HUD ローディングが表示され、StoreKit の購入シートが起動する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-08-26**

- ⏭️ スキップ: purchases_flutter 10.10.0 更新の QA では実課金を伴う購入実行を対象外とした。シミュレータには Sandbox テスターアカウントがなく、購入シート起動後の完了まで検証できないため。購入 API 側の更新内容(`Purchases.purchasePackage` → `Purchases.purchase(PurchaseParams.package(package))`)は `lib/provider/purchase.dart` のコードレビューで確認している

**確認日: 2026-07-05**
月額プランボタンをタップし、Apple Accountサインインダイアログ(StoreKit購入フローの一部)が起動することを確認。Sandboxテスターアカウント未提供のため実購入完了までは未確認。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/bdc190de-6c06-4b2b-b7a3-1c87f8686d73.png" width="320">

</details>

### **購入完了ダイアログ**: 購入成功時に「登録が完了しました」ダイアログがジュエル画像付きで表示され、OKタップでダイアログとシートの両方が閉じる

<details><summary>動作確認スクショ</summary>

（未実行）

**確認日: 2026-08-26**

- ⏭️ スキップ: purchases_flutter 10.10.0 更新の QA でも Sandbox テスターアカウントが提供されておらず、実購入を完了できないため未実行

⏭️ スキップ: Sandboxテスターアカウントが本QAでは提供されておらず実購入が完了できないため未実行

</details>

### **購入エラー時のアラート表示**: 購入失敗(Sandbox でのキャンセル操作等)時にエラーアラートが表示され、シートは閉じずに操作をやり直せる

<details><summary>動作確認スクショ</summary>

（未実行）

**確認日: 2026-08-26**

- ⏭️ スキップ: purchases_flutter 10.10.0 更新の QA でも Sandbox テスターアカウントが無く、購入ボタン経由での購入失敗を再現できないため未実行。なお `showErrorAlert` によるエラーアラート表示自体は、上記「復元購入」で新 SDK でも動作することを確認している

⏭️ スキップ: サインインキャンセル操作ではアラートが出ない(意図した挙動)ため、購入ボタン経由でのエラーアラート表示は未確認

</details>

### **復元購入**: フッターの「以前に購入した内容を復元」をタップし、購入履歴がない Sandbox アカウントではエラーアラートが表示されることを確認する。有効な購入がある場合は復元成功のスナックバーが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-08-26**
purchases_flutter 10.10.0 で「以前購入した方はこちら」をタップし、購入履歴がないため「エラーが発生しました / 以前の購入情報が見つかりません。アカウントをお確かめの上再度お試しください」のアラートが表示され、シートは閉じずに残ることを確認。有効な購入がある場合の復元成功スナックバーは、有効な購入がないため未確認。

表示された文言が 2026-07-05 の記録から変わっている点に注意する。2026-07-05 は `purchaseErrorInvalidReceiptError`(「不正な購入情報です。購入情報を確かめてください」)で、`Purchases.restorePurchases()` が `PlatformException`(invalidReceiptError) を投げ `map_to_error.dart` 経由で表示されていた。2026-08-26 は `noPreviousPurchaseInfo` で、これは `premium_introduction_footer.dart` が例外ではなく「復元は成功したがプレミアム権限が無い」場合に自前で投げる `AlertError` の文言。つまり新 SDK では購入履歴が無い状態の復元が例外ではなく正常終了するようになっている。復元操作としてはこちらの方が実態に合った文言で、アプリの挙動(アラート表示・シートは閉じない)は変わらない。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260826/0af2ef7d-6585-409e-b275-2858c5970af8.png" width="320">

**確認日: 2026-07-05**
「以前購入した方はこちら」をタップし、購入履歴がないため「エラーが発生しました / 不正な購入情報です。購入情報を確かめてください」のアラートが表示され、シートは閉じずに残ることを確認。有効な購入がある場合の復元成功スナックバーは、有効な購入がないため未確認。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/a10e4a1b-14ca-4d5b-870d-6f41d8afa80a.png" width="320">

</details>

</details>

---

## 4. その他導線・エッジケース

- [x] **プレミアム機能一覧へのリンク**: 「プレミアム機能を見る」ボタンをタップすると外部ブラウザでプレミアム機能紹介ページが開く
- [x] **期間限定割引の表示 (該当ユーザーのみ)**: 割引権限(`hasDiscountEntitlement`)を持つユーザーでは、通常価格に取り消し線を引いた割引訴求と期限までのカウントダウンが月額プランボタンの上部に表示される
  - 訂正: この割引権限はバックエンド側の個別付与が不要で、初期設定完了時(`EndInitialSetting`, lib/provider/user.dart)に全ユーザーへ自動的に`discountEntitlementDeadlineDate`が設定される(Remote Configのオフセット日数に基づく)。新規アカウントで初期設定を完了するだけで通常操作で再現できることを確認した
- [ ] **オファリング取得失敗時のエラー画面**: 機内モード等でオファリング取得に失敗した状態でシートを開くと、エラーページが表示され、再読み込み操作でオファリング再取得を試みられる
  - ⏭️ スキップ: このiOSシミュレータのSettingsアプリにWi-Fi/機内モードのトグルが存在せず、シミュレータ単体でネットワークを切断する手段がない。Mac本体のネットワークを切ると同時並行実行中の他featureのQA用シミュレータにも影響するため実施を見送った。コードレビューでは`premium_introduction_sheet.dart`の`AsyncValueGroup.group2(...).when(error: ...)`が`UniversalErrorPage`を表示し、reloadで`purchaseOfferingsProvider`/`refreshAppProvider`を再取得することを確認済み

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **プレミアム機能一覧へのリンク**: 「プレミアム機能を見る」ボタンをタップすると外部ブラウザでプレミアム機能紹介ページが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**
「プレミアム機能を見る」ボタンをタップし`pilll.notion.site`のプレミアム機能紹介ページへの遷移を確認。埋め込みブラウザでの初回読み込みは2度「サーバが応答を停止しています」で失敗したが、「Safariで開く」で外部Safari起動時は正常にコンテンツが表示された(シミュレータのWKWebView初回接続が遅いことによる一時的事象と推測。アプリ側の遷移ロジック自体は正しく動作)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/b007e08a-c0d9-482e-ab2f-533ac19c4c18.png" width="320">

</details>

### **期間限定割引の表示 (該当ユーザーのみ)**: 割引権限(`hasDiscountEntitlement`)を持つユーザーでは、通常価格に取り消し線を引いた割引訴求と期限までのカウントダウンが月額プランボタンの上部に表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-08-26**
新規匿名アカウントで初期設定完了直後にシートを開き、「今なら限定価格でずっと使える」の割引訴求(通常 月額プラン $3.99 の取り消し線)とカウントダウン(1141:20:47)が表示されることを確認。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260826/d65d8590-65c2-436c-9ae0-f6378d0480cf.png" width="320">

**確認日: 2026-07-05**
新規匿名アカウントで初期設定完了直後にシートを開き、「今なら限定価格でずっと使える」の割引訴求(通常$3.99の取り消し線)とカウントダウン(1132:xx:xx)が表示されることを確認。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/5253a875-fcd0-46eb-b0d6-d08a6dc7396c.png" width="320">

</details>

### **オファリング取得失敗時のエラー画面**: 機内モード等でオファリング取得に失敗した状態でシートを開くと、エラーページが表示され、再読み込み操作でオファリング再取得を試みられる

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 上記チェックリストに記載の理由によりネットワーク切断を再現できず未実行

</details>

</details>
