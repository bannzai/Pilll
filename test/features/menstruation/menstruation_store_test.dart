import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_function.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/features/menstruation/components/menstruation_card_list.dart';
import 'package:pilll/features/menstruation/menstruation_card_state.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group("#cardState", () {
    // 問い合わせ再現: ユーザーが「偽薬期間1日目（22日）に生理が来る」と期待しているが、
    // アプリは12/17と表示している問題
    // ピルシート構成: 24+24+28+24+24+28 = 152錠、pillNumberForFromMenstruation = 72
    // 期待: 偽薬1日目（シート5の25番目=149番目）= 12/22
    // 実際: 144番目（シート5の20番目）= 12/17
    test(
      "ユーザー問い合わせケース: 152錠サイクルで72番ごとに生理設定、2回目の生理予定日が偽薬期間ではなく実薬期間になる問題",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final mockToday = DateTime(2025, 12, 17);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        // シート5（最後のシート）の開始日: 2025-11-28
        final sheet5BeginDate = DateTime(2025, 11, 28);

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3", "4", "5", "6"],
          pillSheets: [
            // シート0: 24錠（実薬のみ）- 1-24番
            PillSheet.v1(
              id: "1",
              typeInfo: PillSheetType.pillsheet_24_0.typeInfo,
              beginDate: sheet5BeginDate.subtract(
                const Duration(days: 24 + 24 + 28 + 24 + 24),
              ),
              lastTakenDate: sheet5BeginDate.subtract(
                const Duration(days: 24 + 24 + 28 + 24 + 24 - 23),
              ),
              createdAt: now(),
              groupIndex: 0,
            ),
            // シート1: 24錠（実薬のみ）- 25-48番
            PillSheet.v1(
              id: "2",
              typeInfo: PillSheetType.pillsheet_24_0.typeInfo,
              beginDate: sheet5BeginDate.subtract(
                const Duration(days: 24 + 28 + 24 + 24),
              ),
              lastTakenDate: sheet5BeginDate.subtract(
                const Duration(days: 24 + 28 + 24 + 24 - 23),
              ),
              createdAt: now(),
              groupIndex: 1,
            ),
            // シート2: 28錠（24実薬+4偽薬）- 49-76番（偽薬は73-76番）
            PillSheet.v1(
              id: "3",
              typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
              beginDate: sheet5BeginDate.subtract(
                const Duration(days: 28 + 24 + 24),
              ),
              lastTakenDate: sheet5BeginDate.subtract(
                const Duration(days: 28 + 24 + 24 - 27),
              ),
              createdAt: now(),
              groupIndex: 2,
            ),
            // シート3: 24錠（実薬のみ）- 77-100番
            PillSheet.v1(
              id: "4",
              typeInfo: PillSheetType.pillsheet_24_0.typeInfo,
              beginDate: sheet5BeginDate.subtract(
                const Duration(days: 24 + 24),
              ),
              lastTakenDate: sheet5BeginDate.subtract(
                const Duration(days: 24 + 24 - 23),
              ),
              createdAt: now(),
              groupIndex: 3,
            ),
            // シート4: 24錠（実薬のみ）- 101-124番
            PillSheet.v1(
              id: "5",
              typeInfo: PillSheetType.pillsheet_24_0.typeInfo,
              beginDate: sheet5BeginDate.subtract(const Duration(days: 24)),
              lastTakenDate: sheet5BeginDate.subtract(
                const Duration(days: 24 - 23),
              ),
              createdAt: now(),
              groupIndex: 4,
            ),
            // シート5: 28錠（24実薬+4偽薬）- 125-152番（偽薬は149-152番）
            PillSheet.v1(
              id: "6",
              typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
              beginDate: sheet5BeginDate,
              lastTakenDate: DateTime(2025, 12, 16), // 12/17時点で19番目まで服用
              createdAt: now(),
              groupIndex: 5,
            ),
          ],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        const setting = Setting(
          pillSheetTypes: [
            PillSheetType.pillsheet_24_0,
            PillSheetType.pillsheet_24_0,
            PillSheetType.pillsheet_28_4,
            PillSheetType.pillsheet_24_0,
            PillSheetType.pillsheet_24_0,
            PillSheetType.pillsheet_28_4,
          ],
          pillNumberForFromMenstruation: 72, // 72番ごとに生理
          durationMenstruation: 4,
          reminderTimes: [],
          timezoneDatabaseName: null,
          isOnReminder: true,
        );

        final calendarScheduledMenstruationBandModels =
            scheduledMenstruationDateRanges(pillSheetGroup, setting, [], 12)
                .map(
                  (e) => CalendarScheduledMenstruationBandModel(e.begin, e.end),
                )
                .toList();

        final actual = cardState(
          pillSheetGroup,
          null,
          setting,
          calendarScheduledMenstruationBandModels,
        );

        // 現在の実装の動作を確認:
        // 72番ごとに生理 → fromMenstruations = [72, 144]
        // 72番目 = シート2の24番目（実薬最後）= シート2開始日 + 23日
        // 144番目 = シート5の20番目（実薬）= シート5開始日(11/28) + 19日 = 12/17
        //
        // ユーザーの期待:
        // 偽薬1日目 = シート5の25番目 = 149番目 = 11/28 + 24日 = 12/22
        //
        // 問題: 現在の計算では144番目（12/17）が生理予定日になるが、
        // ユーザーは偽薬1日目（12/22）を期待している

        // 現在の実装では12/17が返される（これがバグの再現）
        // 実際のユーザーの期待は12/22
        expect(
          actual,
          MenstruationCardState(
            title: "生理予定日",
            scheduleDate: DateTime(2025, 12, 17), // 現在の実装の結果（144番目=シート5の20番目）
            countdownString: "生理予定：1日目",
          ),
        );

        // 計算の検証：
        // 72番ごとに生理設定 → fromMenstruations = [72, 144]
        // - 72番目: シート2(49-76)の24番目（72-48=24）= 実薬最後
        // - 144番目: シート5(125-152)の20番目（144-124=20）= 実薬（偽薬ではない！）
        //
        // ユーザーの期待（偽薬1日目に生理）:
        // - シート2の偽薬1日目: 73番目
        // - シート5の偽薬1日目: 149番目
        //
        // 結論: これはバグではなく、「72番ごと」という設定と「偽薬期間に生理が来る」
        // というユーザーの期待のミスマッチ。
        // ユーザーが選択した72番は「シート2の実薬最後の日」であり、
        // 72番ごとに加算すると144番目（シート5の実薬20番目）になる。
        // 偽薬1日目（149番目）とは5日ずれる。

        // NOTE: ユーザーが本来期待している動作:
        // 偽薬1日目（12/22）に生理予定日が表示されることを期待
        // これを実現するには pillNumberForFromMenstruation を 73 に設定すべきか、
        // または実装を修正して偽薬期間を考慮する必要がある
      },
    );

    test(
      "if latestMenstruation is into mockToday, when return card state of begining about menstruation ",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final mockToday = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [],
          pillSheets: [],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillSheetTypes: [PillSheetType.pillsheet_21],
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          reminderTimes: [],
          timezoneDatabaseName: null,
          isOnReminder: true,
        );
        final menstruations = [
          Menstruation(
            beginDate: DateTime(2021, 04, 28),
            endDate: DateTime(2021, 04, 30),
            createdAt: DateTime(2021, 04, 28),
          ),
          Menstruation(
            beginDate: DateTime(2021, 03, 28),
            endDate: DateTime(2021, 03, 30),
            createdAt: DateTime(2021, 03, 28),
          ),
        ];
        final calendarScheduledMenstruationBandModels =
            scheduledMenstruationDateRanges(
          pillSheetGroup,
          setting,
          menstruations,
          12,
        )
                .map(
                  (e) => CalendarScheduledMenstruationBandModel(e.begin, e.end),
                )
                .toList();

        final actual = cardState(
          pillSheetGroup,
          menstruations.first,
          setting,
          calendarScheduledMenstruationBandModels,
        );

        expect(
          actual,
          MenstruationCardState(
            title: "生理開始日",
            scheduleDate: DateTime(2021, 04, 28),
            countdownString: "2日目",
          ),
        );
      },
    );
    test(
      "if latestMenstruation is out of duration and latest pill sheet is null",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final mockToday = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [],
          pillSheets: [],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillSheetTypes: [PillSheetType.pillsheet_21],
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          reminderTimes: [],
          timezoneDatabaseName: null,
          isOnReminder: true,
        );
        final menstruations = [
          Menstruation(
            beginDate: DateTime(2021, 03, 28),
            endDate: DateTime(2021, 03, 30),
            createdAt: DateTime(2021, 03, 28),
          ),
        ];
        final calendarScheduledMenstruationBandModels =
            scheduledMenstruationDateRanges(
          pillSheetGroup,
          setting,
          menstruations,
          12,
        )
                .map(
                  (e) => CalendarScheduledMenstruationBandModel(e.begin, e.end),
                )
                .toList();

        final actual = cardState(
          pillSheetGroup,
          menstruations.first,
          setting,
          calendarScheduledMenstruationBandModels,
        );
        expect(actual, null);
      },
    );

    test(
      "if latest pillsheet.beginDate + totalCount < mockToday, when return schedueld card state",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final mockToday = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [
            PillSheet.v1(
              id: firestoreIDGenerator(),
              typeInfo: PillSheetType.pillsheet_21.typeInfo,
              beginDate: DateTime(2021, 04, 22),
              lastTakenDate: null,
              createdAt: now(),
            ),
          ],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillSheetTypes: [PillSheetType.pillsheet_21],
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          reminderTimes: [],
          timezoneDatabaseName: null,
          isOnReminder: true,
        );
        final calendarScheduledMenstruationBandModels =
            scheduledMenstruationDateRanges(pillSheetGroup, setting, [], 12)
                .map(
                  (e) => CalendarScheduledMenstruationBandModel(e.begin, e.end),
                )
                .toList();

        final actual = cardState(
          pillSheetGroup,
          null,
          setting,
          calendarScheduledMenstruationBandModels,
        );
        expect(
          actual,
          MenstruationCardState(
            title: "生理予定日",
            scheduleDate: DateTime(2021, 05, 13),
            countdownString: "あと14日",
          ),
        );
      },
    );
    test(
      "if todayPillNumber > setting.pillNumberForFromMenstruation, when return card state of into duration for schedueld menstruation",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final mockToday = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [
            PillSheet.v1(
              id: firestoreIDGenerator(),
              typeInfo: PillSheetType.pillsheet_21.typeInfo,
              beginDate: DateTime(2021, 04, 07),
              lastTakenDate: null,
              createdAt: now(),
            ),
          ],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillSheetTypes: [PillSheetType.pillsheet_21],
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          reminderTimes: [],
          timezoneDatabaseName: null,
          isOnReminder: true,
        );
        final menstruations = [
          Menstruation(
            beginDate: DateTime(2021, 03, 28),
            endDate: DateTime(2021, 03, 30),
            createdAt: DateTime(2021, 03, 28),
          ),
        ];
        final calendarScheduledMenstruationBandModels =
            scheduledMenstruationDateRanges(
          pillSheetGroup,
          setting,
          menstruations,
          12,
        )
                .map(
                  (e) => CalendarScheduledMenstruationBandModel(e.begin, e.end),
                )
                .toList();
        final actual = cardState(
          pillSheetGroup,
          menstruations.first,
          setting,
          calendarScheduledMenstruationBandModels,
        );
        expect(
          actual,
          MenstruationCardState(
            title: "生理予定日",
            scheduleDate: DateTime(2021, 04, 28),
            countdownString: "生理予定：2日目",
          ),
        );
      },
    );
  });
}
