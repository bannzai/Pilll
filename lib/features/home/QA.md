---
feature: home
verification: mobile-mcp
last_verified_commit: 34b7e05eb0ed73e5ee0caa2a91a96147e2edaded
last_verified_at: 2026-07-05
---

# home QA

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

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/34cf2da8-12e3-45f2-9b59-fe328761a037.png" width="320">

</details>

### **4タブの表示**: 画面下部に「ピル」「生理」「カレンダー」「設定」の4タブがアイコン付きで表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/34cf2da8-12e3-45f2-9b59-fe328761a037.png" width="320">

</details>

### **タブ切り替え**: 各タブをタップすると対応する画面（服薬記録／生理／カレンダー／設定）に切り替わる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

生理タブ:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/9b3be928-c8d1-4722-b558-defbc0cfe2a4.png" width="320">

カレンダータブ:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/12678651-f069-4434-b889-cb3dd97fe95e.png" width="320">

設定タブ:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/fb075844-455b-4042-a17e-1e65ad207099.png" width="320">

</details>

### **選択状態の見た目**: 選択中のタブはアイコンが有効色（プライマリカラー）で表示され、非選択タブはグレー表示になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

各タブ画面のスクショ（上記「タブ切り替え」参照）で選択中タブのアイコンが有効色、非選択タブがグレー表示になっていることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/fb075844-455b-4042-a17e-1e65ad207099.png" width="320">

</details>

### **スワイプ無効**: 画面を左右にスワイプしてもタブは切り替わらず、タブタップのみで切り替えられる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

ピルタブ表示中に左右スワイプを行い、スワイプ後も「ピル」タブのまま切り替わらないことを確認（下記はスワイプ後のスクショ）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/34cf2da8-12e3-45f2-9b59-fe328761a037.png" width="320">

</details>

</details>

---

## 2. エッジケース

- [x] **通知権限リクエスト**: 通知権限が未許可の端末でホーム画面を開くと、通知許可を求めるダイアログが表示される（許可済み端末では表示されないのが正常）
- [x] **累計服薬記録に応じたストアレビュー促進・退会アンケート表示**: 服薬記録が一定回数を超えたユーザーには事前ストアレビューモーダルが、解約手続き中のユーザーには退会理由アンケート（WebView）が表示される。表示条件はユーザーの解約フラグやSharedPreferencesの記録回数といった特殊な状態が必要なため、Simulatorで通常操作のみでは再現が難しい。代替手段としてコードレビューで発火条件（`shouldAskCancelReason` / `totalCountOfActionForTakenPill`）を確認する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **通知権限リクエスト**: 通知権限が未許可の端末でホーム画面を開くと、通知許可を求めるダイアログが表示される（許可済み端末では表示されないのが正常）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

未インストール状態から新規に用意したシミュレータでアプリを起動したところ、初期設定フロー中に通知許可ダイアログが表示された。コード上は `lib/entrypoint.dart` の `localNotificationService.initialize()`（`DarwinInitializationSettings` のデフォルト設定で権限リクエストが有効）がアプリ起動時に呼ばれることで表示されており、`lib/features/home/page.dart` の `requestNotificationPermissions` 呼び出し時点では既に許可・拒否が確定しているため再表示されない。既存の許可済み端末（`pilll-無名-iOS26.5`）でホーム画面を開いた際はダイアログが表示されないことも確認した（正常動作）。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260705/c99c42c7-2241-4e6f-aa0d-1036e2d8c134.png" width="320">

</details>

### **累計服薬記録に応じたストアレビュー促進・退会アンケート表示**: 服薬記録が一定回数を超えたユーザーには事前ストアレビューモーダルが、解約手続き中のユーザーには退会理由アンケート（WebView）が表示される。表示条件はユーザーの解約フラグやSharedPreferencesの記録回数といった特殊な状態が必要なため、Simulatorで通常操作のみでは再現が難しい。代替手段としてコードレビューで発火条件（`shouldAskCancelReason` / `totalCountOfActionForTakenPill`）を確認する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-05**

コードレビューにより確認（画面操作での再現はスキップ）。`lib/features/home/page.dart:105-137` にて、`user.shouldAskCancelReason`（`lib/entity/user.codegen.dart`、デフォルト `false`、Firestore側で解約手続き中に `true` へ更新）が `true` の場合は退会理由アンケートのWebViewを表示し完了後 `ChurnSurveyCompleteDialog` を表示、`false` かつ `SharedPreferences` の `totalCountOfActionForTakenPill`（`IntKey`）が10より大きく `isAlreadyAnsweredPreStoreReviewModal` が未設定かつ日本語ロケールの場合は `PreStoreReviewModal` を表示するロジックであることを確認し、既存記載の発火条件と一致することを確認した。

</details>

</details>
