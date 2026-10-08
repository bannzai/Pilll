---
feature: home
verification: mobile-mcp
last_verified_commit: 2e6665e4ad01d02e9fc88d72442a3000cd9818a5
last_verified_at: 2026-10-08
---

# home QA

確認環境 (2026-10-05 と 2026-10-08 の記録): iPhone 16 Pro シミュレータ (iOS 27.0、ローカル sim-boot、`SIMSLIM_EXCEPT=store,health,icloud`) の dev ビルド (commit 75c754dd72 を Xcode 26.5 でビルド。`lib/features` は HEAD と同一)。

## 1. タブナビゲーション

- [x] **起動時の初期タブ**: ホーム画面を開くと「ピル」タブ（服薬記録画面）が選択された状態で表示される
- [x] **4タブの表示**: 画面下部に「ピル」「生理」「カレンダー」「設定」の4タブがアイコン付きで表示される
- [x] **タブ切り替え**: 各タブをタップすると対応する画面（服薬記録／生理／カレンダー／設定）に切り替わる
- [x] **選択状態の見た目**: 選択中のタブはアイコンが有効色（プライマリカラー）で表示され、非選択タブはグレー表示になる
- [x] **スワイプ無効**: 画面を左右にスワイプしてもタブは切り替わらず、タブタップのみで切り替えられる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **起動時の初期タブ**: ホーム画面を開くと「ピル」タブ（服薬記録画面）が選択された状態で表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

再インストール後の初期設定完了直後と、アプリの再起動直後のどちらも「ピル」タブが選択された記録画面で開くことを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/43fd250f-9341-4d4a-a229-a0654c97525a-root-home-after-reinstall.png" width="320">

</details>

### **4タブの表示**: 画面下部に「ピル」「生理」「カレンダー」「設定」の4タブがアイコン付きで表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

画面下部に「ピル」「生理」「カレンダー」「設定」の 4 タブがアイコン付きで表示されることを確認 (上と同じスクショ)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/43fd250f-9341-4d4a-a229-a0654c97525a-root-home-after-reinstall.png" width="320">

</details>

### **タブ切り替え**: 各タブをタップすると対応する画面（服薬記録／生理／カレンダー／設定）に切り替わる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

生理タブ (1 枚目)、カレンダータブ (2 枚目)、設定タブ (3 枚目) のタップでそれぞれの画面に切り替わることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/01bd71f4-9047-434f-8763-9ea411a0e0a9-home-tab-menstruation.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/7fb71210-c6ac-404e-9798-5ab4d46de63f-calendar-top.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/9da73715-73e7-4cbc-a1b1-abfb1fe83786-settings-top.png" width="320">

</details>

### **選択状態の見た目**: 選択中のタブはアイコンが有効色（プライマリカラー）で表示され、非選択タブはグレー表示になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

各タブ画面のスクショ (「タブ切り替え」参照) で、選択中のタブだけがプライマリカラー、他はグレーになっていることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/01bd71f4-9047-434f-8763-9ea411a0e0a9-home-tab-menstruation.png" width="320">

</details>

### **スワイプ無効**: 画面を左右にスワイプしてもタブは切り替わらず、タブタップのみで切り替えられる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

ピルタブで左右にスワイプしてもタブは「ピル」のまま切り替わらないことを確認 (スワイプ後のスクショ)。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/a3ed6ce9-f430-4830-b118-890ee91e1b79-home-swipe.png" width="320">

</details>

</details>

---

## 2. エッジケース

- [x] **通知権限リクエスト**: 通知権限が未許可の端末では初回起動時 (初期設定フローの表示中) に通知許可を求めるダイアログが表示され、許可した後にホーム画面を開いても再表示されない（iOS では `lib/entrypoint.dart` の `localNotificationService.initialize()` が起動時に要求するため、`lib/features/home/page.dart` の `requestNotificationPermissions` の時点では許可・拒否が確定している。未許可のままホームを開いた時の要求は Android 向けの経路）
- [ ] **累計服薬記録に応じたストアレビュー促進・退会アンケート表示**: 服薬記録が一定回数を超えたユーザーには事前ストアレビューモーダルが、解約手続き中のユーザーには退会理由アンケート（WebView）が表示される
  - ⏭️ スキップ: 表示条件はユーザーの解約フラグ (`user.shouldAskCancelReason`。Firestore 側で解約手続き中に true になる) や SharedPreferences の記録回数 (`totalCountOfActionForTakenPill` が 10 より大きい) といった状態が必要で、シミュレータの通常操作では再現していない。`lib/features/home/page.dart` の発火条件をコードレビューで確認した。事前ストアレビューモーダルの描画は `test/features/store_review/pre_store_review_modal_test.dart` で担保している
- [ ] **ピルシート終了時の課金転換ダイアログ**: ピルシートグループが終了 (アクティブなシートが無い) した無料ユーザーがホームを開くと、Remote Config の `endedPillSheetDialogVariant` に応じた課金転換ダイアログが終了グループにつき 1 回だけ表示される
  - ⏭️ スキップ: ピルシートの全日数が経過した状態を再現できないため未実施 (理由と担保しているテストは `lib/features/ended_pill_sheet_dialog/QA.md`)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **通知権限リクエスト**: 通知権限が未許可の端末では初回起動時 (初期設定フローの表示中) に通知許可を求めるダイアログが表示され、許可した後にホーム画面を開いても再表示されない（iOS では `lib/entrypoint.dart` の `localNotificationService.initialize()` が起動時に要求するため、`lib/features/home/page.dart` の `requestNotificationPermissions` の時点では許可・拒否が確定している。未許可のままホームを開いた時の要求は Android 向けの経路）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

アプリをアンインストールしてから再インストールして起動すると、初期設定画面の上に「“Pilll-dev” は通知を送信します。よろしいですか?」の許可ダイアログが表示されることを確認。「許可」の後にホームを開いても再表示されない。未許可のままホームを開いた時の要求 (Android 向け) は Android 環境が無く未確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/a3fe9c22-77ad-49c6-9cf7-3da13d73291e-root-notification-permission.png" width="320">

</details>

### **累計服薬記録に応じたストアレビュー促進・退会アンケート表示**: 服薬記録が一定回数を超えたユーザーには事前ストアレビューモーダルが、解約手続き中のユーザーには退会理由アンケート（WebView）が表示される

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: チェックリスト側に記載の理由 (発火条件の状態を再現していない) により未実施

</details>

### **ピルシート終了時の課金転換ダイアログ**: ピルシートグループが終了 (アクティブなシートが無い) した無料ユーザーがホームを開くと、Remote Config の `endedPillSheetDialogVariant` に応じた課金転換ダイアログが終了グループにつき 1 回だけ表示される

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: シート終了状態を再現できないため未実施 (`lib/features/ended_pill_sheet_dialog/QA.md` を参照)

</details>

</details>
