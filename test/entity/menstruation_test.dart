import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  late TodayService originalTodayRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    originalTodayRepository = todayRepository;
  });

  tearDown(() {
    todayRepository = originalTodayRepository;
  });

  group('#isActive', () {
    // isActiveは dateRange.inRange(today()) を呼び出しており、
    // 今日の日付が生理期間内に含まれるかをチェックする

    test('今日が期間開始日と同じ場合はtrueを返す', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 1, 10));

      final menstruation = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruation.isActive, true);
    });

    test('今日が期間終了日と同じ場合はtrueを返す', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 1, 15));

      final menstruation = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruation.isActive, true);
    });

    test('今日が期間中（開始日と終了日の間）の場合はtrueを返す', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 1, 12));

      final menstruation = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruation.isActive, true);
    });

    test('境界値: 今日が期間開始日の1日前の場合はfalseを返す', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 1, 9));

      final menstruation = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruation.isActive, false);
    });

    test('境界値: 今日が期間終了日の1日後の場合はfalseを返す', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 1, 16));

      final menstruation = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruation.isActive, false);
    });

    test('今日が期間より大幅に前の場合はfalseを返す', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 1, 1));

      final menstruation = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruation.isActive, false);
    });

    test('今日が期間より大幅に後の場合はfalseを返す', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 2, 1));

      final menstruation = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruation.isActive, false);
    });

    test('1日だけの生理期間で今日がその日の場合はtrueを返す', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 1, 10));

      final menstruation = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 10),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruation.isActive, true);
    });

    test('年をまたぐ生理期間で今日が期間中の場合はtrueを返す', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 1, 1));

      final menstruation = Menstruation(
        beginDate: DateTime(2023, 12, 30),
        endDate: DateTime(2024, 1, 3),
        createdAt: DateTime(2023, 12, 30),
      );

      expect(menstruation.isActive, true);
    });

    test('月をまたぐ生理期間で今日が期間中の場合はtrueを返す', () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 2, 1));

      final menstruation = Menstruation(
        beginDate: DateTime(2024, 1, 30),
        endDate: DateTime(2024, 2, 3),
        createdAt: DateTime(2024, 1, 30),
      );

      expect(menstruation.isActive, true);
    });
  });

  group('#menstruationsDiff', () {
    // menstruationsDiffは2つの生理記録間の開始日の日数差を計算する

    test('rhsがnullの場合はnullを返す', () {
      final lhs = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruationsDiff(lhs, null), null);
    });

    test('同じ開始日の場合は0を返す', () {
      final lhs = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );
      final rhs = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 13),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruationsDiff(lhs, rhs), 0);
    });

    test('lhsがrhsより後の開始日の場合は正の日数差を返す', () {
      final lhs = Menstruation(
        beginDate: DateTime(2024, 2, 10),
        endDate: DateTime(2024, 2, 15),
        createdAt: DateTime(2024, 2, 10),
      );
      final rhs = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      // 1/10 から 2/10 は31日
      expect(menstruationsDiff(lhs, rhs), 31);
    });

    test('lhsがrhsより前の開始日の場合でも正の日数差を返す（abs）', () {
      final lhs = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );
      final rhs = Menstruation(
        beginDate: DateTime(2024, 2, 10),
        endDate: DateTime(2024, 2, 15),
        createdAt: DateTime(2024, 2, 10),
      );

      // abs()により絶対値を返すので31日
      expect(menstruationsDiff(lhs, rhs), 31);
    });

    test('典型的な28日周期の場合は28を返す', () {
      final lhs = Menstruation(
        beginDate: DateTime(2024, 2, 7),
        endDate: DateTime(2024, 2, 12),
        createdAt: DateTime(2024, 2, 7),
      );
      final rhs = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruationsDiff(lhs, rhs), 28);
    });

    test('境界値: 1日差の場合は1を返す', () {
      final lhs = Menstruation(
        beginDate: DateTime(2024, 1, 11),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 11),
      );
      final rhs = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      expect(menstruationsDiff(lhs, rhs), 1);
    });

    test('年をまたぐ場合でも正しく日数差を計算する', () {
      final lhs = Menstruation(
        beginDate: DateTime(2024, 1, 5),
        endDate: DateTime(2024, 1, 10),
        createdAt: DateTime(2024, 1, 5),
      );
      final rhs = Menstruation(
        beginDate: DateTime(2023, 12, 10),
        endDate: DateTime(2023, 12, 15),
        createdAt: DateTime(2023, 12, 10),
      );

      // 12/10 から 1/5 は26日
      expect(menstruationsDiff(lhs, rhs), 26);
    });

    test('長い周期（60日）の場合でも正しく計算する', () {
      final lhs = Menstruation(
        beginDate: DateTime(2024, 3, 10),
        endDate: DateTime(2024, 3, 15),
        createdAt: DateTime(2024, 3, 10),
      );
      final rhs = Menstruation(
        beginDate: DateTime(2024, 1, 10),
        endDate: DateTime(2024, 1, 15),
        createdAt: DateTime(2024, 1, 10),
      );

      // 1/10 から 3/10 は60日
      expect(menstruationsDiff(lhs, rhs), 60);
    });

    test('うるう年の2月29日を跨ぐ場合でも正しく計算する', () {
      final lhs = Menstruation(
        beginDate: DateTime(2024, 3, 1),
        endDate: DateTime(2024, 3, 5),
        createdAt: DateTime(2024, 3, 1),
      );
      final rhs = Menstruation(
        beginDate: DateTime(2024, 2, 1),
        endDate: DateTime(2024, 2, 5),
        createdAt: DateTime(2024, 2, 1),
      );

      // 2024年はうるう年なので、2/1 から 3/1 は29日
      expect(menstruationsDiff(lhs, rhs), 29);
    });

    test('非うるう年の2月を跨ぐ場合は28日差になる', () {
      final lhs = Menstruation(
        beginDate: DateTime(2023, 3, 1),
        endDate: DateTime(2023, 3, 5),
        createdAt: DateTime(2023, 3, 1),
      );
      final rhs = Menstruation(
        beginDate: DateTime(2023, 2, 1),
        endDate: DateTime(2023, 2, 5),
        createdAt: DateTime(2023, 2, 1),
      );

      // 2023年は非うるう年なので、2/1 から 3/1 は28日
      expect(menstruationsDiff(lhs, rhs), 28);
    });
  });
}
