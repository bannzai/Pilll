---
feature: store_review
verification: mobile-mcp
last_verified_commit: 34b7e05eb0ed73e5ee0caa2a91a96147e2edaded
last_verified_at: 2026-07-06
---

# store_review QA

## 1. 表示条件

- [x] **条件成立時に自動表示**: 服薬記録アクション回数(`totalCountOfActionForTakenPill`)が10回を超え、かつ未回答(`isAlreadyAnsweredPreStoreReviewModal` が false)、かつ日本語ロケールの3条件が揃った状態でホーム画面を開くと、`PreStoreReviewModal` がボトムシートで自動表示される
  - Simulator で再現する場合は SharedPreferences の該当キーを直接書き換えるか、服薬記録操作を11回以上行って条件を満たす
- [x] **一度回答すると再表示されない**: モーダルが一度表示されると `isAlreadyAnsweredPreStoreReviewModal` が true になり（実装上は表示時点で保存: `lib/features/home/page.dart`）、以後ホーム画面を開いてもモーダルが再表示されない
- [x] **非日本語ロケールでは表示されない**: 端末言語を日本語以外に設定していると、条件を満たしていてもモーダルが表示されない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **条件成立時に自動表示**: 服薬記録アクション回数(`totalCountOfActionForTakenPill`)が10回を超え、かつ未回答(`isAlreadyAnsweredPreStoreReviewModal` が false)、かつ日本語ロケールの3条件が揃った状態でホーム画面を開くと、`PreStoreReviewModal` がボトムシートで自動表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

本文の但し書きどおり SharedPreferences を直接書き換えて条件を再現（`flutter.totalPillCount` = 11、`flutter.isAlreadyAnsweredPreStoreReviewModal` = false、端末言語は日本語）。アプリを終了→再起動でホーム画面を開くと「Pilllの感想をお聞かせください」のボトムシートが自動表示された。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/9928ae3a-7e59-442f-8ce6-4f93551e4306.png" width="320">

</details>

### **一度回答すると再表示されない**: モーダルが一度表示されると `isAlreadyAnsweredPreStoreReviewModal` が true になり（実装上は表示時点で保存: `lib/features/home/page.dart`）、以後ホーム画面を開いてもモーダルが再表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

満足フロー完了後（`isAlreadyAnsweredPreStoreReviewModal` = true、`totalPillCount` = 11 のまま）にアプリを終了→再起動してホーム画面を開いても、モーダルは再表示されなかった。なお実装ではフラグは回答時ではなく表示時に保存されるため、項目の文言を実装に合わせて修正した。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/788be403-0b61-4503-bfd9-ac73236486cb.png" width="320">

</details>

### **非日本語ロケールでは表示されない**: 端末言語を日本語以外に設定していると、条件を満たしていてもモーダルが表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

表示条件を満たした状態（`flutter.totalPillCount` = 11、`flutter.isAlreadyAnsweredPreStoreReviewModal` = false）で、アプリを en-US ロケールで起動（`-AppleLanguages` 相当のロケール指定起動）。UI が英語表記（`7/6 (Mon)`）になったホーム画面を開いてもモーダルは表示されず、`isAlreadyAnsweredPreStoreReviewModal` も false のまま（= 表示処理自体が走っていない）ことを確認した。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/bc488a63-8e45-4798-a368-7614e286d9a2.png" width="320">

</details>

</details>

---

## 2. 回答フロー (満足)

- [x] **満足カードの選択**: 「満足」(good)カードをタップすると選択枠がハイライトされ、確認ボタンが表示される
- [x] **満足確定でお礼ダイアログ表示**: 確認ボタンをタップすると「ご協力ありがとうございます」ダイアログが表示される
- [x] **アンケートへの遷移**: お礼ダイアログの「協力する」(`L.participate`)をタップすると満足用のGoogleフォームがWebView画面で開く。フォーム画面を閉じると完了ダイアログが表示され、閉じるとモーダル全体が閉じる
- [x] **満足回答でストアレビュー許可フラグが保存される**: 満足を選択すると `isPreStoreReviewGoodAnswer` が true で保存され、以後の服薬記録アクション時にネイティブストアレビューのリクエスト対象になる
  - ネイティブの StoreKit レビューダイアログは実機・Simulator ともに表示回数制限があり確実な実表示確認が難しい。SharedPreferences の値変化で代替確認する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **満足カードの選択**: 「満足」(good)カードをタップすると選択枠がハイライトされ、確認ボタンが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

「満足している」カードをタップすると選択枠がハイライトされ、「決定」ボタンが表示された。なお「決定」ボタン部分に `BOTTOM OVERFLOWED BY 4.0 PIXELS` のレイアウトオーバーフロー（デバッグ表示）を確認。項目自体の期待動作は満たしているため通過とし、オーバーフローは issue として起票した: https://github.com/bannzai/PilllBackend/issues/391

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/a6266b5b-4d49-4f4f-95ca-2714d34986c1.png" width="320">

</details>

### **満足確定でお礼ダイアログ表示**: 確認ボタンをタップすると「ご協力ありがとうございます」ダイアログが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

「決定」タップで「ご協力ありがとうございます」ダイアログが表示された。ボタンは「協力する」（`L.participate`）と「しない」（`L.notHelp`）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/58df90cc-a472-41a3-b49c-a9645255119a.png" width="320">

</details>

### **アンケートへの遷移**: お礼ダイアログの「協力する」(`L.participate`)をタップすると満足用のGoogleフォームがWebView画面で開く。フォーム画面を閉じると完了ダイアログが表示され、閉じるとモーダル全体が閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

「協力する」タップで「サービス改善アンケート」の Google フォームが WebView で開き（1枚目）、戻るで閉じると完了ダイアログが表示され（2枚目）、「閉じる」タップでモーダル全体が閉じてホームに戻った（3枚目）。項目名の「参加する」はローカライズ実体（`L.participate` = 協力する）に合わせて修正した。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/b6df20b2-63a0-42c0-aa9d-d6bea4f50d2e.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/ae706d47-8825-4acd-83d3-d575c0cce177.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/12c9e56e-d307-439a-9643-01b9749ec271.png" width="320">

</details>

### **満足回答でストアレビュー許可フラグが保存される**: 満足を選択すると `isPreStoreReviewGoodAnswer` が true で保存され、以後の服薬記録アクション時にネイティブストアレビューのリクエスト対象になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

本文の但し書きどおり SharedPreferences の値変化で代替確認。満足フロー完了後にアプリコンテナの plist を直接読み、`flutter.isPreStoreReviewGoodAnswer` = true、`flutter.isAlreadyAnsweredPreStoreReviewModal` = true が保存されていることを確認した（ネイティブ StoreKit レビューダイアログは表示回数制限のため実表示は未確認）。

```
"flutter.isAlreadyAnsweredPreStoreReviewModal" => true
"flutter.isPreStoreReviewGoodAnswer" => true
```

</details>

</details>

---

## 3. 回答フロー (不満)

- [x] **不満カードの選択**: 「不満」(bad)カードをタップすると選択枠がハイライトされ、確認ボタンが表示される
- [x] **不満確定でもお礼ダイアログ表示**: 確認ボタンをタップすると同様にお礼ダイアログが表示され、「協力する」をタップすると不満用の別URLのGoogleフォームがWebViewで開く
- [x] **「しない」選択時は何もせず閉じる**: お礼ダイアログで「しない」(`L.notHelp`)をタップすると、フォームを開かずにダイアログとモーダルが閉じる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **不満カードの選択**: 「不満」(bad)カードをタップすると選択枠がハイライトされ、確認ボタンが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

「満足では無い」カードをタップすると選択枠がハイライトされ、「決定」ボタンが表示された（満足側と同じく 4px オーバーフローあり: https://github.com/bannzai/PilllBackend/issues/391 ）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/0ae74891-b1f3-4037-aa73-fc9c19c151b8.png" width="320">

</details>

### **不満確定でもお礼ダイアログ表示**: 確認ボタンをタップすると同様にお礼ダイアログが表示され、「協力する」をタップすると不満用の別URLのGoogleフォームがWebViewで開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

不満選択→「決定」でも満足時と同じお礼ダイアログが表示され（1枚目）、「協力する」タップで不満用フォームが WebView で開いた（2枚目）。フォームの設問が「Pilllの不満点や改善点を教えてください」で、満足用（良かったと思う瞬間）とは別内容の URL（`pre_store_review_modal.dart` の bad 分岐）であることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/dbdf0487-59ca-40bd-9197-96270a5e2f53.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/985e8843-b6ee-45e9-8045-410786e249ca.png" width="320">

</details>

### **「しない」選択時は何もせず閉じる**: お礼ダイアログで「しない」(`L.notHelp`)をタップすると、フォームを開かずにダイアログとモーダルが閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

不満選択→「決定」→お礼ダイアログ（1枚目）で「しない」をタップすると、フォームを開かずにダイアログとモーダルの両方が閉じてホームに戻った（2枚目）。項目名の「力になれない」はローカライズ実体（`L.notHelp` = しない）に合わせて修正した。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/264d4378-241e-4922-8bab-8335dc15590e.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/766a390e-4b47-4306-a79a-9d9a7ed13217.png" width="320">

</details>

</details>
