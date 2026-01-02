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
}
