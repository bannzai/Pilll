---
feature: special_offering
verification: mobile-mcp
last_verified_commit: 34b7e05eb0ed73e5ee0caa2a91a96147e2edaded
last_verified_at: 2026-07-06
---

# special_offering QA

## 1. 表示・起動

- [ ] **バー1からの起動 (年額オファー)**: 記録画面の特別オファーバー(`SpecialOfferingAnnouncementBar`)をタップすると、`SpecialOfferingPage` がドラッグ不可のモーダル(高さ90%)で表示される
- [ ] **バー2からの起動 (月額オファー)**: 別の特別オファーバー(`SpecialOfferingAnnouncementBar2`、未記録日数に応じた文言が出る方)をタップすると、`SpecialOfferingPage2` が同様にモーダル表示される
- [ ] **スワイプ・外側タップでは閉じない**: `enableDrag: false` / `isDismissible: false` のため、シートを下にスワイプしたり背景をタップしても画面が閉じないことを確認する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **バー1からの起動 (年額オファー)**: 記録画面の特別オファーバー(`SpecialOfferingAnnouncementBar`)をタップすると、`SpecialOfferingPage` がドラッグ不可のモーダル(高さ90%)で表示される

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: `SpecialOfferingAnnouncementBar` の表示条件(`lib/features/record/components/announcement_bar/announcement_bar.dart` の `_body`)は、非プレミアム・非トライアルの状態で `daysBetween(userBeginDate, today) >= remoteConfigParameter.specialOfferingUserCreationDateTimeOffset` を満たす必要がある。`userBeginDate` は `firebaseAuthUser.metadata.creationTime`（Firebase Auth のアカウント作成日時で不変）。dev環境の実際の Remote Config 値をアプリ起動ログで確認したところ `specialOfferingUserCreationDateTimeOffset = 40000`（日）だった。QA では匿名サインインで作成した新規アカウントを使うため経過日数は実質0日であり、しきい値に到達せずこのバーは表示されない。加えて、トライアル解除直後は `discountEntitlementDeadlineDate` による割引期限バー（`DiscountPriceDeadline`。コード上この判定が特別オファーより先に評価される）が優先表示され、実機でも記録画面に「プレミアム登録で引き続きすべての機能が利用できます　1135:30:08内の購入で42%OFF」（割引期限まで残り約47日）が表示されることを確認した。設定画面の開発者オプション「FeatureAppeal AnnouncementBar 一覧」は `FeatureAppealBarsContainer` 系バーのみが対象で special_offering 系バーは含まれない（コード上も `showSpecialOfferingPage` の呼び出し箇所はこのバーのみと確認済みで、他に直接開くデバッグ導線は無い）。アカウント作成日時を人為的に操作する手段（Firebase Remote Config の dev 環境上書き確認、バックエンド経由でのアカウント作成日時変更）は今回のセッション権限内では実行できず、`SpecialOfferingPage` を開けなかったため以降の全項目も同様の理由で未実施

</details>

### **バー2からの起動 (月額オファー)**: 別の特別オファーバー(`SpecialOfferingAnnouncementBar2`、未記録日数に応じた文言が出る方)をタップすると、`SpecialOfferingPage2` が同様にモーダル表示される

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: `SpecialOfferingAnnouncementBar2` の表示条件も同じ `announcement_bar.dart` の `_body` にあり、`daysBetween(userBeginDate, today)` が `specialOfferingUserCreationDateTimeOffsetSince`(dev環境の実際の値: 390日、アプリ起動ログで確認)以上 `specialOfferingUserCreationDateTimeOffsetUntil`(同: 400日)以下、かつ直近30日の服用未記録日数が1日以上、という条件を満たす必要がある。「バー1からの起動」と同じ理由（新規アカウントのため経過日数が0日であること、割引期限バーが優先表示されること、直接開くデバッグ導線が無いこと）により本セッションでは条件を満たせず未実施

</details>

### **スワイプ・外側タップでは閉じない**: `enableDrag: false` / `isDismissible: false` のため、シートを下にスワイプしたり背景をタップしても画面が閉じないことを確認する

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 「バー1/バー2からの起動」がいずれも条件未達で `SpecialOfferingPage` / `SpecialOfferingPage2` 自体を開けなかったため未実施

</details>

</details>

---

## 2. 閉じる操作・確認ダイアログ

- [ ] **×ボタンで確認ダイアログ表示**: AppBar 左上の×アイコンをタップすると「本当に閉じますか？」の確認ダイアログが表示される
- [ ] **「閉じない」選択**: ダイアログで「閉じない」をタップするとダイアログのみ閉じ、特別オファー画面は表示されたままになる
- [ ] **「閉じる」選択で画面が閉じる**: ダイアログで「閉じる」をタップすると特別オファー画面が閉じ、元の記録画面に戻る。以後同一セッション中は該当バーが再表示されない(`specialOfferingIsClosed` / `specialOfferingIsClosed2` フラグ)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **×ボタンで確認ダイアログ表示**: AppBar 左上の×アイコンをタップすると「本当に閉じますか？」の確認ダイアログが表示される

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 「1. 表示・起動」参照。`SpecialOfferingPage` / `SpecialOfferingPage2` の表示条件（アカウント作成からの経過日数）を満たせず画面自体を開けなかったため未実施

</details>

### **「閉じない」選択**: ダイアログで「閉じない」をタップするとダイアログのみ閉じ、特別オファー画面は表示されたままになる

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 同上の理由で画面を開けず未実施

</details>

### **「閉じる」選択で画面が閉じる**: ダイアログで「閉じる」をタップすると特別オファー画面が閉じ、元の記録画面に戻る。以後同一セッション中は該当バーが再表示されない(`specialOfferingIsClosed` / `specialOfferingIsClosed2` フラグ)

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 同上の理由で画面を開けず未実施

</details>

</details>

---

## 3. 購入導線

- [ ] **割引アピール表示**: 通常の月額価格に取り消し線を引いた割引訴求(`PremiumIntroductionDiscountAppeal`)が画面上部に表示される
- [ ] **年額購入ボタン (page.dart)**: 特別価格の年額プランボタンが表示され、タップで StoreKit の購入フローが開始する(Sandbox アカウントで遷移確認)
- [ ] **月額購入ボタン (page2.dart)**: 特別価格の月額プランボタンが表示され、タップで StoreKit の購入フローが開始する(Sandbox アカウントで遷移確認)
- [ ] **購入完了ダイアログ**: 購入成功時に完了ダイアログが表示され、OKタップでダイアログと特別オファー画面の両方が閉じる
- [ ] **購入エラー時のアラート**: 購入失敗時にエラーアラートが表示され、画面は閉じずにやり直せる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **割引アピール表示**: 通常の月額価格に取り消し線を引いた割引訴求(`PremiumIntroductionDiscountAppeal`)が画面上部に表示される

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 「1. 表示・起動」参照。画面自体を開けなかったため未実施

</details>

### **年額購入ボタン (page.dart)**: 特別価格の年額プランボタンが表示され、タップで StoreKit の購入フローが開始する(Sandbox アカウントで遷移確認)

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 「1. 表示・起動」参照。画面自体を開けなかったため未実施。加えて `page.dart` の年額購入ボタンは `annualSpecialOfferingPackageProvider`（RevenueCat の `specialOffering` オファリング識別子配下の annual パッケージ）が非nullであることが前提で、null の間は `ScaffoldIndicator`（読み込み中表示）のままになる。RevenueCat dev 環境に `specialOffering` オファリングが実際に設定されているかは本セッションでは未確認

</details>

### **月額購入ボタン (page2.dart)**: 特別価格の月額プランボタンが表示され、タップで StoreKit の購入フローが開始する(Sandbox アカウントで遷移確認)

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 「1. 表示・起動」参照。画面自体を開けなかったため未実施。加えて `page2.dart` の月額購入ボタンは `monthlySpecialOfferingPackageProvider`（同じく `specialOffering` オファリング識別子配下の monthly パッケージ）が非nullであることが前提で、null の間は `ScaffoldIndicator` のままになる。RevenueCat dev 環境の設定状況は本セッションでは未確認

</details>

### **購入完了ダイアログ**: 購入成功時に完了ダイアログが表示され、OKタップでダイアログと特別オファー画面の両方が閉じる

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 「1. 表示・起動」参照。画面自体を開けなかったため未実施

</details>

### **購入エラー時のアラート**: 購入失敗時にエラーアラートが表示され、画面は閉じずにやり直せる

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 「1. 表示・起動」参照。画面自体を開けなかったため未実施

</details>

</details>

---

## 4. その他導線

- [ ] **プレミアム機能一覧リンク**: 「プレミアム機能を見る」ボタンをタップすると外部ブラウザでプレミアム機能紹介ページが開く
- [ ] **復元購入**: フッターの「以前に購入した内容を復元」から購入復元フローが動作し、購入履歴がない場合はエラーアラートが表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **プレミアム機能一覧リンク**: 「プレミアム機能を見る」ボタンをタップすると外部ブラウザでプレミアム機能紹介ページが開く

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 「1. 表示・起動」参照。画面自体を開けなかったため未実施

</details>

### **復元購入**: フッターの「以前に購入した内容を復元」から購入復元フローが動作し、購入履歴がない場合はエラーアラートが表示される

<details><summary>動作確認スクショ</summary>

- ⏭️ スキップ: 「1. 表示・起動」参照。画面自体を開けなかったため未実施

</details>

</details>
