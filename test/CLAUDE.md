# テスト作成ガイドライン

このドキュメントは、Pilllプロジェクトにおけるテスト作成時の網羅性と注意点をまとめたものです。

## 基本方針

### テスト対象の判断
- 使われていない getter/method は削除する
- 分岐がない・計算が単純すぎる・テストを追加する意味がないものはスキップ
- テストがないものは `group("#methodName")` を追加してテストケースを書く
- テストがあってもケース不十分なものはケースを追加

### 例外のテスト
- 例外の種類までチェックする必要はない（例外が起きたかどうかをチェック）
- なぜその例外が必要かがコード上に明記がない場合は明記する

---

## 網羅性チェックリスト

### 1. PillSheetAppearanceMode による変化
ピルシートの表示モードによって動作が変わる場合、以下のモードをテストする:
- `number`: 番号表示
- `date`: 日付表示
- `sequential`: 連番表示
- `cyclicSequential`: 周期的連番表示

### 2. PillSheetType による変化
ピルの種類によって錠数、実錠/偽薬期間/休薬期間の有無・長さが変わる:
- `pillsheet_21`: 21錠（21日服用 + 7日休薬）
- `pillsheet_24`: 24錠（24日服用 + 4日休薬）
- `pillsheet_28_0`: 28錠（実薬のみ）
- `pillsheet_28_4`: 28錠（24日実薬 + 4日偽薬）
- `pillsheet_28_7`: 28錠（21日実薬 + 7日偽薬）

**注意**: `for value in PillSheetType.values` のようなテストは避け、必要なものは個別で静的に group/test を作成する

### 3. RestDuration（服用お休み期間）の有無
服用お休み期間によってピルシートの表示番号・日付が変化する:
- 服用お休みがない場合
- 服用お休みが終わっていない場合（`endDate` が null）
- 服用お休みが終わっている場合（`endDate` が設定済み）
- 複数の服用お休み期間がある場合

### 4. PillSheetGroupDisplayNumberSetting の有無
ピルシート上に表示される開始と終了の番号が変化する:
- 設定なしの場合
- `beginPillNumber` のみ設定
- `endPillNumber` のみ設定
- 両方設定

### 5. PillSheet 間の境界値チェック（優先度: 高）
複数シートがある場合、境界の値を優先的にチェックする:
- 1枚目の最後の番号と2枚目の開始の番号
- 2枚目の終了の番号と3枚目の開始の番号
- 各シートの `groupIndex` が正しいか

### 6. now() による変化
`now()` によって「どこまで服用したか」「今日服用するのはどれか」などの情報が変化する:
- 必要に応じて `todayRepository` をモックしてテストケースを作成

```dart
final mockTodayRepository = MockTodayService();
todayRepository = mockTodayRepository;
when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));
```

---

## 日付に関する境界値テスト（優先度: 高）

日付を扱うテストでは、端末での動作確認が難しいため積極的に境界値テストを書く。

### 月をまたぐケース
```dart
test('月をまたぐ生理期間で期間内の日付ならtrue', () {
  // 8月30日開始、9月3日終了の生理期間で、9月1日をテスト
  when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-01'));
  final menstruation = Menstruation(
    beginDate: DateTime.parse('2020-08-30'),
    endDate: DateTime.parse('2020-09-03'),
    ...
  );
});
```

### 年をまたぐケース
```dart
test('年をまたぐ生理期間で期間内の日付ならtrue', () {
  // 12月30日開始、1月3日終了の期間で、1月1日をテスト
  when(mockTodayRepository.now()).thenReturn(DateTime.parse('2021-01-01'));
  final menstruation = Menstruation(
    beginDate: DateTime.parse('2020-12-30'),
    endDate: DateTime.parse('2021-01-03'),
    ...
  );
});
```

### うるう年のケース
```dart
test('うるう年の2月29日を含む期間で2月29日ならtrue', () {
  // 2020年はうるう年
  when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-02-29'));
  final menstruation = Menstruation(
    beginDate: DateTime.parse('2020-02-27'),
    endDate: DateTime.parse('2020-03-02'),
    ...
  );
});

test('非うるう年の2月を含む場合の日数計算', () {
  // 2021年は非うるう年なので2月は28日まで
  final menstruation = Menstruation(
    beginDate: DateTime.parse('2021-02-27'),
    endDate: DateTime.parse('2021-03-02'),
    ...
  );
  // 2/27から3/2は3日間の差
  expect(menstruation.dateRange.days, 3);
});
```

### 時刻情報の正規化
```dart
test('beginDateに時刻が含まれていても日付のみに正規化される', () {
  final menstruation = Menstruation(
    beginDate: DateTime(2020, 9, 1, 23, 59, 59), // 時刻あり
    endDate: DateTime.parse('2020-09-05'),
    ...
  );
  // dateRange は時刻を除去して日付のみ
  expect(dateRange.begin, DateTime.parse('2020-09-01'));
});
```

---

## 複数シートの組み合わせテスト

### 年をまたぐ複数シート
```dart
test("複数シートで年をまたぐ場合", () {
  // 1枚目: 12月10日開始
  final pillSheet1 = PillSheet(
    beginingDate: DateTime.parse("2020-12-10"),
    ...
  );
  // 2枚目: 1月7日開始
  final pillSheet2 = PillSheet(
    beginingDate: DateTime.parse("2021-01-07"),
    ...
  );

  // 1枚目: 12月と1月をまたぐ
  expect(displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 22), "12/31");
  expect(displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 23), "1/1");
});
```

### 1枚目に服用お休み期間がある複数シート
```dart
test("1枚目に服用お休みがあり終わっている場合、2枚目の日付は正しく計算される", () {
  final pillSheet1 = PillSheet(
    beginingDate: DateTime.parse("2020-09-01"),
    restDurations: [
      RestDuration(
        beginDate: DateTime.parse("2020-09-10"),
        endDate: DateTime.parse("2020-09-12"), // 2日分ずれる
      )
    ],
    ...
  );
  // 2枚目は1枚目の服用お休みの影響を受けて開始日がずれている
  final pillSheet2 = PillSheet(
    beginingDate: DateTime.parse("2020-09-30"),
    ...
  );
});
```

---

## テストの構造

### group と test の命名規則
```dart
group("#methodName", () {
  group("条件カテゴリ", () {
    test("具体的なシナリオや条件を日本語で", () {
      // テスト実装
    });
  });
});
```

### enum を使った網羅的テスト
コンパイラの性質と一目でどういうテストかわかるバランスを取る:
```dart
group("#someMethod", () {
  for (final value in SomeEnum.values) {
    group("$value によるテスト", () {
      test("$value の場合のテスト", () {
        switch (value) {
          case SomeEnum.case1:
            // テスト実装
            break;
          case SomeEnum.case2:
            // テスト実装
            break;
        }
      });
    });
  }
});
```

---

## 動作確認コマンド

テストを書いたら必ず以下を実行:

```bash
# フォーマット整形
dart fix --apply lib && dart format lib -l 150

# 単体テスト実行（特定ファイル）
flutter test test/entity/{entity_file}_test.dart

# 全テスト実行
flutter test
```

---

## チェックリストまとめ

テストを書く際は以下を確認:

- [ ] PillSheetAppearanceMode の各モードでの動作
- [ ] PillSheetType の違いによる影響
- [ ] RestDuration の有無・終了状態による影響
- [ ] PillSheetGroupDisplayNumberSetting の有無による影響
- [ ] 複数シートの境界値
- [ ] now() のモックが必要か
- [ ] 月をまたぐケース
- [ ] 年をまたぐケース
- [ ] うるう年のケース
- [ ] 時刻情報の正規化が必要か
