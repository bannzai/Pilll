# Backend TODO: 2錠飲み対応

このドキュメントは2錠飲み機能のサーバー側対応が完了したら削除してください。

## 概要

2錠飲み対応（PR #856）がrevertされた理由は、サーバー側の対応が未完了だったためです。
フロントエンド実装をマージする前に、以下のバックエンド対応が必要です。

## 必要なサーバー側対応

### 1. ピルシートの自動作成ロジック

**現状の問題:**
- 現在のロジックは「すべて服用済み」かどうかで自動作成を判定している
- 2錠飲みの場合、`pills` と `pillTakenCount` を考慮する必要がある

**対応内容:**
- ピルシート自動作成の判定ロジックに `pills[].pillTakens.length` と `pillTakenCount` の比較を追加
- すべてのピルが `pillTakenCount` 回服用されている場合のみ「完了」と判定

### 2. 偽薬/休薬期間の自動服用ロジック

**現状の問題:**
- 偽薬期間や休薬期間に自動で服用記録をつけるロジックがある
- 2錠飲みの場合、`pills` と `pillTakenCount` を考慮する必要がある

**対応案（2つ）:**
1. `pills` と `pillTakenCount` を考慮したロジックに修正
2. 2度飲みユーザーはこの設定を利用できないように制限（より現実的かも）

### 3. 履歴記録コードの対応

**現状の問題:**
- サーバー側で履歴をつけているコードがある
- 変更前後の状態を正確に記録する必要がある

**対応内容:**
- `beforePillSheetGroup` と `afterPillSheetGroup` を保存する
- `pills` フィールドの変更も履歴に含める

## Firestoreスキーマの変更

### PillSheetドキュメント

```typescript
// 追加フィールド
{
  pillTakenCount: number,  // 1回に飲む錠数（デフォルト: 1）
  pills: [
    {
      index: number,
      createdDateTime: Timestamp,
      updatedDateTime: Timestamp,
      pillTakens: [
        {
          recordedTakenDateTime: Timestamp,
          createdDateTime: Timestamp,
          updatedDateTime: Timestamp,
          isAutomaticallyRecorded: boolean
        }
      ]
    }
  ]
}
```

## 参考

- 元PR: https://github.com/bannzai/Pilll/pull/856
- Revert PR: https://github.com/bannzai/Pilll/pull/879

## チェックリスト

- [ ] ピルシート自動作成ロジックの修正
- [ ] 偽薬/休薬期間の自動服用ロジックの修正（または制限）
- [ ] 履歴記録コードの修正
- [ ] Firestoreセキュリティルールの更新（必要に応じて）
- [ ] このドキュメントを削除してPRをマージ
