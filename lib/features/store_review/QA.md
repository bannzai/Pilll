---
feature: store_review
verification: mobile-mcp
last_verified_commit: null
last_verified_at: null
---

# store_review QA

## 1. 表示条件

- [ ] **条件成立時に自動表示**: 服薬記録アクション回数(`totalCountOfActionForTakenPill`)が10回を超え、かつ未回答(`isAlreadyAnsweredPreStoreReviewModal` が false)、かつ日本語ロケールの3条件が揃った状態でホーム画面を開くと、`PreStoreReviewModal` がボトムシートで自動表示される
  - Simulator で再現する場合は SharedPreferences の該当キーを直接書き換えるか、服薬記録操作を11回以上行って条件を満たす
- [ ] **一度回答すると再表示されない**: モーダルで「満足」または「不満」を選び確認ボタンを押すと `isAlreadyAnsweredPreStoreReviewModal` が true になり、以後ホーム画面を開いてもモーダルが再表示されない
- [ ] **非日本語ロケールでは表示されない**: 端末言語を日本語以外に設定していると、条件を満たしていてもモーダルが表示されない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

（未実行）

</details>

---

## 2. 回答フロー (満足)

- [ ] **満足カードの選択**: 「満足」(good)カードをタップすると選択枠がハイライトされ、確認ボタンが表示される
- [ ] **満足確定でお礼ダイアログ表示**: 確認ボタンをタップすると「ご協力ありがとうございます」ダイアログが表示される
- [ ] **アンケートへの遷移**: お礼ダイアログの「参加する」をタップすると満足用のGoogleフォームがWebView画面で開く。フォーム画面を閉じると完了ダイアログが表示され、閉じるとモーダル全体が閉じる
- [ ] **満足回答でストアレビュー許可フラグが保存される**: 満足を選択すると `isPreStoreReviewGoodAnswer` が true で保存され、以後の服薬記録アクション時にネイティブストアレビューのリクエスト対象になる
  - ネイティブの StoreKit レビューダイアログは実機・Simulator ともに表示回数制限があり確実な実表示確認が難しい。SharedPreferences の値変化で代替確認する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

（未実行）

</details>

---

## 3. 回答フロー (不満)

- [ ] **不満カードの選択**: 「不満」(bad)カードをタップすると選択枠がハイライトされ、確認ボタンが表示される
- [ ] **不満確定でもお礼ダイアログ表示**: 確認ボタンをタップすると同様にお礼ダイアログが表示され、「参加する」をタップすると不満用の別URLのGoogleフォームがWebViewで開く
- [ ] **「力になれない」選択時は何もせず閉じる**: お礼ダイアログで「力になれない」をタップすると、フォームを開かずにダイアログとモーダルが閉じる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

（未実行）

</details>
