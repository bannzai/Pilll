---
feature: ended_pill_sheet_dialog
verification: mobile-mcp
last_verified_commit: 1abe9113bb377e9d90c42a10ee54feeae9ca058c
last_verified_at: 2026-10-08
---

# ended_pill_sheet_dialog QA

ピルシートグループが終了した無料ユーザーに、ホーム画面で 1 回だけ表示する課金転換ダイアログ (`showEndedPillSheetDialog`)。Remote Config の `endedPillSheetDialogVariant` (`history_blur` = 履歴ぼかし / `summary_stats` = 服用記録の集計。既定値は空文字で非表示) でティーザーを出し分け、CTA からプレミアム紹介シートを開く。表示の判定は `lib/features/home/page.dart` にある。

## 関連リンク

- 仕様なし QA
- 関連: `test/features/ended_pill_sheet_dialog/ended_pill_sheet_dialog_test.dart`、`ended_pill_sheet_dialog_variant_test.dart`、`ended_pill_sheet_taken_summary_test.dart`

## 1. 表示条件と内容

- [ ] **終了したグループの無料ユーザーに 1 回だけ表示**: 最新のピルシートグループが終了 (`activePillSheet == null`、破棄ではない) した非プレミアム・非トライアルのユーザーがホームを開くと、variant に応じたダイアログが表示される。表示後は同じグループでは再表示されず、同一起動で買い切りオファー等の起動時モーダルと重ならない
  - ⏭️ スキップ: 終了状態はピルシートの全日数 (21〜28 日) が実際に経過しないと作れない。開発者オプション「終了済みの前回ピルシートグループを作成」は今日から始まる新しいグループも作るため、最新グループは終了にならない。dev 環境の Remote Config の `endedPillSheetDialogVariant` の実測値も未確認 (既定値は空文字で非表示)。表示条件は `lib/features/home/page.dart` の分岐をコードで確認し、ティーザーの描画と集計は上記のテストで担保している
  - 自動化: manual（終了状態の再現手段が無い）
- [ ] **履歴ぼかしティーザー (history_blur)**: 先頭 1 件の服用履歴と残りのぼかし、🔒「服用履歴はプレミアム機能です」、「くわしくみる」ボタンが表示され、ボタンでプレミアム紹介シートが開く
  - ⏭️ スキップ: 同上。`ended_pill_sheet_dialog_test.dart` で描画を担保している
  - 自動化: manual（同上）
- [ ] **集計メッセージティーザー (summary_stats)**: 終了したグループの服用記録の集計メッセージが表示され、集計を提示できない場合はダイアログ自体が表示されない
  - ⏭️ スキップ: 同上。`ended_pill_sheet_taken_summary_test.dart` で集計の判定を担保している
  - 自動化: manual（同上）
- [ ] **閉じる**: × または外側のタップでダイアログが閉じ、プレミアム紹介シートは開かない
  - ⏭️ スキップ: 同上
  - 自動化: manual（同上）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **終了したグループの無料ユーザーに 1 回だけ表示**: 最新のピルシートグループが終了 (`activePillSheet == null`、破棄ではない) した非プレミアム・非トライアルのユーザーがホームを開くと、variant に応じたダイアログが表示される。表示後は同じグループでは再表示されず、同一起動で買い切りオファー等の起動時モーダルと重ならない

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: シート終了状態を再現できないため未実施 (理由はチェックリスト側を参照)

</details>

### **履歴ぼかしティーザー (history_blur)**: 先頭 1 件の服用履歴と残りのぼかし、🔒「服用履歴はプレミアム機能です」、「くわしくみる」ボタンが表示され、ボタンでプレミアム紹介シートが開く

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 同上

</details>

### **集計メッセージティーザー (summary_stats)**: 終了したグループの服用記録の集計メッセージが表示され、集計を提示できない場合はダイアログ自体が表示されない

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 同上

</details>

### **閉じる**: × または外側のタップでダイアログが閉じ、プレミアム紹介シートは開かない

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 同上

</details>

</details>
