# Backend TODO: 2錠飲み対応

このドキュメントは2錠飲み機能のサーバー側対応が完了したら削除してください。

## 概要

2錠飲み対応（PR #856）がrevertされた理由は、サーバー側の対応が未完了だったためです。
フロントエンド実装をマージする前に、以下のバックエンド対応が必要です。

## クライアント側実装（v1/v2分岐）

Flutterクライアント側ではsealed classによるv1/v2分岐を実装しています。

### 分岐の仕組み
- `PillSheet`はsealed classで、`PillSheet.v1()`と`PillSheet.v2()`の2つのfactory constructorを持つ
- `fromJson`では`version`フィールドを見て自動判定（`'v2'`ならv2、それ以外はv1）
- v1: 従来の1錠飲みユーザー向け（既存フィールドのみ）
- v2: 2錠飲み対応（`pills`フィールドを持つ）

### v2の特徴
- `pills: List<Pill>` - 各ピルの詳細情報を持つ
- `lastTakenDate` は `pills` から導出される（コンストラクタ引数ではない）
- 各 `Pill.takenCount` で服用すべき回数を管理（PillSheet直下のpillTakenCountは不要）

## 必要なサーバー側対応

### 1. ピルシートの自動作成ロジック

**現状の問題:**
- 現在のロジックは「すべて服用済み」かどうかで自動作成を判定している
- 2錠飲みの場合、`pills` と `pills[].takenCount` を考慮する必要がある

**対応内容:**
- ピルシート自動作成の判定ロジックに `pills[].pillTakens.length` と `pills[].takenCount` の比較を追加
- すべてのピルが `takenCount` 回服用されている場合のみ「完了」と判定

### 2. 偽薬/休薬期間の自動服用ロジック

**現状の問題:**
- 偽薬期間や休薬期間に自動で服用記録をつけるロジックがある
- 2錠飲みの場合、`pills` と `pills[].takenCount` を考慮する必要がある

**対応案（2つ）:**
1. `pills` と `pills[].takenCount` を考慮したロジックに修正
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
// v2で追加されるフィールド
{
  version: string,  // 'v1' または 'v2'（v1の場合は省略可能、undefinedはv1として扱う）
  pills: [          // v2のみ。v1には存在しない
    {
      index: number,
      takenCount: number,  // このピルを完了するのに必要な服用回数
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
