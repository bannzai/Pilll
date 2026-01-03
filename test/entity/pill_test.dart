import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../helper/mock.mocks.dart';

void main() {
  final mockNow = DateTime.parse('2024-01-15T10:00:00');

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(mockNow);
  });

  group('#Pill.generateAndFillTo', () {
    group('pillTakenCount = 1', () {
      test('lastTakenDateがnullの場合、すべてのpillTakensは空リスト', () {
        final pills = Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_28_7,
          fromDate: mockNow,
          lastTakenDate: null,
          pillTakenCount: 1,
        );

        expect(pills.length, 28);
        for (final pill in pills) {
          expect(pill.pillTakens, isEmpty);
        }
      });

      test('lastTakenDateがfromDateの場合、最初のピルのみにpillTakensがある', () {
        final fromDate = mockNow;
        final lastTakenDate = mockNow;

        final pills = Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_28_7,
          fromDate: fromDate,
          lastTakenDate: lastTakenDate,
          pillTakenCount: 1,
        );

        expect(pills.length, 28);
        expect(pills[0].pillTakens.length, 1);
        for (var i = 1; i < pills.length; i++) {
          expect(pills[i].pillTakens, isEmpty);
        }
      });

      test('lastTakenDateがfromDate + 2日の場合、最初の3つのピルにpillTakensがある', () {
        final fromDate = mockNow;
        final lastTakenDate = mockNow.add(const Duration(days: 2));

        final pills = Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_28_7,
          fromDate: fromDate,
          lastTakenDate: lastTakenDate,
          pillTakenCount: 1,
        );

        expect(pills.length, 28);
        expect(pills[0].pillTakens.length, 1);
        expect(pills[1].pillTakens.length, 1);
        expect(pills[2].pillTakens.length, 1);
        for (var i = 3; i < pills.length; i++) {
          expect(pills[i].pillTakens, isEmpty);
        }
      });
    });

    group('pillTakenCount = 2', () {
      test('lastTakenDateがnullの場合、すべてのpillTakensは空リスト', () {
        final pills = Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_28_7,
          fromDate: mockNow,
          lastTakenDate: null,
          pillTakenCount: 2,
        );

        expect(pills.length, 28);
        for (final pill in pills) {
          expect(pill.pillTakens, isEmpty);
        }
      });

      test('lastTakenDateがfromDateの場合、最初のピルに2つのpillTakensがある', () {
        final fromDate = mockNow;
        final lastTakenDate = mockNow;

        final pills = Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_28_7,
          fromDate: fromDate,
          lastTakenDate: lastTakenDate,
          pillTakenCount: 2,
        );

        expect(pills.length, 28);
        expect(pills[0].pillTakens.length, 2);
        for (var i = 1; i < pills.length; i++) {
          expect(pills[i].pillTakens, isEmpty);
        }
      });

      test('lastTakenDateがfromDate + 2日の場合、最初の3つのピルに各2つのpillTakensがある', () {
        final fromDate = mockNow;
        final lastTakenDate = mockNow.add(const Duration(days: 2));

        final pills = Pill.generateAndFillTo(
          pillSheetType: PillSheetType.pillsheet_28_7,
          fromDate: fromDate,
          lastTakenDate: lastTakenDate,
          pillTakenCount: 2,
        );

        expect(pills.length, 28);
        expect(pills[0].pillTakens.length, 2);
        expect(pills[1].pillTakens.length, 2);
        expect(pills[2].pillTakens.length, 2);
        for (var i = 3; i < pills.length; i++) {
          expect(pills[i].pillTakens, isEmpty);
        }
      });
    });
  });
}
