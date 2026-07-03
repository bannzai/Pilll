---
feature: release_note
verification: mobile-mcp
last_verified_commit: null
last_verified_at: null
---

# release_note QA

## 1. 表示条件

- [ ] **初回表示 (iOS)**: 対象バージョンの既読フラグ(SharedPreferences の `ReleaseNoteKey.version20250920`)が立っていない状態でアプリを起動すると、リリースノートダイアログが自動表示される
- [ ] **Androidでは表示されない**: Android端末では `Platform.isAndroid` の判定により、フラグの状態に関わらずダイアログが表示されない
- [ ] **2回目以降は再表示されない**: 一度ダイアログが表示されるとフラグが保存され、アプリを再起動しても同一バージョンでは再表示されない
  - Simulator で再確認する場合はアプリの SharedPreferences をリセットするか、アプリを再インストールしてフラグをクリアする

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

（未実行）

</details>

---

## 2. 表示内容・操作

- [ ] **タイトル・本文表示**: 「服薬時刻に目覚ましアラームが鳴るようにしました」というタイトルと、集中モード/消音時でもアラームが鳴る旨の説明文が表示される
- [ ] **閉じるボタン**: ダイアログ左上の×アイコンをタップするとダイアログが閉じる
- [ ] **詳しく見るボタン**: 「詳しく見る」ボタンをタップするとダイアログが閉じ、外部ブラウザ(inAppBrowser)で Notion のリリースノートページが開く
  - 開く URL が `pilll.notion.site` から始まることを確認する(コード内に `www.notion.so` 始まりは誤りである旨の注記あり)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

（未実行）

</details>
