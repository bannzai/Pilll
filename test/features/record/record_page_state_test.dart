import 'package:pilll/features/record/components/pill_sheet/record_page_pill_sheet.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/delay.dart';
import '../../helper/mock.mocks.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#markFor", () {
    test("it is alredy taken all", () async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final pillSheetEntity = PillSheet.create(
        PillSheetType.pillsheet_21,
        beginDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-23"),
        pillTakenCount: 1,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1"],
        pillSheets: [pillSheetEntity],
        createdAt: now(),
      );

      await waitForResetStoreState();
      expect(
        pillSheetGroup.pillSheets.first.todayPillNumber,
        pillSheetGroup.pillSheets.first.lastTakenOrZeroPillNumber,
      );
      expect(pillSheetGroup.pillSheets.first.todayPillIsAlreadyTaken, isTrue);
      expect(
        pillMarkFor(pillNumberInPillSheet: 1, pillSheet: pillSheetEntity),
        PillMarkType.done,
      );
      expect(
        pillMarkFor(pillNumberInPillSheet: 2, pillSheet: pillSheetEntity),
        PillMarkType.done,
      );
      expect(
        pillMarkFor(pillNumberInPillSheet: 3, pillSheet: pillSheetEntity),
        PillMarkType.done,
      );
      expect(
        pillMarkFor(pillNumberInPillSheet: 4, pillSheet: pillSheetEntity),
        PillMarkType.normal,
      );
    });
    test("it is not taken all", () async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final pillSheetEntity = PillSheet.create(
        PillSheetType.pillsheet_21,
        beginDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-22"),
        pillTakenCount: 1,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1"],
        pillSheets: [pillSheetEntity],
        createdAt: now(),
      );

      await waitForResetStoreState();
      expect(pillSheetGroup.pillSheets.first.todayPillIsAlreadyTaken, isFalse);
      expect(
        pillMarkFor(pillNumberInPillSheet: 1, pillSheet: pillSheetEntity),
        PillMarkType.done,
      );
      expect(
        pillMarkFor(pillNumberInPillSheet: 2, pillSheet: pillSheetEntity),
        PillMarkType.done,
      );
      expect(
        pillMarkFor(pillNumberInPillSheet: 3, pillSheet: pillSheetEntity),
        PillMarkType.normal,
      );
      expect(
        pillMarkFor(pillNumberInPillSheet: 4, pillSheet: pillSheetEntity),
        PillMarkType.normal,
      );
    });
  });
  group("#shouldPillMarkAnimation", () {
    test("it is alredy taken all", () async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final pillSheetEntity = PillSheet.create(
        PillSheetType.pillsheet_21,
        beginDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-23"),
        pillTakenCount: 1,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1"],
        pillSheets: [pillSheetEntity],
        createdAt: now(),
      );
      await waitForResetStoreState();
      expect(pillSheetGroup.pillSheets.first.todayPillIsAlreadyTaken, isTrue);
      for (int i = 1; i <= pillSheetEntity.pillSheetType.totalCount; i++) {
        expect(
          shouldPillMarkAnimation(
            pillNumberInPillSheet: i,
            pillSheet: pillSheetEntity,
            pillSheetGroup: pillSheetGroup,
          ),
          isFalse,
        );
      }
    });
    test("it is not taken all", () async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final pillSheetEntity = PillSheet.create(
        PillSheetType.pillsheet_21,
        beginDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-22"),
        pillTakenCount: 1,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1"],
        pillSheets: [pillSheetEntity],
        createdAt: now(),
      );

      await waitForResetStoreState();
      expect(pillSheetGroup.pillSheets.first.todayPillIsAlreadyTaken, isFalse);
      expect(
        shouldPillMarkAnimation(
          pillNumberInPillSheet: 3,
          pillSheet: pillSheetEntity,
          pillSheetGroup: pillSheetGroup,
        ),
        isTrue,
      );
    });
  });

  group("#remainingPillTakenCountFor", () {
    group("v1の場合", () {
      test("実薬期間でもnullが返される（1錠飲みユーザーは数字表示なし）", () async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-11-21");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final pillSheetEntity = PillSheet.create(
          PillSheetType.pillsheet_21,
          beginDate: DateTime.parse("2020-11-21"),
          lastTakenDate: null,
          pillTakenCount: 1,
        );

        await waitForResetStoreState();
        expect(
          remainingPillTakenCountFor(
            pillNumberInPillSheet: 1,
            pillSheet: pillSheetEntity,
          ),
          isNull,
        );
        expect(
          remainingPillTakenCountFor(
            pillNumberInPillSheet: 22,
            pillSheet: pillSheetEntity,
          ),
          isNull,
        );
      });
    });

    group("v2 実薬期間", () {
      test("未服用の場合、takenCount（2）が返される", () async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-11-21");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final pillSheetEntity = PillSheet.create(
          PillSheetType.pillsheet_21,
          beginDate: DateTime.parse("2020-11-21"),
          lastTakenDate: null,
          pillTakenCount: 2,
        );

        await waitForResetStoreState();
        expect(
          remainingPillTakenCountFor(
            pillNumberInPillSheet: 1,
            pillSheet: pillSheetEntity,
          ),
          2,
        );
      });

      test("1回服用済みの場合、1が返される", () async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-11-21");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final pillSheetEntity = PillSheet.create(
          PillSheetType.pillsheet_21,
          beginDate: DateTime.parse("2020-11-21"),
          lastTakenDate: null,
          pillTakenCount: 2,
        ) as PillSheetV2;
        // 1回服用した状態を作成
        final updatedPills = pillSheetEntity.pills.map((pill) {
          if (pill.index == 0) {
            return pill.copyWith(
              pillTakens: [
                PillTaken(
                  recordedTakenDateTime: mockToday,
                  createdDateTime: mockToday,
                  updatedDateTime: mockToday,
                ),
              ],
            );
          }
          return pill;
        }).toList();
        final updatedPillSheet = pillSheetEntity.copyWith(pills: updatedPills);

        await waitForResetStoreState();
        expect(
          remainingPillTakenCountFor(
            pillNumberInPillSheet: 1,
            pillSheet: updatedPillSheet,
          ),
          1,
        );
      });

      test("2回服用済みの場合、nullが返される（完了）", () async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-11-21");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final pillSheetEntity = PillSheet.create(
          PillSheetType.pillsheet_21,
          beginDate: DateTime.parse("2020-11-20"),
          lastTakenDate: DateTime.parse("2020-11-20"),
          pillTakenCount: 2,
        );

        await waitForResetStoreState();
        // 1日目は服用済みなのでnull
        expect(
          remainingPillTakenCountFor(
            pillNumberInPillSheet: 1,
            pillSheet: pillSheetEntity,
          ),
          isNull,
        );
        // 2日目は未服用なので2
        expect(
          remainingPillTakenCountFor(
            pillNumberInPillSheet: 2,
            pillSheet: pillSheetEntity,
          ),
          2,
        );
      });
    });

    group("v2 休薬期間（pillsheet_21の22-28日目）", () {
      test("未服用の場合、takenCount（2）が返される", () async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-11-21");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final pillSheetEntity = PillSheet.create(
          PillSheetType.pillsheet_21,
          beginDate: DateTime.parse("2020-11-21"),
          lastTakenDate: null,
          pillTakenCount: 2,
        );

        await waitForResetStoreState();
        // 22日目は休薬期間だが、数字は表示される
        expect(
          remainingPillTakenCountFor(
            pillNumberInPillSheet: 22,
            pillSheet: pillSheetEntity,
          ),
          2,
        );
        expect(
          remainingPillTakenCountFor(
            pillNumberInPillSheet: 28,
            pillSheet: pillSheetEntity,
          ),
          2,
        );
      });
    });

    group("v2 偽薬期間（pillsheet_28_4の25-28日目）", () {
      test("未服用の場合、takenCount（2）が返される", () async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-11-21");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final pillSheetEntity = PillSheet.create(
          PillSheetType.pillsheet_28_4,
          beginDate: DateTime.parse("2020-11-21"),
          lastTakenDate: null,
          pillTakenCount: 2,
        );

        await waitForResetStoreState();
        // 25日目は偽薬期間だが、数字は表示される
        expect(
          remainingPillTakenCountFor(
            pillNumberInPillSheet: 25,
            pillSheet: pillSheetEntity,
          ),
          2,
        );
        expect(
          remainingPillTakenCountFor(
            pillNumberInPillSheet: 28,
            pillSheet: pillSheetEntity,
          ),
          2,
        );
      });
    });
  });
}
