# PillSheet Entity テスト追加計画

## 対象ファイル
- 実装: `lib/entity/pill_sheet.codegen.dart`
- テスト: `test/entity/pill_sheet_test.dart`

## テスト書く上での注意事項

### 基本ルール
- group内で `#getter名` または `#method名` の形式で命名
- テストケースは日本語で記述
- now()/today()のモックは `MockTodayService` を使用
- PillSheetTypeは個別に静的にテストを書く（forループで回さない）

### 考慮すべき変数
1. **PillSheetType**: pillsheet_21, pillsheet_28_4, pillsheet_28_7, pillsheet_28_0, pillsheet_24_0, pillsheet_21_0, pillsheet_24_rest_4
2. **RestDuration**: なし、1つ（未終了）、1つ（終了済み）、複数
3. **now()/today()**: 境界値テスト必須

---

## 削除対象

### sheetType と pillSheetType の重複
- 両方とも同じロジック（`PillSheetTypeFunctions.fromRawPath(typeInfo.pillSheetTypeReferencePath)`）
- **確認**: どちらかを削除するか、使い分けがあるか確認してから決定

---

## テスト追加対象

### #todayPillNumber（テストあり - ケース不足）

**現状**: pillsheet_21のみでテスト

**追加が必要なテストケース**:
```
group("#todayPillNumber", () {
  // 既存テストに追加
  group("異なるPillSheetTypeでのテスト", () {
    test("pillsheet_28_4: 24錠+4日偽薬", () { ... });
    test("pillsheet_28_7: 21錠+7日偽薬", () { ... });
    test("pillsheet_28_0: 28錠すべて実薬", () { ... });
    test("pillsheet_24_0: 24錠すべて実薬", () { ... });
    test("pillsheet_21_0: 21錠すべて実薬", () { ... });
    test("pillsheet_24_rest_4: 24錠+4日休薬", () { ... });
  });

  group("境界値テスト", () {
    test("月をまたぐ場合の計算", () { ... });
    test("年をまたぐ場合の計算", () { ... });
  });
});
```

### #lastTakenOrZeroPillNumber（テストあり - ケース不足）

**現状**: pillsheet_21のみでテスト

**追加が必要なテストケース**: todayPillNumberと同様にPillSheetType網羅

### #lastTakenPillNumber（テストなし）

**追加が必要なテストケース**:
```
group("#lastTakenPillNumber", () {
  test("lastTakenDateがnullの場合はnullを返す", () { ... });
  test("lastTakenDateがbeginingDateより前の場合はnullを返す", () { ... });
  test("正常に服用している場合は番号を返す", () { ... });
  test("lastTakenOrZeroPillNumberとの比較：0の場合はnull", () { ... });

  group("異なるPillSheetTypeでのテスト", () {
    // 各PillSheetTypeごとに
  });

  group("RestDurationがある場合", () {
    test("服用お休み期間終了後の計算", () { ... });
    test("複数の服用お休み期間がある場合", () { ... });
  });
});
```

### #todayPillIsAlreadyTaken（テストなし）

**追加が必要なテストケース**:
```
group("#todayPillIsAlreadyTaken", () {
  test("lastTakenDateがnullの場合はfalse", () { ... });
  test("lastTakenDateが今日の場合はtrue", () { ... });
  test("lastTakenDateが昨日の場合はfalse", () { ... });
  test("lastTakenDateが明日の場合はtrue（先取り服用）", () { ... });

  group("境界値テスト", () {
    test("今日の開始時刻（00:00:00）", () { ... });
    test("今日の終了時刻（23:59:59）", () { ... });
  });
});
```

### #isTakenAll（テストなし）

**追加が必要なテストケース**:
```
group("#isTakenAll", () {
  test("未服用の場合はfalse", () { ... });
  test("途中まで服用の場合はfalse", () { ... });
  test("全て服用済みの場合はtrue", () { ... });

  group("異なるPillSheetTypeでのテスト", () {
    test("pillsheet_21: 28番まで服用でtrue", () { ... });
    test("pillsheet_24_0: 24番まで服用でtrue", () { ... });
    test("pillsheet_21_0: 21番まで服用でtrue", () { ... });
    // 他のタイプも
  });
});
```

### #inNotTakenDuration（テストなし）

**追加が必要なテストケース**:
```
group("#inNotTakenDuration", () {
  group("pillsheet_21（21錠+休薬7日）", () {
    test("21番目の日（実薬最終日）はfalse", () { ... });
    test("22番目の日（休薬期間開始）はtrue", () { ... });
    test("28番目の日（休薬期間最終日）はtrue", () { ... });
  });

  group("pillsheet_28_4（24錠+4日偽薬）", () {
    test("24番目の日（実薬最終日）はfalse", () { ... });
    test("25番目の日（偽薬期間開始）はtrue", () { ... });
  });

  group("pillsheet_28_0（28錠すべて実薬）", () {
    test("28番目の日でもfalse（休薬期間なし）", () { ... });
  });

  // 他のPillSheetTypeも同様
});
```

### #pillSheetHasRestOrFakeDuration（テストなし）

**追加が必要なテストケース**:
```
group("#pillSheetHasRestOrFakeDuration", () {
  // 各PillSheetTypeの網羅テスト
  test("pillsheet_21: true（28 != 21）", () { ... });
  test("pillsheet_28_4: true（28 != 24）", () { ... });
  test("pillsheet_28_7: true（28 != 21）", () { ... });
  test("pillsheet_28_0: false（28 == 28）", () { ... });
  test("pillsheet_24_0: false（24 == 24）", () { ... });
  test("pillsheet_21_0: false（21 == 21）", () { ... });
  test("pillsheet_24_rest_4: true（28 != 24）", () { ... });
});
```

### #activeRestDuration（テストなし）

**追加が必要なテストケース**:
```
group("#activeRestDuration", () {
  test("restDurationsが空の場合はnull", () { ... });
  test("最後のRestDurationがendDate == nullかつbeginDate < now()の場合はそのRestDurationを返す", () { ... });
  test("最後のRestDurationがendDate != nullの場合はnull（終了済み）", () { ... });
  test("最後のRestDurationがbeginDate >= now()の場合はnull（未開始）", () { ... });
  test("複数のRestDurationがある場合、最後のものだけ評価", () { ... });
});
```

### #isActiveFor（テストなし）

**追加が必要なテストケース**:
```
group("#isActiveFor", () {
  test("指定日がピルシート開始日の場合はtrue", () { ... });
  test("指定日がピルシート予想完了日の場合はtrue", () { ... });
  test("指定日がピルシート開始前の場合はfalse", () { ... });
  test("指定日がピルシート完了後の場合はfalse", () { ... });

  group("RestDurationがある場合", () {
    test("未終了のRestDurationによるestimatedEndTakenDateの延長を考慮", () { ... });
    test("終了済みのRestDurationによるestimatedEndTakenDateの延長を考慮", () { ... });
  });

  group("境界値テスト", () {
    test("開始日の00:00:00", () { ... });
    test("完了日の23:59:59", () { ... });
  });
});
```

### #displayPillTakeDate（テストなし）

**追加が必要なテストケース**:
```
group("#displayPillTakeDate", () {
  test("1番目のピルの日付を取得", () { ... });
  test("最後のピルの日付を取得", () { ... });

  group("RestDurationがある場合", () {
    test("RestDuration前のピルの日付", () { ... });
    test("RestDuration後のピルの日付（スキップされている）", () { ... });
  });

  group("異なるPillSheetTypeでのテスト", () {
    // 各PillSheetTypeごとに
  });

  // 注意: pillNumberInPillSheetが範囲外の場合のテストは書かない（RangeErrorが発生するが仕様上問題ない）
});
```

### #pillNumberFor（テストなし - 間接的にテストされている）

**追加が必要なテストケース**:
```
group("#pillNumberFor", () {
  test("beginingDate.date() == targetDateの場合は1を返す", () { ... });
  test("targetDate < beginingDate.date()の場合は1を返す（最小値保証）", () { ... });
  test("開始後の各日付での計算確認", () { ... });

  group("RestDurationがある場合", () {
    test("RestDuration前の日付", () { ... });
    test("RestDuration中の日付", () { ... });
    test("RestDuration後の日付", () { ... });
    test("複数のRestDurationがある場合", () { ... });
  });

  group("月をまたぐ場合の計算", () {
    test("3月30日から4月5日の計算", () { ... });
  });
});
```

---

## 例外処理の確認

### PillSheetTypeFunctions.fromRawPath
- **場所**: lib/entity/pill_sheet_type.dart
- **例外**: `ArgumentError.notNull('')`
- **条件**: 不正なrawPathが渡された場合
- **対応**: 例外が必要な理由をコメントに明記する

```dart
// 不正なpillSheetTypeReferencePathが渡された場合、
// データの整合性を保つためにArgumentErrorをthrowする
default:
  throw ArgumentError.notNull('');
```

---

## テスト実行コマンド

```bash
flutter test test/entity/pill_sheet_test.dart
```
