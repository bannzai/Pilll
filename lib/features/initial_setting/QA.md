---
feature: initial_setting
verification: mobile-mcp
last_verified_commit: 21853fcbe3916b4509d34b8a00a3fac51298721c
last_verified_at: 2026-09-11
---

# initial_setting QA

## 1. ピルシート選択（1/3）

- [x] **初期状態（空のピルシート種類）**: 初回表示時はピルシート種類が未選択のため、種類選択画面（低用量ピル／超低用量ピル等の選択肢）が表示される
- [x] **種類選択でプレビュー生成**: 種類を1つ選択すると、同じ種類のピルシートが3シート分生成されプレビューに表示される
- [x] **追加・変更・削除操作**: ピルシートの追加・種類変更・削除の各操作を行うと、プレビューに反映される
- [x] **「次へ」ボタンの表示条件**: ピルシートが1件以上あるときのみ「次へ」ボタンが表示され、タップすると今日のピル番号選択画面（2/3）に遷移する
- [x] **既存アカウントでのログイン導線**: 「すでにアカウントをお持ちの方はこちら」をタップするとサインインシートが表示される。Apple/Googleの実OAuth認証はSimulatorでは確認が難しいため、シートが表示されボタンが押せることまでを確認対象とする

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初期状態（空のピルシート種類）**: 初回表示時はピルシート種類が未選択のため、種類選択画面（低用量ピル／超低用量ピル等の選択肢）が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/14f9b81f-ad0b-4a8d-99e4-410d42bb5790.png" width="320">

</details>

### **種類選択でプレビュー生成**: 種類を1つ選択すると、同じ種類のピルシートが3シート分生成されプレビューに表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/35f1354b-965b-4b07-aafb-3b10373bdb36.png" width="320">

</details>

### **追加・変更・削除操作**: ピルシートの追加・種類変更・削除の各操作を行うと、プレビューに反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

4枚目を追加→種類変更（28錠タイプ(4錠偽薬)）→削除して3枚に戻ることを確認

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/d106635d-2d1e-476c-84c7-0fbcee94b308.png" width="320">

</details>

### **「次へ」ボタンの表示条件**: ピルシートが1件以上あるときのみ「次へ」ボタンが表示され、タップすると今日のピル番号選択画面（2/3）に遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/efa08a5f-ccf7-4eb4-8ede-7eac9660eab4.png" width="320">

</details>

### **既存アカウントでのログイン導線**: 「すでにアカウントをお持ちの方はこちら」をタップするとサインインシートが表示される。Apple/Googleの実OAuth認証はSimulatorでは確認が難しいため、シートが表示されボタンが押せることまでを確認対象とする

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/b161679d-a963-46d7-ab4c-4cbc369bd7c4.png" width="320">

</details>

</details>

---

## 2. 今日のピル番号選択（2/3）

- [x] **案内文表示**: 「今日（日付）飲む・飲んだピルの番号をタップ」の案内文が今日の日付付きで表示される
- [x] **番号タップで選択**: ピルシート上の番号をタップすると選択状態になり、下部に「今日は◯番」の説明が表示される
- [x] **未選択時は次へ無効**: 番号を選択していない状態では「次へ」ボタンが無効化されている
- [x] **「まだ分からない」で番号未設定のままスキップ**: 「まだ分からない」ボタンをタップすると番号を選択しなくてもリマインダー設定画面（3/3）に遷移する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **案内文表示**: 「今日（日付）飲む・飲んだピルの番号をタップ」の案内文が今日の日付付きで表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/36bd4c12-84cd-4d6f-84d9-f8c72304d321.png" width="320">

</details>

### **番号タップで選択**: ピルシート上の番号をタップすると選択状態になり、下部に「今日は◯番」の説明が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/5f41c7df-e67e-421b-8b64-8e88a8088ced.png" width="320">

</details>

### **未選択時は次へ無効**: 番号を選択していない状態では「次へ」ボタンが無効化されている

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/53d6a4af-50ac-40cd-bdcf-7f2e4900175d.png" width="320">

</details>

### **「まだ分からない」で番号未設定のままスキップ**: 「まだ分からない」ボタンをタップすると番号を選択しなくてもリマインダー設定画面（3/3）に遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/885b51de-9b4a-48c3-a36f-a8db8fee951c.png" width="320">

</details>

</details>

---

## 3. リマインダー時刻設定（3/3）

- [x] **飲み忘れ通知の時刻設定**: 「ピルの飲み忘れ通知」の案内のもと3つの時刻設定枠が表示され、各枠をタップするとタイムピッカーがボトムシートで表示され、選択した時刻が枠に反映される
- [x] **利用規約・プライバシーポリシーのリンク**: 画面下部の「プライバシーポリシー」「利用規約」リンクをタップすると、それぞれWebViewで該当ページが開く
- [x] **「次へ」でプレミアム体験開始画面に遷移**: 「次へ」ボタンをタップするとプレミアム体験開始画面に遷移する
- [x] **オンボーディング Paywall A/B (実験未参加)**: Remote Config `onboardingPaywallVariant` が未設定 (空文字) の場合、「次へ」で Paywall は表示されず現行どおりプレミアム体験開始画面に遷移する (割当イベント `onboarding_paywall_assigned` も送られない)
- [ ] **オンボーディング Paywall A/B (paywall 群)**: `onboardingPaywallVariant` = `paywall` の場合、「次へ」で `onboarding_paywall_assigned {variant: paywall}` が送られ、`PremiumIntroductionSheet` (paywall_source = onboarding) が表示され、閉じるとプレミアム体験開始画面に遷移する
  - ⏭️ スキップ: Remote Config の値は Firebase コンソールでしか設定できず、dev / prod のどちらにもパラメータ `onboardingPaywallVariant` が未作成のため、実験群の状態を端末で作れない。variant の解決は `flutter test test/features/initial_setting/onboarding_paywall_variant_test.dart` (6 件成功) で確認した。パラメータ作成後に `paywall` を配信して再確認する (bannzai/PilllBackend#422 のユーザー作業)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **飲み忘れ通知の時刻設定**: 「ピルの飲み忘れ通知」の案内のもと3つの時刻設定枠が表示され、各枠をタップするとタイムピッカーがボトムシートで表示され、選択した時刻が枠に反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/7614b166-5988-4e29-a047-a083c8a2df76.png" width="320">

</details>

### **利用規約・プライバシーポリシーのリンク**: 画面下部の「プライバシーポリシー」「利用規約」リンクをタップすると、それぞれWebViewで該当ページが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

プライバシーポリシー:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/616d5635-18cc-4800-a3e2-20e0ec713c6c.png" width="320">

利用規約:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/d2b22f3b-9f38-478c-aca1-df21369b20ee.png" width="320">

</details>

### **「次へ」でプレミアム体験開始画面に遷移**: 「次へ」ボタンをタップするとプレミアム体験開始画面に遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/5a8366b0-bfd4-4118-a6f5-715dfc393896.png" width="320">

</details>

### **オンボーディング Paywall A/B (実験未参加)**: Remote Config `onboardingPaywallVariant` が未設定 (空文字) の場合、「次へ」で Paywall は表示されず現行どおりプレミアム体験開始画面に遷移する (割当イベント `onboarding_paywall_assigned` も送られない)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-09-11**

新規アカウント (clearState) で初期設定を進め、リマインダー時刻設定 (3/3) の「次へ」をタップすると、Paywall を経由せずプレミアム体験開始画面に遷移した (dev の Remote Config にパラメータ未作成 = 空文字 = 実験未参加)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/10/7cbbb3a1-10e2-44c3-ae6b-c3a84b804aba-onboarding_reminder_times.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/10/4784f921-6f0f-4d88-b7fd-c1ad087e4844-onboarding_after_next_control.png" width="320">

</details>

### **オンボーディング Paywall A/B (paywall 群)**: `onboardingPaywallVariant` = `paywall` の場合、「次へ」で `onboarding_paywall_assigned {variant: paywall}` が送られ、`PremiumIntroductionSheet` (paywall_source = onboarding) が表示され、閉じるとプレミアム体験開始画面に遷移する

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 4. プレミアム体験開始・登録完了

- [x] **クイック記録機能の紹介表示**: 「通知から服用記録ができます」の説明とアニメーション画像、トライアル期限の案内文言が表示される
- [x] **「アプリをはじめる」で登録完了しホームへ遷移**: 「アプリをはじめる」ボタンをタップすると、ピルシートグループ・設定が登録され、リマインダー通知が設定されたうえでホーム画面に遷移する
- [ ] **登録失敗時のエラー表示**: 登録処理中にエラーが発生した場合、エラーアラートが表示されプレミアム体験開始画面にとどまる
  - ⏭️ スキップ: Firestore書き込み失敗（`batch.commit()`）を人為的に再現する手段がない。シミュレータのネットワーク遮断はホストマシン全体に影響し他の検証中シミュレータ・作業に支障が出るため実施しなかった

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **クイック記録機能の紹介表示**: 「通知から服用記録ができます」の説明とアニメーション画像、トライアル期限の案内文言が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/5a8366b0-bfd4-4118-a6f5-715dfc393896.png" width="320">

</details>

### **「アプリをはじめる」で登録完了しホームへ遷移**: 「アプリをはじめる」ボタンをタップすると、ピルシートグループ・設定が登録され、リマインダー通知が設定されたうえでホーム画面に遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

今日のピル番号を選択（スキップしない）した通常フローで検証。ホーム画面にピルシートグループ（今日飲むピル: 1番）が登録・表示されることを確認

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/037af7bf-393e-4abe-b185-99cec9f81fdc.png" width="320">

</details>

### **登録失敗時のエラー表示**: 登録処理中にエラーが発生した場合、エラーアラートが表示されプレミアム体験開始画面にとどまる

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>
