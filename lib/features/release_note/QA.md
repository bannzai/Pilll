---
feature: release_note
verification: mobile-mcp
last_verified_commit: 1abe9113bb377e9d90c42a10ee54feeae9ca058c
last_verified_at: 2026-10-08
---

# release_note QA

確認環境 (2026-10-05 と 2026-10-08 の記録): iPhone 16 Pro シミュレータ (iOS 27.0、ローカル sim-boot、`SIMSLIM_EXCEPT=store,health,icloud`) の dev ビルド (commit 75c754dd72 を Xcode 26.5 でビルド。`lib/features` は HEAD と同一)。既読フラグのリセット手順はルート `QA.md` の「実行ナレッジ」を参照。

## 1. 表示条件

- [x] **初回表示**: 対象バージョンの既読フラグ(SharedPreferences の `ReleaseNoteKey.version20260804`)が立っていない状態でピルを服用記録する(`record` の服用ボタンをタップする)と、リリースノートダイアログが表示される（アプリ起動時ではない）
- [ ] **iOS/Android両方で表示される**: 202608.04.x のリリースノート（2錠飲み対応）は両OS対象のため、Platform による表示制限はない
  - ⏭️ スキップ: 本 QA の環境には Android エミュレータ・実機が無く、Android での表示は未確認。`lib/features/release_note/release_note.dart` の `showReleaseNotePreDialog` に `Platform` による分岐が無いことをコードで確認した
- [x] **2回目以降は再表示されない**: 一度ダイアログが表示されるとフラグが保存され、再度服薬記録をしても同一バージョンでは再表示されない
  - Simulator で再確認する場合はアプリの SharedPreferences の `flutter.release_notes_shown_202608.04.x` を消す (ルート `QA.md` の「実行ナレッジ」) か、アプリを再インストールしてフラグをクリアする

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初回表示**: 対象バージョンの既読フラグ(SharedPreferences の `ReleaseNoteKey.version20260804`)が立っていない状態でピルを服用記録する(`record` の服用ボタンをタップする)と、リリースノートダイアログが表示される（アプリ起動時ではない）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

新規インストール直後 (フラグ未設定) の状態ではアプリ起動時にはダイアログが出ず、記録画面の「飲んだ」をタップした時に服用記録と同時にリリースノートダイアログが表示されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/7a16349c-e374-46a6-a67f-ed7150e9db8a-record-midnight-1.png" width="320">

</details>

### **iOS/Android両方で表示される**: 202608.04.x のリリースノート（2錠飲み対応）は両OS対象のため、Platform による表示制限はない

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: Android 環境が無いため未確認 (理由はチェックリスト側を参照)

</details>

### **2回目以降は再表示されない**: 一度ダイアログが表示されるとフラグが保存され、再度服薬記録をしても同一バージョンでは再表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-05**

初回表示の後、服用記録を取り消して再度 1 番をタップしても、リリースノートダイアログは再表示されず服用記録だけが反映されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/04/85c00f7d-4eb4-40b8-ad2b-d9d81313f2e6-record-midnight-4.png" width="320">

</details>

</details>

---

## 2. 表示内容・操作

- [x] **タイトル・本文表示**: 「1日2回服用するお薬に対応しました」というタイトルと、ピルシート追加時に服用回数を設定でき1回ごとに記録できる旨の説明文が表示される
- [x] **閉じるボタン**: ダイアログ左上の×アイコンをタップするとダイアログが閉じる
- [x] **詳しく見るボタン**: 「詳細を見る」ボタンをタップするとダイアログが閉じ、外部ブラウザ(inAppBrowser)で Notion のリリースノートページが開く
  - 開く URL が `pilll.notion.site` から始まることを確認する(コード内に `www.notion.so` 始まりは誤りである旨の注記あり)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **タイトル・本文表示**: 「1日2回服用するお薬に対応しました」というタイトルと、ピルシート追加時に服用回数を設定でき1回ごとに記録できる旨の説明文が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

既読フラグを消して「飲んだ」をタップすると、「1日2回服用するお薬に対応しました」のタイトルと「ジエノゲストなど、1日に2回服用するお薬の記録に対応しました。ピルシートの追加時に「1日に2回服用する」と設定すると、1回ごとに服用記録ができ、シート上で残りの服用回数も確認できます」の本文が表示されることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/5a5089af-75e8-409a-9740-eab08ca3b5d2-release-note-reshown.png" width="320">

</details>

### **閉じるボタン**: ダイアログ左上の×アイコンをタップするとダイアログが閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

既読フラグを消して再表示させたダイアログの左上 × をタップすると、ダイアログが閉じて服用済みの記録画面に戻ることを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/b8b0246e-8b3f-4c8c-903c-60cb23501c3e-release-note-closed.png" width="320">

</details>

### **詳しく見るボタン**: 「詳細を見る」ボタンをタップするとダイアログが閉じ、外部ブラウザ(inAppBrowser)で Notion のリリースノートページが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-08**

「詳細を見る」をタップするとダイアログが閉じ、アプリ内ブラウザで `pilll.notion.site` の「202608.04.x 1日2回服用するお薬に対応しました」が開くことを確認。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/08/588c8a01-18f6-4f92-87ee-8545aa8a81c6-release-note-details.png" width="320">

</details>

</details>
