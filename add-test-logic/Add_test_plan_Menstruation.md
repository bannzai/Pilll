# Menstruation Entity テスト追加計画

## 対象ファイル
- 実装: `lib/entity/menstruation.codegen.dart`
- テスト: **新規作成** `test/entity/menstruation_test.dart`

## テスト書く上での注意事項

### 基本ルール
- group内で `#getter名` または `#method名` の形式で命名
- テストケースは日本語で記述
- today()のモックは `MockTodayService` を使用

### 考慮すべき変数
1. **生理期間の長さ**: 1日、複数日
2. **月跨ぎ**: 月をまたぐ場合の計算
3. **年跨ぎ**: 年をまたぐ場合の計算

---

## 削除対象

### #documentID
- **使用状況**: 未使用（lib配下で全く使用されていない）
- **推奨**: 削除

---

## テスト追加対象

### #dateRange（テストなし）

**追加が必要なテストケース**:
```
group("#dateRange", () {
  test("生理期間が1日の場合（beginDate == endDate）", () {
    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-15"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.dateRange.days, 0);
  });

  test("生理期間が複数日の場合", () {
    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.dateRange.days, 5);
  });

  test("月をまたぐ場合", () {
    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-30"),
      endDate: DateTime.parse("2024-02-02"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.dateRange.days, 3);
  });

  test("年をまたぐ場合", () {
    final menstruation = Menstruation(
      beginDate: DateTime.parse("2023-12-30"),
      endDate: DateTime.parse("2024-01-02"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.dateRange.days, 3);
  });

  test("dateRange.inRangeの境界値テスト", () {
    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.dateRange.inRange(DateTime.parse("2024-01-14")), false);
    expect(menstruation.dateRange.inRange(DateTime.parse("2024-01-15")), true);
    expect(menstruation.dateRange.inRange(DateTime.parse("2024-01-17")), true);
    expect(menstruation.dateRange.inRange(DateTime.parse("2024-01-20")), true);
    expect(menstruation.dateRange.inRange(DateTime.parse("2024-01-21")), false);
  });
});
```

### #dateTimeRange（テストなし - 優先度低）

**追加が必要なテストケース**:
```
group("#dateTimeRange", () {
  test("Flutter標準のDateTimeRangeが正しく生成される", () {
    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.dateTimeRange.start, DateTime.parse("2024-01-15"));
    expect(menstruation.dateTimeRange.end, DateTime.parse("2024-01-20"));
  });
});
```

### #isActive（テストなし - 高優先度）

**追加が必要なテストケース**:
```
group("#isActive", () {
  test("生理期間の開始日当日はtrue", () {
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2024-01-15"));

    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.isActive, true);
  });

  test("生理期間の終了日当日はtrue", () {
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2024-01-20"));

    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.isActive, true);
  });

  test("生理期間内の中間日はtrue", () {
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2024-01-17"));

    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.isActive, true);
  });

  test("生理期間の前日はfalse", () {
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2024-01-14"));

    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.isActive, false);
  });

  test("生理期間の翌日はfalse", () {
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2024-01-21"));

    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.isActive, false);
  });

  test("生理期間が1日の場合（beginDate == endDate）", () {
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2024-01-15"));

    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-15"),
      createdAt: DateTime.now(),
    );
    expect(menstruation.isActive, true);
  });

  test("生理期間が1日の場合、前後の日はfalse", () {
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;

    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-15"),
      createdAt: DateTime.now(),
    );

    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2024-01-14"));
    expect(menstruation.isActive, false);

    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2024-01-16"));
    expect(menstruation.isActive, false);
  });

  test("月をまたぐ場合の判定", () {
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;

    final menstruation = Menstruation(
      beginDate: DateTime.parse("2024-03-31"),
      endDate: DateTime.parse("2024-04-03"),
      createdAt: DateTime.now(),
    );

    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2024-04-01"));
    expect(menstruation.isActive, true);
  });
});
```

### #menstruationsDiff（テストなし - 高優先度）

**追加が必要なテストケース**:
```
group("#menstruationsDiff", () {
  test("rhsがnullの場合はnullを返す", () {
    final m1 = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    expect(menstruationsDiff(m1, null), null);
  });

  test("同じ日付のケースは0を返す", () {
    final m1 = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    final m2 = Menstruation(
      beginDate: DateTime.parse("2024-01-15"),
      endDate: DateTime.parse("2024-01-18"),
      createdAt: DateTime.now(),
    );
    expect(menstruationsDiff(m1, m2), 0);
  });

  test("異なる日付のケース", () {
    final m1 = Menstruation(
      beginDate: DateTime.parse("2024-01-01"),
      endDate: DateTime.parse("2024-01-05"),
      createdAt: DateTime.now(),
    );
    final m2 = Menstruation(
      beginDate: DateTime.parse("2024-01-10"),
      endDate: DateTime.parse("2024-01-15"),
      createdAt: DateTime.now(),
    );
    expect(menstruationsDiff(m1, m2), 9);
  });

  test("日付順序が逆の場合も絶対値を返す", () {
    final m1 = Menstruation(
      beginDate: DateTime.parse("2024-01-10"),
      endDate: DateTime.parse("2024-01-15"),
      createdAt: DateTime.now(),
    );
    final m2 = Menstruation(
      beginDate: DateTime.parse("2024-01-01"),
      endDate: DateTime.parse("2024-01-05"),
      createdAt: DateTime.now(),
    );
    expect(menstruationsDiff(m1, m2), 9);
  });

  test("月をまたぐ場合の計算", () {
    final m1 = Menstruation(
      beginDate: DateTime.parse("2024-01-30"),
      endDate: DateTime.parse("2024-02-03"),
      createdAt: DateTime.now(),
    );
    final m2 = Menstruation(
      beginDate: DateTime.parse("2024-02-05"),
      endDate: DateTime.parse("2024-02-10"),
      createdAt: DateTime.now(),
    );
    expect(menstruationsDiff(m1, m2), 6);
  });

  test("年をまたぐ場合の計算", () {
    final m1 = Menstruation(
      beginDate: DateTime.parse("2023-12-25"),
      endDate: DateTime.parse("2023-12-30"),
      createdAt: DateTime.now(),
    );
    final m2 = Menstruation(
      beginDate: DateTime.parse("2024-01-05"),
      endDate: DateTime.parse("2024-01-10"),
      createdAt: DateTime.now(),
    );
    expect(menstruationsDiff(m1, m2), 11);
  });

  test("同じ日付でも時刻が異なる場合は時刻を無視", () {
    final m1 = Menstruation(
      beginDate: DateTime.parse("2024-01-15T08:00:00"),
      endDate: DateTime.parse("2024-01-20"),
      createdAt: DateTime.now(),
    );
    final m2 = Menstruation(
      beginDate: DateTime.parse("2024-01-15T20:00:00"),
      endDate: DateTime.parse("2024-01-18"),
      createdAt: DateTime.now(),
    );
    expect(menstruationsDiff(m1, m2), 0);
  });
});
```

---

## 例外処理の確認

このEntityには例外をthrowするケースはありません。

---

## テスト実行コマンド

```bash
flutter test test/entity/menstruation_test.dart
```
