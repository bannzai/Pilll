import 'package:pilll/analytics.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/state/pill_sheet.dart';
import 'package:pilll/store/pill_sheet.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    analytics = MockAnalytics();
  });
  group("#calcBeginingDateFromNextTodayPillNumber", () {
    test("pill number changed to future", () async {
      final mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-11-22"));

      final pillSheetEntity =
          PillSheetModel.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-22"),
        createdAt: DateTime.parse("2020-11-22"),
      );
      final state = PillSheetState(entity: pillSheetEntity);

      final service = MockPillSheetService();
      when(service.fetchLast())
          .thenAnswer((realInvocation) => Future.value(state.entity));
      when(service.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.empty());

      final store = PillSheetStateStore(service);
      await Future.delayed(Duration(milliseconds: 100));
      expect(state.entity?.todayPillNumber, equals(1));

      final expected = DateTime.parse("2020-11-13");
      final actual = store.calcBeginingDateFromNextTodayPillNumber(10);
      expect(isSameDay(expected, actual), isTrue);
    });
  });
  test("pill number changed to past", () async {
    final mockTodayRepository = MockTodayRepository();
    todayRepository = mockTodayRepository;
    when(todayRepository.today()).thenReturn(DateTime.parse("2020-11-23"));

    final pillSheetEntity =
        PillSheetModel.create(PillSheetType.pillsheet_21).copyWith(
      beginingDate: DateTime.parse("2020-11-21"),
      createdAt: DateTime.parse("2020-11-21"),
    );
    final state = PillSheetState(entity: pillSheetEntity);

    final service = MockPillSheetService();
    when(service.fetchLast())
        .thenAnswer((realInvocation) => Future.value(state.entity));
    when(service.subscribeForLatestPillSheet())
        .thenAnswer((realInvocation) => Stream.empty());

    final store = PillSheetStateStore(service);
    await Future.delayed(Duration(milliseconds: 100));
    expect(state.entity?.todayPillNumber, equals(3));

    final expected = DateTime.parse("2020-11-22");
    final actual = store.calcBeginingDateFromNextTodayPillNumber(2);
    expect(isSameDay(expected, actual), isTrue);
  });
  group("#markFor", () {
    test("it is alredy taken all", () async {
      final mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-11-23"));

      final pillSheetEntity =
          PillSheetModel.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-23"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final state = PillSheetState(entity: pillSheetEntity);

      final service = MockPillSheetService();
      when(service.fetchLast())
          .thenAnswer((realInvocation) => Future.value(state.entity));
      when(service.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.empty());

      final store = PillSheetStateStore(service);
      await Future.delayed(Duration(milliseconds: 100));
      expect(state.entity?.allTaken, isTrue);
      expect(store.markFor(1), PillMarkType.done);
      expect(store.markFor(2), PillMarkType.done);
      expect(store.markFor(3), PillMarkType.done);
      expect(store.markFor(4), PillMarkType.normal);
    });
    test("it is not taken all", () async {
      final mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-11-23"));

      final pillSheetEntity =
          PillSheetModel.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-22"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final state = PillSheetState(entity: pillSheetEntity);

      final service = MockPillSheetService();
      when(service.fetchLast())
          .thenAnswer((realInvocation) => Future.value(state.entity));
      when(service.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.empty());

      final store = PillSheetStateStore(service);
      await Future.delayed(Duration(milliseconds: 100));
      expect(state.entity?.allTaken, isFalse);
      expect(store.markFor(1), PillMarkType.done);
      expect(store.markFor(2), PillMarkType.done);
      expect(store.markFor(3), PillMarkType.normal);
      expect(store.markFor(4), PillMarkType.normal);
    });
  });
  group("#shouldPillMarkAnimation", () {
    test("it is alredy taken all", () async {
      final mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-11-23"));

      final pillSheetEntity =
          PillSheetModel.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-23"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final state = PillSheetState(entity: pillSheetEntity);

      final service = MockPillSheetService();
      when(service.fetchLast())
          .thenAnswer((realInvocation) => Future.value(state.entity));
      when(service.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.empty());

      final store = PillSheetStateStore(service);
      await Future.delayed(Duration(milliseconds: 100));
      expect(state.entity?.allTaken, isTrue);
      for (int i = 1; i <= pillSheetEntity.pillSheetType.totalCount; i++) {
        expect(store.shouldPillMarkAnimation(i), isFalse);
      }
    });
    test("it is not taken all", () async {
      final mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;
      when(todayRepository.today()).thenReturn(DateTime.parse("2020-11-23"));

      final pillSheetEntity =
          PillSheetModel.create(PillSheetType.pillsheet_21).copyWith(
        beginingDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-22"),
        createdAt: DateTime.parse("2020-11-21"),
      );
      final state = PillSheetState(entity: pillSheetEntity);

      final service = MockPillSheetService();
      when(service.fetchLast())
          .thenAnswer((realInvocation) => Future.value(state.entity));
      when(service.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.empty());

      final store = PillSheetStateStore(service);
      await Future.delayed(Duration(milliseconds: 100));
      expect(state.entity?.allTaken, isFalse);
      expect(store.shouldPillMarkAnimation(3), isTrue);
    });
  });
}
