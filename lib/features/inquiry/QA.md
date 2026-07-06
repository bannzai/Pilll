---
feature: inquiry
verification: mobile-mcp
last_verified_commit: 34b7e05eb0ed73e5ee0caa2a91a96147e2edaded
last_verified_at: 2026-07-05
---

# inquiry QA

## 1. 表示

- [x] **画面表示**: 設定画面の「お問い合わせ」からお問い合わせ画面を開くと、タイトル「お問い合わせ」と左上に閉じる（バツ）ボタンが表示される
- [x] **お問い合わせ種別の初期状態**: 「不具合報告」「ご意見・ご要望」「その他」の3種別がラジオボタンで表示され、デフォルトで「不具合報告」が選択されている
- [x] **その他選択時の入力欄**: 「その他」を選択すると自由入力欄（最大100文字）が表示される
- [x] **注意文言の表示**: メールアドレス欄の下に受信設定の注意文（オレンジ文字）とiCloudメール利用不可の注意文（赤文字）が表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **画面表示**: 設定画面の「お問い合わせ」からお問い合わせ画面を開くと、タイトル「お問い合わせ」と左上に閉じる（バツ）ボタンが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/e5957c90-170d-4c4e-856c-0cdd2cf5ac4c.png" width="320">

</details>

### **お問い合わせ種別の初期状態**: 「不具合報告」「ご意見・ご要望」「その他」の3種別がラジオボタンで表示され、デフォルトで「不具合報告」が選択されている

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/e5957c90-170d-4c4e-856c-0cdd2cf5ac4c.png" width="320">

</details>

### **その他選択時の入力欄**: 「その他」を選択すると自由入力欄（最大100文字）が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/75a55a6b-ee70-4c49-aee3-abd6608785e7.png" width="320">

</details>

### **注意文言の表示**: メールアドレス欄の下に受信設定の注意文（オレンジ文字）とiCloudメール利用不可の注意文（赤文字）が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/e5957c90-170d-4c4e-856c-0cdd2cf5ac4c.png" width="320">

</details>

</details>

---

## 2. バリデーション

- [x] **不正なメールアドレス**: メールアドレス欄に不正な形式を入力すると入力欄下にエラーメッセージが表示され、送信ボタンが無効化される
- [x] **お問い合わせ内容未入力**: 内容欄が空のままだと送信ボタンが無効化されている
- [x] **その他の自由入力未入力**: 「その他」選択時に自由入力欄が空だと送信ボタンが無効化される
- [x] **入力完了で送信ボタン活性化**: 種別・メールアドレス（正しい形式）・内容（「その他」選択時は自由入力も）をすべて入力すると送信ボタンが有効になる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **不正なメールアドレス**: メールアドレス欄に不正な形式を入力すると入力欄下にエラーメッセージが表示され、送信ボタンが無効化される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/2938f647-92fa-487a-a305-b78d67840f05.png" width="320">

</details>

### **お問い合わせ内容未入力**: 内容欄が空のままだと送信ボタンが無効化されている

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/31b29114-d02c-48ba-94e9-bc08a52cc07c.png" width="320">

</details>

### **その他の自由入力未入力**: 「その他」選択時に自由入力欄が空だと送信ボタンが無効化される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/87fb97f0-fe5b-46d6-9ed9-9f4677e66d26.png" width="320">

</details>

### **入力完了で送信ボタン活性化**: 種別・メールアドレス（正しい形式）・内容（「その他」選択時は自由入力も）をすべて入力すると送信ボタンが有効になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/945422bd-1e7a-41da-9f12-f24499c17f53.png" width="320">

</details>

</details>

---

## 3. 送信

- [x] **送信成功**: 送信ボタンをタップすると「お問い合わせを送信しました」のSnackBarが表示され画面が閉じる。実際にメールが届くかどうかはSimulatorでは確認できないため、Firebase Functions呼び出しが成功しSnackBarが表示されることまでを確認対象とする
- [ ] **送信失敗時のエラー表示**: 通信エラー等で送信に失敗した場合、エラーアラートが表示され画面は閉じない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **送信成功**: 送信ボタンをタップすると「お問い合わせを送信しました」のSnackBarが表示され画面が閉じる。実際にメールが届くかどうかはSimulatorでは確認できないため、Firebase Functions呼び出しが成功しSnackBarが表示されることまでを確認対象とする

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

SnackBarの表示時間（2秒）がmobile-mcp経由のツール呼び出し往復時間より短く、SnackBar表示中の瞬間を静止画で捕捉できなかった。送信前（入力済み・送信ボタン活性化）と送信後（エラーアラートなしで設定画面に戻った＝`_submitInquiry`の成功分岐が実行されNavigator.pop()まで到達したことの間接証跡）の2枚を記録する。

送信前:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/945422bd-1e7a-41da-9f12-f24499c17f53.png" width="320">

送信後（設定画面に復帰）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/35ce2e38-3e20-447a-bcd9-89c3fb7a5ab3.png" width="320">

</details>

### **送信失敗時のエラー表示**: 通信エラー等で送信に失敗した場合、エラーアラートが表示され画面は閉じない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

⏭️ スキップ: iOSシミュレータの設定アプリにはWi-Fi/機内モードの項目が存在せず（シミュレータはホストMacのネットワークを共有するため）、アプリ内から安全にネットワークエラーを再現する手段がない。Macホスト全体のネットワークを切断する方法は他の並行作業に影響するため見送った。`lib/features/inquiry/page.dart` の `_submitInquiry` で `catch (error) { isSending.value = false; if (context.mounted) showErrorAlert(context, error); }` となっており、失敗時は `navigator.pop()` に到達せず画面が閉じないことをコードレビューで確認済み。

</details>

</details>

---

## 4. 画面操作

- [x] **キーボードツールバー**: メールアドレス欄または内容欄にフォーカスすると画面下部に「完了」ボタン付きツールバーが表示され、タップでキーボードが閉じる
- [x] **画面を閉じる**: 左上のバツボタンをタップするとお問い合わせ画面が閉じる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **キーボードツールバー**: メールアドレス欄または内容欄にフォーカスすると画面下部に「完了」ボタン付きツールバーが表示され、タップでキーボードが閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/8abbafcd-8f0b-4588-87e6-7af6043c3914.png" width="320">

</details>

### **画面を閉じる**: 左上のバツボタンをタップするとお問い合わせ画面が閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/158f4784-dc6f-4a70-809a-8bb9d0b632b6.png" width="320">

</details>

</details>
