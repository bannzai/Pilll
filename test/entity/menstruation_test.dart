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
}
