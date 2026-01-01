# PillSheetModifiedHistory Entity テスト追加計画

## 対象ファイル
- 実装: `lib/entity/pill_sheet_modified_history.codegen.dart`
- 実装: `lib/entity/pill_sheet_modified_history_value.codegen.dart`
- テスト: `test/entity/pill_sheet_modified_history_test.dart`

## テスト書く上での注意事項

### 基本ルール
- group内で `#getter名` または `#method名` の形式で命名
- テストケースは日本語で記述
- Factoryメソッドは例外処理のテストを優先
- now()のモックは `MockTodayService` を使用

### 考慮すべき変数
1. **PillSheetModifiedActionType**: 全12種類のアクションタイプ
2. **beforePillSheetGroup/afterPillSheetGroup**: nullの場合、nullでない場合
3. **estimatedEventCausingDate**: 過去の日付、現在の日付

---

## テスト充実度評価

### テストが充実しているもの
- `missedPillDays`（8つのテストケースあり）

### テストがないもの
- 全てのgetter
- 全てのFactory methods

---

## テスト追加対象

### #enumActionType（テストなし）

**追加が必要なテストケース**:
```
group("#enumActionType", () {
  for (final actionType in PillSheetModifiedActionType.values) {
    test("${actionType.name}が正しく取得される", () {
      final history = PillSheetModifiedHistory(
        id: 'test_id',
        actionType: actionType.name,
        estimatedEventCausingDate: DateTime.now(),
        createdAt: DateTime.now(),
        value: const PillSheetModifiedHistoryValue(),
        beforePillSheetGroup: null,
        afterPillSheetGroup: null,
        pillSheetID: null,
        pillSheetGroupID: null,
        beforePillSheetID: null,
        afterPillSheetID: null,
        before: null,
        after: null,
      );
      expect(history.enumActionType, actionType);
    });
  }

  test("無効なactionTypeの場合はnullが返される", () {
    final history = PillSheetModifiedHistory(
      id: 'test_id',
      actionType: 'invalid_action_type',
      estimatedEventCausingDate: DateTime.now(),
      createdAt: DateTime.now(),
      value: const PillSheetModifiedHistoryValue(),
      beforePillSheetGroup: null,
      afterPillSheetGroup: null,
      pillSheetID: null,
      pillSheetGroupID: null,
      beforePillSheetID: null,
      afterPillSheetID: null,
      before: null,
      after: null,
    );
    expect(history.enumActionType, null);
  });
});
```

### #beforeActivePillSheet（テストなし）

**追加が必要なテストケース**:
```
group("#beforeActivePillSheet", () {
  test("beforePillSheetGroupがnullの場合はnullを返す", () {
    final history = PillSheetModifiedHistory(
      id: 'test_id',
      actionType: PillSheetModifiedActionType.takenPill.name,
      estimatedEventCausingDate: DateTime.now(),
      createdAt: DateTime.now(),
      value: const PillSheetModifiedHistoryValue(),
      beforePillSheetGroup: null,
      afterPillSheetGroup: null,
      pillSheetID: null,
      pillSheetGroupID: null,
      beforePillSheetID: null,
      afterPillSheetID: null,
      before: null,
      after: null,
    );
    expect(history.beforeActivePillSheet, null);
  });

  test("beforePillSheetGroupがnull以外の場合、estimatedEventCausingDateでactivePillSheetを取得", () {
    // PillSheetGroupとPillSheetを作成してテスト
    ...
  });
});
```

### #afterActivePillSheet（テストなし）

**追加が必要なテストケース**:
```
group("#afterActivePillSheet", () {
  test("afterPillSheetGroupがnullの場合はnullを返す", () {
    final history = PillSheetModifiedHistory(
      id: 'test_id',
      actionType: PillSheetModifiedActionType.takenPill.name,
      estimatedEventCausingDate: DateTime.now(),
      createdAt: DateTime.now(),
      value: const PillSheetModifiedHistoryValue(),
      beforePillSheetGroup: null,
      afterPillSheetGroup: null,
      pillSheetID: null,
      pillSheetGroupID: null,
      beforePillSheetID: null,
      afterPillSheetID: null,
      before: null,
      after: null,
    );
    expect(history.afterActivePillSheet, null);
  });

  test("afterPillSheetGroupがnull以外の場合、estimatedEventCausingDateでactivePillSheetを取得", () {
    // PillSheetGroupとPillSheetを作成してテスト
    ...
  });
});
```

### PillSheetModifiedActionTypeFunctions Extension

#### #name（テストなし）

**追加が必要なテストケース**:
```
group("PillSheetModifiedActionTypeFunctions", () {
  group("#name", () {
    test("すべてのアクションタイプで正しい名前文字列が取得される", () {
      expect(PillSheetModifiedActionType.createdPillSheet.name, 'createdPillSheet');
      expect(PillSheetModifiedActionType.automaticallyRecordedLastTakenDate.name, 'automaticallyRecordedLastTakenDate');
      expect(PillSheetModifiedActionType.deletedPillSheet.name, 'deletedPillSheet');
      expect(PillSheetModifiedActionType.takenPill.name, 'takenPill');
      expect(PillSheetModifiedActionType.revertTakenPill.name, 'revertTakenPill');
      expect(PillSheetModifiedActionType.changedPillNumber.name, 'changedPillNumber');
      expect(PillSheetModifiedActionType.endedPillSheet.name, 'endedPillSheet');
      expect(PillSheetModifiedActionType.beganRestDuration.name, 'beganRestDuration');
      expect(PillSheetModifiedActionType.endedRestDuration.name, 'endedRestDuration');
      expect(PillSheetModifiedActionType.changedRestDurationBeginDate.name, 'changedRestDurationBeginDate');
      expect(PillSheetModifiedActionType.changedRestDuration.name, 'changedRestDuration');
      expect(PillSheetModifiedActionType.changedBeginDisplayNumber.name, 'changedBeginDisplayNumber');
      expect(PillSheetModifiedActionType.changedEndDisplayNumber.name, 'changedEndDisplayNumber');
    });
  });
});
```

### PillSheetModifiedHistoryServiceActionFactory

#### #createTakenPillAction（テストなし）

**追加が必要なテストケース**:
```
group("PillSheetModifiedHistoryServiceActionFactory", () {
  group("#createTakenPillAction", () {
    test("正常に履歴が作成される", () {
      // テスト用のPillSheet, PillSheetGroupを作成
      final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        pillSheetGroupID: 'group_id',
        before: beforePillSheet,
        after: afterPillSheet,
        beforePillSheetGroup: beforeGroup,
        afterPillSheetGroup: afterGroup,
        isQuickRecord: false,
      );
      expect(history.actionType, 'takenPill');
      expect(history.value.takenPill, isNotNull);
      ...
    });

    test("after.idがnullの場合はFormatExceptionをスロー", () {
      expect(
        () => PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheetWithNullId,
          beforePillSheetGroup: beforeGroup,
          afterPillSheetGroup: afterGroup,
          isQuickRecord: false,
        ),
        throwsFormatException,
      );
    });

    test("after.lastTakenDateがnullの場合はFormatExceptionをスロー", () {
      expect(
        () => PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          pillSheetGroupID: 'group_id',
          before: beforePillSheet,
          after: afterPillSheetWithNullLastTakenDate,
          beforePillSheetGroup: beforeGroup,
          afterPillSheetGroup: afterGroup,
          isQuickRecord: false,
        ),
        throwsFormatException,
      );
    });

    test("isQuickRecord: trueの場合", () {
      final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
        ...
        isQuickRecord: true,
      );
      expect(history.value.takenPill?.isQuickRecord, true);
    });
  });
});
```

#### #createRevertTakenPillAction（テストなし）

**追加が必要なテストケース**:
```
group("#createRevertTakenPillAction", () {
  test("正常に履歴が作成される", () { ... });

  test("after.idがnullの場合はFormatExceptionをスロー", () {
    expect(..., throwsFormatException);
  });

  test("before.idがnullの場合はFormatExceptionをスロー", () {
    expect(..., throwsFormatException);
  });

  test("before.lastTakenDateがnullの場合はFormatExceptionをスロー", () {
    expect(..., throwsFormatException);
  });

  test("after.lastTakenDateがnullの場合でも正常に処理される（2025-01-16変更）", () {
    // after.lastTakenDateはnullable
    ...
  });
});
```

#### #createCreatedPillSheetAction（テストなし）

**追加が必要なテストケース**:
```
group("#createCreatedPillSheetAction", () {
  test("正常に履歴が作成される", () { ... });
  test("before/afterがnullで設定される", () { ... });
  test("pillSheetIDsが正しく設定される", () { ... });
});
```

#### #createChangedPillNumberAction（テストなし）

**追加が必要なテストケース**:
```
group("#createChangedPillNumberAction", () {
  test("正常に履歴が作成される", () { ... });

  test("after.idがnullの場合はFormatExceptionをスロー", () {
    expect(..., throwsFormatException);
  });

  test("pillSheetGroupIDがnullの場合はFormatExceptionをスロー", () {
    expect(..., throwsFormatException);
  });

  test("before/afterのbeginingDateとtodayPillNumberが正しく記録される", () { ... });
});
```

#### #createDeletedPillSheetAction（テストなし）

**追加が必要なテストケース**:
```
group("#createDeletedPillSheetAction", () {
  test("正常に履歴が作成される", () { ... });
  test("before/afterがnullで設定される", () { ... });
  test("pillSheetIDsが正しく設定される", () { ... });
});
```

#### #createBeganRestDurationAction（テストなし）

**追加が必要なテストケース**:
```
group("#createBeganRestDurationAction", () {
  test("正常に履歴が作成される", () { ... });
  test("RestDurationがvalueに正しく保存される", () { ... });
});
```

#### #createEndedRestDurationAction（テストなし）

**追加が必要なテストケース**:
```
group("#createEndedRestDurationAction", () {
  test("正常に履歴が作成される", () { ... });
  test("RestDurationがvalueに正しく保存される", () { ... });
});
```

#### #createChangedRestDurationBeginDateAction（テストなし）

**追加が必要なテストケース**:
```
group("#createChangedRestDurationBeginDateAction", () {
  test("正常に履歴が作成される", () { ... });
  test("beforeRestDuration/afterRestDurationがvalueに正しく保存される", () { ... });
});
```

#### #createChangedRestDurationAction（テストなし）

**追加が必要なテストケース**:
```
group("#createChangedRestDurationAction", () {
  test("正常に履歴が作成される", () { ... });
  test("beforeRestDuration/afterRestDurationがvalueに正しく保存される", () { ... });
});
```

#### #createChangedBeginDisplayNumberAction（テストなし）

**追加が必要なテストケース**:
```
group("#createChangedBeginDisplayNumberAction", () {
  test("正常に履歴が作成される", () { ... });
  test("beforeDisplayNumberSettingがnullでも正常に処理される", () { ... });
  test("before/afterのPillSheetがnullで設定される", () { ... });
});
```

#### #createChangedEndDisplayNumberAction（テストなし）

**追加が必要なテストケース**:
```
group("#createChangedEndDisplayNumberAction", () {
  test("正常に履歴が作成される", () { ... });
  test("beforeDisplayNumberSettingがnullでも正常に処理される", () { ... });
  test("before/afterのPillSheetがnullで設定される", () { ... });
});
```

### #missedPillDays（テストあり - 追加検討）

**現状**: 8つのテストケースあり

**追加を検討するテストケース**:
```
group("#missedPillDays", () {
  // 既存テストに追加
  test("maxDateがminDateより小さい場合の挙動", () { ... });

  test("takenPillでもautomaticallyRecordedLastTakenDateでもないアクションが混在する場合", () {
    // changedPillNumber, beganRestDurationなどが混在
    ...
  });
});
```

---

## 例外処理の確認

### Factoryメソッドの例外

| メソッド | 例外 | 条件 | 理由明記 |
|---------|------|------|---------|
| createTakenPillAction | FormatException | after.id == null または after.lastTakenDate == null | 明記済み |
| createRevertTakenPillAction | FormatException | after.id == null, before.id == null, before.lastTakenDate == null | 明記済み |
| createChangedPillNumberAction | FormatException | after.id == null または pillSheetGroupID == null | 明記済み |

### assertの使用

以下のメソッドでは`assert(pillSheetGroupID != null)`が使用されています:
- createTakenPillAction
- createRevertTakenPillAction
- createCreatedPillSheetAction
- createChangedPillNumberAction
- createDeletedPillSheetAction
- createBeganRestDurationAction
- createEndedRestDurationAction
- createChangedRestDurationBeginDateAction
- createChangedRestDurationAction

**注意**: `createChangedBeginDisplayNumberAction`と`createChangedEndDisplayNumberAction`ではassertがありません。これが意図的かどうか確認が必要です。

---

## テスト実行コマンド

```bash
flutter test test/entity/pill_sheet_modified_history_test.dart
```
