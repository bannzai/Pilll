---
feature: special_offering
verification: mobile-mcp
last_verified_commit: null
last_verified_at: null
---

# special_offering QA

## 1. 表示・起動

- [ ] **バー1からの起動 (年額オファー)**: 記録画面の特別オファーバー(`SpecialOfferingAnnouncementBar`)をタップすると、`SpecialOfferingPage` がドラッグ不可のモーダル(高さ90%)で表示される
- [ ] **バー2からの起動 (月額オファー)**: 別の特別オファーバー(`SpecialOfferingAnnouncementBar2`、未記録日数に応じた文言が出る方)をタップすると、`SpecialOfferingPage2` が同様にモーダル表示される
- [ ] **スワイプ・外側タップでは閉じない**: `enableDrag: false` / `isDismissible: false` のため、シートを下にスワイプしたり背景をタップしても画面が閉じないことを確認する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

（未実行）

</details>

---

## 2. 閉じる操作・確認ダイアログ

- [ ] **×ボタンで確認ダイアログ表示**: AppBar 左上の×アイコンをタップすると「本当に閉じますか？」の確認ダイアログが表示される
- [ ] **「閉じない」選択**: ダイアログで「閉じない」をタップするとダイアログのみ閉じ、特別オファー画面は表示されたままになる
- [ ] **「閉じる」選択で画面が閉じる**: ダイアログで「閉じる」をタップすると特別オファー画面が閉じ、元の記録画面に戻る。以後同一セッション中は該当バーが再表示されない(`specialOfferingIsClosed` / `specialOfferingIsClosed2` フラグ)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

（未実行）

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

（未実行）

</details>

---

## 4. その他導線

- [ ] **プレミアム機能一覧リンク**: 「プレミアム機能を見る」ボタンをタップすると外部ブラウザでプレミアム機能紹介ページが開く
- [ ] **復元購入**: フッターの「以前に購入した内容を復元」から購入復元フローが動作し、購入履歴がない場合はエラーアラートが表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

（未実行）

</details>
