---
feature: special_offering
verification: mobile-mcp
last_verified_commit: 1abe9113bb377e9d90c42a10ee54feeae9ca058c
last_verified_at: 2026-10-08
---

# special_offering QA

確認環境 (2026-10-05 と 2026-10-08 の記録): iPhone 16 Pro シミュレータ (iOS 27.0、ローカル sim-boot、`SIMSLIM_EXCEPT=store,health,icloud`) の dev ビルド (commit 75c754dd72 を Xcode 26.5 でビルド。`lib/features` は HEAD と同一)。

本 feature の画面は、記録画面の特別オファーバーからしか開けず、バーの表示条件がアカウント作成日からの経過日数 (dev 環境の Remote Config の実測値: `specialOfferingUserCreationDateTimeOffset = 40000` 日、`specialOfferingUserCreationDateTimeOffsetSince / Until = 390 / 400` 日) に依存する。QA で使う新規の匿名アカウントでは条件を満たせないため、全項目をスキップとして記録している。前回リリース以降の変更 (`page.dart` / `page2.dart` の配色・文言の刷新) も同じ理由で画面では未確認。開発者オプションから開く導線を追加すれば確認できる (未実装)。

## 1. 表示・起動

- [ ] **バー1からの起動 (年額オファー)**: 記録画面の特別オファーバー(`SpecialOfferingAnnouncementBar`)をタップすると、`SpecialOfferingPage` がドラッグ不可のモーダル(高さ90%)で表示される
  - ⏭️ スキップ: `SpecialOfferingAnnouncementBar` の表示条件 (`lib/features/record/components/announcement_bar/announcement_bar.dart` の `_body`) は、非プレミアム・非トライアルで `daysBetween(userBeginDate, today) >= specialOfferingUserCreationDateTimeOffset` (dev 環境の実測値 40000 日) を満たす必要がある。`userBeginDate` は Firebase Auth のアカウント作成日時で不変のため、新規の匿名アカウントでは到達できない。トライアル解除直後は `discountEntitlementDeadlineDate` による割引期限バー (`DiscountPriceDeadline`) が優先表示されることを 2026-10-08 に確認した (record の「状態に応じた表示切替」)。開発者オプションに本画面を直接開く導線は無い
- [ ] **バー2からの起動 (月額オファー)**: 別の特別オファーバー(`SpecialOfferingAnnouncementBar2`、未記録日数に応じた文言が出る方)をタップすると、`SpecialOfferingPage2` が同様にモーダル表示される
  - ⏭️ スキップ: 表示条件が `specialOfferingUserCreationDateTimeOffsetSince` (390 日) 以上 `Until` (400 日) 以下かつ直近 30 日に未記録日が 1 日以上で、「バー1からの起動」と同じ理由で新規アカウントでは満たせない
- [ ] **スワイプ・外側タップでは閉じない**: `enableDrag: false` / `isDismissible: false` のため、シートを下にスワイプしたり背景をタップしても画面が閉じないことを確認する
  - ⏭️ スキップ: 画面自体を開けなかったため未実施

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **バー1からの起動 (年額オファー)**: 記録画面の特別オファーバー(`SpecialOfferingAnnouncementBar`)をタップすると、`SpecialOfferingPage` がドラッグ不可のモーダル(高さ90%)で表示される

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: チェックリスト側に記載の理由 (アカウント作成日からの経過日数の条件を満たせない) により未実施

</details>

### **バー2からの起動 (月額オファー)**: 別の特別オファーバー(`SpecialOfferingAnnouncementBar2`、未記録日数に応じた文言が出る方)をタップすると、`SpecialOfferingPage2` が同様にモーダル表示される

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 同上

</details>

### **スワイプ・外側タップでは閉じない**: `enableDrag: false` / `isDismissible: false` のため、シートを下にスワイプしたり背景をタップしても画面が閉じないことを確認する

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

</details>

---

## 2. 閉じる操作・確認ダイアログ

- [ ] **×ボタンで確認ダイアログ表示**: AppBar 左上の×アイコンをタップすると「本当に閉じますか？」の確認ダイアログが表示される
  - ⏭️ スキップ: 「1. 表示・起動」の理由で画面を開けず未実施
- [ ] **「閉じない」選択**: ダイアログで「閉じない」をタップするとダイアログのみ閉じ、特別オファー画面は表示されたままになる
  - ⏭️ スキップ: 同上
- [ ] **「閉じる」選択で画面が閉じる**: ダイアログで「閉じる」をタップすると特別オファー画面が閉じ、元の記録画面に戻る。以後同一セッション中は該当バーが再表示されない(`specialOfferingIsClosed` / `specialOfferingIsClosed2` フラグ)
  - ⏭️ スキップ: 同上

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **×ボタンで確認ダイアログ表示**: AppBar 左上の×アイコンをタップすると「本当に閉じますか？」の確認ダイアログが表示される

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

### **「閉じない」選択**: ダイアログで「閉じない」をタップするとダイアログのみ閉じ、特別オファー画面は表示されたままになる

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

### **「閉じる」選択で画面が閉じる**: ダイアログで「閉じる」をタップすると特別オファー画面が閉じ、元の記録画面に戻る。以後同一セッション中は該当バーが再表示されない(`specialOfferingIsClosed` / `specialOfferingIsClosed2` フラグ)

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

</details>

---

## 3. 購入導線

- [ ] **割引アピール表示**: 通常の月額価格に取り消し線を引いた割引訴求(`PremiumIntroductionDiscountAppeal`)が画面上部に表示される
  - ⏭️ スキップ: 「1. 表示・起動」の理由で画面を開けず未実施
- [ ] **年額購入ボタン (page.dart)**: 特別価格の年額プランボタンが表示され、タップで StoreKit の購入フローが開始する(Sandbox アカウントで遷移確認)
  - ⏭️ スキップ: 同上。加えて `page.dart` の年額購入ボタンは `annualSpecialOfferingPackageProvider` (RevenueCat の `specialOffering` オファリング配下の annual パッケージ) が非 null であることが前提で、null の間は `ScaffoldIndicator` のままになる。RevenueCat dev 環境に `specialOffering` オファリングが設定されているかは未確認
- [ ] **月額購入ボタン (page2.dart)**: 特別価格の月額プランボタンが表示され、タップで StoreKit の購入フローが開始する(Sandbox アカウントで遷移確認)
  - ⏭️ スキップ: 同上 (`monthlySpecialOfferingPackageProvider` が前提)
- [ ] **購入完了ダイアログ**: 購入成功時に完了ダイアログが表示され、OKタップでダイアログと特別オファー画面の両方が閉じる
  - ⏭️ スキップ: 画面を開けないことに加え、Sandbox テスターアカウントが無く実購入を完了できないため未実施
- [ ] **購入エラー時のアラート**: 購入失敗時にエラーアラートが表示され、画面は閉じずにやり直せる
  - ⏭️ スキップ: 同上

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **割引アピール表示**: 通常の月額価格に取り消し線を引いた割引訴求(`PremiumIntroductionDiscountAppeal`)が画面上部に表示される

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

### **年額購入ボタン (page.dart)**: 特別価格の年額プランボタンが表示され、タップで StoreKit の購入フローが開始する(Sandbox アカウントで遷移確認)

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

### **月額購入ボタン (page2.dart)**: 特別価格の月額プランボタンが表示され、タップで StoreKit の購入フローが開始する(Sandbox アカウントで遷移確認)

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

### **購入完了ダイアログ**: 購入成功時に完了ダイアログが表示され、OKタップでダイアログと特別オファー画面の両方が閉じる

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

### **購入エラー時のアラート**: 購入失敗時にエラーアラートが表示され、画面は閉じずにやり直せる

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

</details>

---

## 4. その他導線

- [ ] **プレミアム機能一覧リンク**: 「プレミアム機能を見る」ボタンをタップすると外部ブラウザでプレミアム機能紹介ページが開く
  - ⏭️ スキップ: 「1. 表示・起動」の理由で画面を開けず未実施。同じリンクは premium_introduction の「プレミアム機能一覧へのリンク」で確認済み
- [ ] **復元購入**: フッターの「以前に購入した内容を復元」から購入復元フローが動作し、購入履歴がない場合はエラーアラートが表示される
  - ⏭️ スキップ: 同上。同じ復元フローは premium_introduction の「復元購入」で確認済み

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **プレミアム機能一覧リンク**: 「プレミアム機能を見る」ボタンをタップすると外部ブラウザでプレミアム機能紹介ページが開く

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

### **復元購入**: フッターの「以前に購入した内容を復元」から購入復元フローが動作し、購入履歴がない場合はエラーアラートが表示される

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 画面を開けず未実施

</details>

</details>
