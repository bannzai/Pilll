---
feature: release_note
verification: mobile-mcp
last_verified_commit: 34b7e05eb0ed73e5ee0caa2a91a96147e2edaded
last_verified_at: 2026-07-06
---

# release_note QA

## 1. 表示条件

- [x] **初回表示 (iOS)**: 対象バージョンの既読フラグ(SharedPreferences の `ReleaseNoteKey.version20250920`)が立っていない状態でピルを服用記録する(`record` の服用ボタンをタップする)と、リリースノートダイアログが表示される（アプリ起動時ではない）
- [ ] **Androidでは表示されない**: Android端末では `Platform.isAndroid` の判定により、フラグの状態に関わらずダイアログが表示されない
  - ⏭️ スキップ: 本セッションの環境には Android エミュレータ・実機が用意されておらず（利用可能デバイスは iOS シミュレータのみ）、動作確認ができなかった。コード上は `lib/features/release_note/release_note.dart` の `showReleaseNotePreDialog` 内で `if (Platform.isAndroid) { return; }` により表示前に早期リターンする実装になっていることをコードレビューで確認済み
- [x] **2回目以降は再表示されない**: 一度ダイアログが表示されるとフラグが保存され、再度服薬記録をしても同一バージョンでは再表示されない
  - Simulator で再確認する場合はアプリの SharedPreferences をリセットするか、アプリを再インストールしてフラグをクリアする

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初回表示 (iOS)**: 対象バージョンの既読フラグ(SharedPreferences の `ReleaseNoteKey.version20250920`)が立っていない状態でピルを服用記録する(`record` の服用ボタンをタップする)と、リリースノートダイアログが表示される（アプリ起動時ではない）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

新規インストール直後（フラグ未設定）の状態でホーム画面の「飲んだ」ボタンをタップすると、服用記録と同時にリリースノートダイアログが表示されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/0e197043-2264-4749-a66f-fcb5ccdff4df.png" width="320">

</details>

### **Androidでは表示されない**: Android端末では `Platform.isAndroid` の判定により、フラグの状態に関わらずダイアログが表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

⏭️ スキップ: 本セッションの環境には Android エミュレータ・実機が用意されておらず、実機動作確認ができなかった。`lib/features/release_note/release_note.dart` の `showReleaseNotePreDialog` 内 `if (Platform.isAndroid) { return; }` の実装をコードレビューで確認済み。

</details>

### **2回目以降は再表示されない**: 一度ダイアログが表示されるとフラグが保存され、再度服薬記録をしても同一バージョンでは再表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

初回表示後、服用記録を取り消して再度「飲んだ」をタップしても、リリースノートダイアログが再表示されず直接服用記録のみ反映されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/17e120cf-053f-45ff-a010-5dba5856db0d.png" width="320">

</details>

</details>

---

## 2. 表示内容・操作

- [x] **タイトル・本文表示**: 「服薬時刻に目覚ましアラームが鳴るようにしました」というタイトルと、集中モード/消音時でもアラームが鳴る旨の説明文が表示される
- [x] **閉じるボタン**: ダイアログ左上の×アイコンをタップするとダイアログが閉じる
- [x] **詳しく見るボタン**: 「詳しく見る」ボタンをタップするとダイアログが閉じ、外部ブラウザ(inAppBrowser)で Notion のリリースノートページが開く
  - 開く URL が `pilll.notion.site` から始まることを確認する(コード内に `www.notion.so` 始まりは誤りである旨の注記あり)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **タイトル・本文表示**: 「服薬時刻に目覚ましアラームが鳴るようにしました」というタイトルと、集中モード/消音時でもアラームが鳴る旨の説明文が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

ダイアログに「服薬時刻に目覚ましアラームが鳴るようにしました」というタイトルと、「集中モードがONまたはデバイスが消音時でも、目覚ましのようにアラームが鳴らせるオプションを追加しました」という説明文が表示されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/0e197043-2264-4749-a66f-fcb5ccdff4df.png" width="320">

</details>

### **閉じるボタン**: ダイアログ左上の×アイコンをタップするとダイアログが閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

アプリ再インストールでフラグをリセットし、再度ダイアログを表示させた上で左上の×アイコンをタップし、ダイアログが閉じてホーム画面に戻ることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/b1e4cf41-f652-4818-9104-d73648101f49.png" width="320">

</details>

### **詳しく見るボタン**: 「詳しく見る」ボタンをタップするとダイアログが閉じ、外部ブラウザ(inAppBrowser)で Notion のリリースノートページが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-06**

「詳しく見る」ボタンをタップするとダイアログが閉じ、inAppBrowser で `pilll.notion.site` から始まる URL の Notion リリースノートページ（「202509.20.x 服薬時刻に目覚ましアラームが鳴るようにしました」）が開くことを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/Pilll/20260706/c2902e4a-a3bb-4300-ad63-28542c9d6cdb.png" width="320">

</details>

</details>
