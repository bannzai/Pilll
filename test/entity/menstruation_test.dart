import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  group('#isActive', () {
    test('今日がbeginDateと同じ日の場合はtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-01'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.isActive, true);
    });

    test('今日がendDateと同じ日の場合はtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-05'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.isActive, true);
    });

    test('今日がbeginDateより後かつendDateより前の場合はtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-03'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.isActive, true);
    });

    test('今日がbeginDateの1日前の場合はfalse', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-08-31'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.isActive, false);
    });

    test('今日がendDateの1日後の場合はfalse', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-06'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.isActive, false);
    });

    test('beginDateとendDateが同じ日の場合、その日ならtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-01'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-01'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.isActive, true);
    });

    test('beginDateとendDateが同じ日の場合、異なる日ならfalse', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-02'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-01'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.isActive, false);
    });

    test('時刻情報が異なっても日付のみで判定される（beginDateに時刻が含まれる場合）', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-01'));

      final menstruation = Menstruation(
        beginDate: DateTime(2020, 9, 1, 23, 59, 59),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.isActive, true);
    });

    test('時刻情報が異なっても日付のみで判定される（endDateに時刻が含まれる場合）', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-05'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime(2020, 9, 5, 0, 0, 1),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.isActive, true);
    });

    test('時刻情報が異なっても日付のみで判定される（todayに時刻が含まれる場合）', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 3, 14, 30, 0));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.isActive, true);
    });

    test('月をまたぐ生理期間で期間内の日付ならtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-01'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-08-30'),
        endDate: DateTime.parse('2020-09-03'),
        createdAt: DateTime.parse('2020-08-30'),
      );

      expect(menstruation.isActive, true);
    });

    test('年をまたぐ生理期間で期間内の日付ならtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2021-01-01'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-12-30'),
        endDate: DateTime.parse('2021-01-03'),
        createdAt: DateTime.parse('2020-12-30'),
      );

      expect(menstruation.isActive, true);
    });

    test('年をまたぐ生理期間でbeginDate（前年）ならtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-12-30'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-12-30'),
        endDate: DateTime.parse('2021-01-03'),
        createdAt: DateTime.parse('2020-12-30'),
      );

      expect(menstruation.isActive, true);
    });

    test('年をまたぐ生理期間でendDate（翌年）ならtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2021-01-03'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-12-30'),
        endDate: DateTime.parse('2021-01-03'),
        createdAt: DateTime.parse('2020-12-30'),
      );

      expect(menstruation.isActive, true);
    });

    test('うるう年の2月29日を含む期間で2月29日ならtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-02-29'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-02-27'),
        endDate: DateTime.parse('2020-03-02'),
        createdAt: DateTime.parse('2020-02-27'),
      );

      expect(menstruation.isActive, true);
    });

    test('うるう年の2月29日を含む期間で3月1日ならtrue', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-03-01'));

      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-02-27'),
        endDate: DateTime.parse('2020-03-02'),
        createdAt: DateTime.parse('2020-02-27'),
      );

      expect(menstruation.isActive, true);
    });
  });

  group('#menstruationsDiff', () {
    test('rhsがnullの場合はnullを返す', () {
      final lhs = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruationsDiff(lhs, null), null);
    });

    test('lhsとrhsのbeginDateが同じ日の場合は0を返す', () {
      final lhs = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );
      final rhs = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-07'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruationsDiff(lhs, rhs), 0);
    });

    test('lhs.beginDateがrhs.beginDateより前の場合は日数差の絶対値を返す', () {
      final lhs = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );
      final rhs = Menstruation(
        beginDate: DateTime.parse('2020-09-29'),
        endDate: DateTime.parse('2020-10-03'),
        createdAt: DateTime.parse('2020-09-29'),
      );

      // 9/1から9/29は28日
      expect(menstruationsDiff(lhs, rhs), 28);
    });

    test('lhs.beginDateがrhs.beginDateより後の場合でも日数差の絶対値を返す', () {
      final lhs = Menstruation(
        beginDate: DateTime.parse('2020-09-29'),
        endDate: DateTime.parse('2020-10-03'),
        createdAt: DateTime.parse('2020-09-29'),
      );
      final rhs = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      // 9/29から9/1は-28日だが、absで28を返す
      expect(menstruationsDiff(lhs, rhs), 28);
    });

    test('月をまたぐ場合の日数計算', () {
      final lhs = Menstruation(
        beginDate: DateTime.parse('2020-08-25'),
        endDate: DateTime.parse('2020-08-30'),
        createdAt: DateTime.parse('2020-08-25'),
      );
      final rhs = Menstruation(
        beginDate: DateTime.parse('2020-09-22'),
        endDate: DateTime.parse('2020-09-27'),
        createdAt: DateTime.parse('2020-09-22'),
      );

      // 8/25から9/22は28日
      expect(menstruationsDiff(lhs, rhs), 28);
    });

    test('年をまたぐ場合の日数計算', () {
      final lhs = Menstruation(
        beginDate: DateTime.parse('2020-12-15'),
        endDate: DateTime.parse('2020-12-20'),
        createdAt: DateTime.parse('2020-12-15'),
      );
      final rhs = Menstruation(
        beginDate: DateTime.parse('2021-01-12'),
        endDate: DateTime.parse('2021-01-17'),
        createdAt: DateTime.parse('2021-01-12'),
      );

      // 12/15から1/12は28日
      expect(menstruationsDiff(lhs, rhs), 28);
    });

    test('時刻情報が含まれていても日付のみで計算される（beginDateに時刻が含まれる場合）', () {
      final lhs = Menstruation(
        beginDate: DateTime(2020, 9, 1, 23, 59, 59),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );
      final rhs = Menstruation(
        beginDate: DateTime(2020, 9, 29, 0, 0, 1),
        endDate: DateTime.parse('2020-10-03'),
        createdAt: DateTime.parse('2020-09-29'),
      );

      // 時刻を無視して9/1から9/29は28日
      expect(menstruationsDiff(lhs, rhs), 28);
    });

    test('1日差の場合', () {
      final lhs = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );
      final rhs = Menstruation(
        beginDate: DateTime.parse('2020-09-02'),
        endDate: DateTime.parse('2020-09-06'),
        createdAt: DateTime.parse('2020-09-02'),
      );

      expect(menstruationsDiff(lhs, rhs), 1);
    });

    test('うるう年を含む場合の日数計算', () {
      final lhs = Menstruation(
        beginDate: DateTime.parse('2020-02-15'),
        endDate: DateTime.parse('2020-02-20'),
        createdAt: DateTime.parse('2020-02-15'),
      );
      final rhs = Menstruation(
        beginDate: DateTime.parse('2020-03-14'),
        endDate: DateTime.parse('2020-03-19'),
        createdAt: DateTime.parse('2020-03-14'),
      );

      // 2/15から3/14: 2月は2020年はうるう年なので29日まである。15日差 + 14日 = 28日
      expect(menstruationsDiff(lhs, rhs), 28);
    });
  });

  group('#dateRange', () {
    test('beginDateとendDateから正しいDateRangeが生成される', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      final dateRange = menstruation.dateRange;

      expect(dateRange.begin, DateTime.parse('2020-09-01'));
      expect(dateRange.end, DateTime.parse('2020-09-05'));
    });

    test('beginDateに時刻が含まれていても日付のみに正規化される', () {
      final menstruation = Menstruation(
        beginDate: DateTime(2020, 9, 1, 23, 59, 59),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      final dateRange = menstruation.dateRange;

      expect(dateRange.begin, DateTime.parse('2020-09-01'));
      expect(dateRange.end, DateTime.parse('2020-09-05'));
    });

    test('endDateに時刻が含まれていても日付のみに正規化される', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime(2020, 9, 5, 12, 30, 45),
        createdAt: DateTime.parse('2020-09-01'),
      );

      final dateRange = menstruation.dateRange;

      expect(dateRange.begin, DateTime.parse('2020-09-01'));
      expect(dateRange.end, DateTime.parse('2020-09-05'));
    });

    test('beginDateとendDateの両方に時刻が含まれていても日付のみに正規化される', () {
      final menstruation = Menstruation(
        beginDate: DateTime(2020, 9, 1, 8, 0, 0),
        endDate: DateTime(2020, 9, 5, 20, 0, 0),
        createdAt: DateTime.parse('2020-09-01'),
      );

      final dateRange = menstruation.dateRange;

      expect(dateRange.begin, DateTime.parse('2020-09-01'));
      expect(dateRange.end, DateTime.parse('2020-09-05'));
    });

    test('beginDateとendDateが同じ日の場合、daysは0になる', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-01'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.dateRange.days, 0);
    });

    test('5日間の生理期間の場合、daysは4になる（開始日と終了日の差）', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      // 9/1から9/5は4日間の差
      expect(menstruation.dateRange.days, 4);
    });

    test('月をまたぐ場合の日数計算', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-08-28'),
        endDate: DateTime.parse('2020-09-03'),
        createdAt: DateTime.parse('2020-08-28'),
      );

      // 8/28から9/3は6日間の差
      expect(menstruation.dateRange.days, 6);
    });

    test('年をまたぐ場合の日数計算', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-12-29'),
        endDate: DateTime.parse('2021-01-03'),
        createdAt: DateTime.parse('2020-12-29'),
      );

      // 12/29から1/3は5日間の差
      expect(menstruation.dateRange.days, 5);
    });

    test('うるう年の2月を含む場合の日数計算', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-02-27'),
        endDate: DateTime.parse('2020-03-02'),
        createdAt: DateTime.parse('2020-02-27'),
      );

      // 2020年はうるう年なので2月は29日まである
      // 2/27から3/2は4日間の差
      expect(menstruation.dateRange.days, 4);
    });

    test('非うるう年の2月を含む場合の日数計算', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2021-02-27'),
        endDate: DateTime.parse('2021-03-02'),
        createdAt: DateTime.parse('2021-02-27'),
      );

      // 2021年は非うるう年なので2月は28日まで
      // 2/27から3/2は3日間の差
      expect(menstruation.dateRange.days, 3);
    });
  });

  group('#dateTimeRange', () {
    test('beginDateとendDateから正しいDateTimeRangeが生成される', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      final dateTimeRange = menstruation.dateTimeRange;

      expect(dateTimeRange.start, DateTime.parse('2020-09-01'));
      expect(dateTimeRange.end, DateTime.parse('2020-09-05'));
    });

    test('時刻情報がそのまま保持される（beginDateに時刻が含まれる場合）', () {
      final menstruation = Menstruation(
        beginDate: DateTime(2020, 9, 1, 23, 59, 59),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      final dateTimeRange = menstruation.dateTimeRange;

      // dateTimeRangeは時刻情報をそのまま保持する（dateRangeとの違い）
      expect(dateTimeRange.start, DateTime(2020, 9, 1, 23, 59, 59));
      expect(dateTimeRange.end, DateTime.parse('2020-09-05'));
    });

    test('時刻情報がそのまま保持される（endDateに時刻が含まれる場合）', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime(2020, 9, 5, 12, 30, 45),
        createdAt: DateTime.parse('2020-09-01'),
      );

      final dateTimeRange = menstruation.dateTimeRange;

      expect(dateTimeRange.start, DateTime.parse('2020-09-01'));
      expect(dateTimeRange.end, DateTime(2020, 9, 5, 12, 30, 45));
    });

    test('時刻情報がそのまま保持される（両方に時刻が含まれる場合）', () {
      final menstruation = Menstruation(
        beginDate: DateTime(2020, 9, 1, 8, 0, 0),
        endDate: DateTime(2020, 9, 5, 20, 0, 0),
        createdAt: DateTime.parse('2020-09-01'),
      );

      final dateTimeRange = menstruation.dateTimeRange;

      expect(dateTimeRange.start, DateTime(2020, 9, 1, 8, 0, 0));
      expect(dateTimeRange.end, DateTime(2020, 9, 5, 20, 0, 0));
    });

    test('beginDateとendDateが同じ日時の場合、durationは0になる', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-01'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.dateTimeRange.duration, Duration.zero);
    });

    test('5日間の生理期間の場合、durationは4日になる', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-09-01'),
        endDate: DateTime.parse('2020-09-05'),
        createdAt: DateTime.parse('2020-09-01'),
      );

      expect(menstruation.dateTimeRange.duration, const Duration(days: 4));
    });

    test('時刻が含まれる場合のduration計算', () {
      final menstruation = Menstruation(
        beginDate: DateTime(2020, 9, 1, 8, 0, 0),
        endDate: DateTime(2020, 9, 5, 20, 0, 0),
        createdAt: DateTime.parse('2020-09-01'),
      );

      // 9/1 8:00から9/5 20:00は4日12時間
      expect(menstruation.dateTimeRange.duration, const Duration(days: 4, hours: 12));
    });

    test('月をまたぐ場合の日数計算', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-08-28'),
        endDate: DateTime.parse('2020-09-03'),
        createdAt: DateTime.parse('2020-08-28'),
      );

      // 8/28から9/3は6日間の差
      expect(menstruation.dateTimeRange.duration, const Duration(days: 6));
    });

    test('年をまたぐ場合の日数計算', () {
      final menstruation = Menstruation(
        beginDate: DateTime.parse('2020-12-29'),
        endDate: DateTime.parse('2021-01-03'),
        createdAt: DateTime.parse('2020-12-29'),
      );

      // 12/29から1/3は5日間の差
      expect(menstruation.dateTimeRange.duration, const Duration(days: 5));
    });
  });
}
