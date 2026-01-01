# PillSheetGroup Entity テスト追加計画

## 対象ファイル
- 実装: `lib/entity/pill_sheet_group.codegen.dart`
- テスト: `test/entity/pill_sheet_group_test.dart`
- テスト: `test/entity/pill_sheet_group_display_domain_test.dart`

## テスト書く上での注意事項

### 基本ルール
- group内で `#getter名` または `#method名` の形式で命名
- テストケースは日本語で記述
- now()/today()のモックは `MockTodayService` を使用
- ピルシート間の境界値テストを優先的に追加

### 考慮すべき変数
1. **PillSheetAppearanceMode**: number, date, sequential, cyclicSequential
2. **PillSheetGroupDisplayNumberSetting**: beginPillNumber, endPillNumber の有無
3. **ピルシート枚数**: 1枚、2枚、3枚以上
4. **RestDuration**: なし、1つ、複数
5. **ピルシート間境界**: 1枚目最後と2枚目開始の境界

---

## テスト充実度評価

### テストが充実しているもの（追加不要または限定的）
- `menstruationDateRanges`（複数シナリオカバー済み）
- `displayPillSheetDate`（複数シナリオカバー済み）
- `cycleSequentialPillSheetNumber`（displayNumberSetting含む）
- `pillNumbersForCyclicSequential`（displayNumberSetting含む）

### テストが少ないもの
- `sequentialLastTakenPillNumber`（2つのみ）
- `lastTakenPillNumberWithoutDate`（骨組みのみ）

---

## テスト追加対象

### #activePillSheet（テストなし）

**追加が必要なテストケース**:
```
group("#activePillSheet", () {
  test("アクティブなピルシートがある場合はそのピルシートを返す", () { ... });
  test("アクティブなピルシートがない場合はnullを返す", () { ... });
  test("削除済みのピルシートは対象外", () { ... });

  group("複数ピルシートがある場合", () {
    test("2枚目がアクティブな場合は2枚目を返す", () { ... });
    test("1枚目と2枚目の境界日（1枚目最終日の翌日）", () { ... });
  });
});
```

### #activePillSheetWhen（テストなし）

**追加が必要なテストケース**:
```
group("#activePillSheetWhen", () {
  test("指定日付に対応するアクティブなピルシートを返す", () { ... });
  test("指定日付がどのピルシートの期間にも含まれない場合はnullを返す", () { ... });
  test("複数ピルシート間の境界日", () { ... });
  test("過去の日付を指定した場合", () { ... });
});
```

### #replaced（テストなし）

**追加が必要なテストケース**:
```
group("#replaced", () {
  test("同一IDのピルシートが正しく置き換わる", () { ... });
  test("pillSheet.id == nullの場合はFormatExceptionをスロー", () {
    expect(() => pillSheetGroup.replaced(pillSheetWithNullId), throwsFormatException);
  });
  test("指定したIDのピルシートが見つからない場合はFormatExceptionをスロー", () {
    expect(() => pillSheetGroup.replaced(pillSheetWithUnknownId), throwsFormatException);
  });
  test("置き換え前後で他のピルシートは変わらない", () { ... });

  group("複数ピルシートがある場合", () {
    test("2枚目のピルシートを置き換え", () { ... });
    test("3枚目のピルシートを置き換え", () { ... });
  });
});
```

### #isDeactived（テストなし）

**追加が必要なテストケース**:
```
group("#isDeactived", () {
  test("activePillSheet == nullの場合はtrue", () { ... });
  test("deletedAtが設定されている場合はtrue", () { ... });
  test("activePillSheet != null かつ deletedAt == nullの場合はfalse", () { ... });
});
```

### #sequentialTodayPillNumber（テストなし）

**追加が必要なテストケース**:
```
group("#sequentialTodayPillNumber", () {
  group("PillSheetAppearanceMode.number", () {
    test("0を返す", () { ... });
  });

  group("PillSheetAppearanceMode.date", () {
    test("0を返す", () { ... });
  });

  group("PillSheetAppearanceMode.sequential", () {
    test("今日のピル番号を返す", () { ... });
    test("今日のピルが存在しない場合は0を返す", () { ... });
  });

  group("PillSheetAppearanceMode.cyclicSequential", () {
    test("今日のピル番号を返す", () { ... });
    test("displayNumberSettingの影響", () { ... });
  });
});
```

### #sequentialLastTakenPillNumber（テストあり - ケース不足）

**追加が必要なテストケース**:
```
group("#sequentialLastTakenPillNumber", () {
  // 既存テストに追加
  test("activePillSheetがnullの場合は0を返す", () { ... });

  group("PillSheetAppearanceMode.sequential", () {
    // 注意: 実装を確認すると、sequentialモードでは today() 基準で計算されている（潜在的バグ？）
    test("today()基準での計算", () { ... });
  });

  group("PillSheetAppearanceMode.cyclicSequential", () {
    test("lastTakenDate基準での計算", () { ... });
    test("複数ピルシート間の境界値", () { ... });
    test("RestDurationがある場合", () { ... });
  });
});
```

### #sequentialEstimatedEndPillNumber（テストなし）

**追加が必要なテストケース**:
```
group("#sequentialEstimatedEndPillNumber", () {
  test("number/dateモードでは0を返す", () { ... });
  test("sequential/cyclicSequentialモードでは最後のピル番号を返す", () { ... });
  test("displayNumberSetting（endPillNumber設定時）の影響", () { ... });
  test("複数ピルシート時の最終番号", () { ... });
});
```

### #lastTakenPillSheetOrFirstPillSheet（テストなし）

**追加が必要なテストケース**:
```
group("#lastTakenPillSheetOrFirstPillSheet", () {
  test("服用履歴がない場合はpillSheets[0]を返す", () { ... });
  test("1枚目で服用した場合は1枚目を返す", () { ... });
  test("2枚目で服用した場合は2枚目を返す", () { ... });
  test("複数ピルシート中で中間のものが最後に服用されたケース", () { ... });
  test("すべてのピルシートでlastTakenDate == nullの場合はpillSheets[0]を返す", () { ... });
});
```

### #lastTakenPillNumberWithoutDate（テストなし - 骨組みのみ）

**追加が必要なテストケース**:
```
group("#lastTakenPillNumberWithoutDate", () {
  test("lastTakenDate == nullの場合はnullを返す", () { ... });

  group("PillSheetAppearanceMode.number/date", () {
    test("_pillNumberInPillSheet経由の結果", () { ... });
  });

  group("PillSheetAppearanceMode.sequential/cyclicSequential", () {
    test("_cycleSequentialPillSheetNumber経由の結果", () { ... });
  });

  test("複数ピルシートでの計算", () { ... });
});
```

### #pillSheetTypes（テストなし）

**追加が必要なテストケース**:
```
group("#pillSheetTypes", () {
  test("ピルシートの種類が正しくマッピングされている", () { ... });
  test("複数ピルシートで異なる種類の場合", () { ... });
  test("同じ種類のピルシートが複数ある場合", () { ... });
  test("順序が保証されている", () { ... });
});
```

### #restDurations（テストなし）

**追加が必要なテストケース**:
```
group("#restDurations", () {
  test("RestDurationがない場合は空配列を返す", () { ... });
  test("複数ピルシートの服用お休み期間が統合される", () { ... });
  test("各ピルシートが複数のRestDurationを持つ場合", () { ... });
  test("順序が保証されている", () { ... });
});
```

### PillSheetGroupPillSheetModifiedHistoryDomain Extension

#### #pillNumberWithoutDateOrZeroFromDate（テストなし）

**追加が必要なテストケース**:
```
group("#pillNumberWithoutDateOrZeroFromDate", () {
  group("各PillSheetAppearanceMode", () {
    test("numberモードでの計算", () { ... });
    test("dateモードでの計算", () { ... });
    test("sequentialモードでの計算", () { ... });
    test("cyclicSequentialモードでの計算", () { ... });
  });

  test("estimatedEventCausingDateによる計算の違い", () { ... });
  test("日付が存在しない場合はStateError", () {
    expect(() => pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(...), throwsStateError);
  });
});
```

#### #pillNumberWithoutDateOrZero（テストなし）

**追加が必要なテストケース**:
```
group("#pillNumberWithoutDateOrZero", () {
  test("pillNumberInPillSheet == 0の場合は0を返す", () { ... });

  group("各PillSheetAppearanceMode", () {
    test("numberモード", () { ... });
    test("dateモード", () { ... });
    test("sequentialモード", () { ... });
    test("cyclicSequentialモード", () { ... });
  });

  test("pageIndexが複数の場合の計算", () { ... });
  test("displayNumberSettingの影響", () { ... });
});
```

### PillSheetGroupDisplayDomain Extension

#### #displayPillNumberWithoutDate（テストなし）

**追加が必要なテストケース**:
```
group("#displayPillNumberWithoutDate", () {
  test("各モードでの文字列表現が正確", () { ... });
});
```

#### #displayPillNumberOrDate（テストなし）

**追加が必要なテストケース**:
```
group("#displayPillNumberOrDate", () {
  test("numberモード: 番号を返す", () { ... });
  test("dateモード + premiumOrTrial: 日付を返す", () { ... });
  test("dateモード + 非プレミアム: 番号を返す", () { ... });
  test("sequential/cyclicSequentialモード: 連続番号を返す", () { ... });
  test("displayNumberSettingの影響", () { ... });
});
```

### PillSheetGroupPillNumberDomain Extension

#### #pillMark（テストなし）

**追加が必要なテストケース**:
```
group("#pillMark", () {
  test("指定されたピルシートのマーク情報を正確に返す", () { ... });
  test("存在しないピルシートIDの場合はStateError", () {
    expect(() => pillSheetGroup.pillMark(...), throwsStateError);
  });

  group("各PillSheetAppearanceMode", () {
    // 各モードでの結果の違い
  });
});
```

#### #pillMarks（テストなし）

**追加が必要なテストケース**:
```
group("#pillMarks", () {
  test("numberモード: pillNumbersInPillSheetを返す", () { ... });
  test("dateモード: pillNumbersInPillSheetを返す", () { ... });
  test("sequentialモード: pillNumbersForCyclicSequentialを返す", () { ... });
  test("cyclicSequentialモード: pillNumbersForCyclicSequentialを返す", () { ... });
});
```

### PillSheetGroupRestDurationDomain Extension

#### #lastActiveRestDuration（テストなし）

**追加が必要なテストケース**:
```
group("#lastActiveRestDuration", () {
  test("アクティブなRestDurationがない場合はnullを返す", () { ... });
  test("アクティブなRestDuration（endDate == null）がある場合はそれを返す", () { ... });
  test("終了済みのRestDuration（endDate != null）は対象外", () { ... });
  test("複数ピルシートで最初に見つかったアクティブなRestDurationを返す", () { ... });
});
```

#### #targetBeginRestDurationPillSheet（テストなし）

**追加が必要なテストケース**:
```
group("#targetBeginRestDurationPillSheet", () {
  test("lastTakenPillSheetOrFirstPillSheet.isTakenAll == falseの場合は現在のピルシート", () { ... });
  test("lastTakenPillSheetOrFirstPillSheet.isTakenAll == trueの場合は次のピルシート", () { ... });
  test("最後のピルシートでisTakenAll == trueの場合はRangeError", () {
    expect(() => pillSheetGroup.targetBeginRestDurationPillSheet, throwsRangeError);
  });
});
```

#### #availableRestDurationBeginDate（テストなし）

**追加が必要なテストケース**:
```
group("#availableRestDurationBeginDate", () {
  test("targetBeginRestDurationPillSheet.lastTakenDate == nullの場合はtoday()を返す", () { ... });
  test("targetBeginRestDurationPillSheet.lastTakenDate != nullの場合はその翌日を返す", () { ... });
  test("複数ピルシート間での計算", () { ... });
});
```

### PillSheetAppearanceModeExt Extension

#### #isSequential（テストなし）

**追加が必要なテストケース**:
```
group("#isSequential", () {
  test("numberモード: false", () { ... });
  test("dateモード: false", () { ... });
  test("sequentialモード: true", () { ... });
  test("cyclicSequentialモード: true", () { ... });
});
```

---

## 例外処理の確認

### replaced メソッド
- **例外**: `FormatException`
- **条件1**: `pillSheet.id == null`
- **条件2**: 指定したIDのピルシートが見つからない（index == -1）
- **状態**: 理由が明記されている

### pillNumberWithoutDateOrZeroFromDate
- **例外**: `StateError`（firstWhereで要素なし）
- **対応**: 必要に応じてコメントを追加

### targetBeginRestDurationPillSheet
- **例外**: `RangeError`（pillSheets[groupIndex + 1]が範囲外）
- **対応**: 最後のピルシートでisTakenAllがtrueの場合の挙動について明記が必要

---

## テスト実行コマンド

```bash
flutter test test/entity/pill_sheet_group_test.dart test/entity/pill_sheet_group_display_domain_test.dart
```
