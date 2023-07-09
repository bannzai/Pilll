import 'package:mockito/mockito.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/features/record/components/pill_sheet/components/pill_number.dart';
import 'package:pilll/features/record/components/pill_sheet/record_page_pill_sheet.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/fake.dart';
import '../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#RecordPagePillSheet.textOfPillNumber", () {
    group("pillSheetAppearanceMode is number", () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.number;
      test("it is isPremium or isTrial", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        const pillNumberForFromMenstruation = 22;
        const durationMenstruation = 4;
        const setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          timezoneDatabaseName: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: mockToday,
          lastTakenDate: null,
          createdAt: now(),
          pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: mockToday, toDate: null),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());
        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
            pillSheetGroup: pillSheetGroup,
            pillSheet: pillSheet,
            pillNumberIntoPillSheet: pillNumberIntoPillSheet,
            pageIndex: 0,
            setting: setting,
            premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
          );

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<MenstruationPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
      test("it is not isPremium and isTrial", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        const pillNumberForFromMenstruation = 22;
        const durationMenstruation = 4;
        const setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          timezoneDatabaseName: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );

        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: mockToday,
          lastTakenDate: null,
          createdAt: now(),
          pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: mockToday, toDate: null),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["pill_sheet_id"],
          pillSheets: [pillSheet],
          createdAt: today(),
        );

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: false, fakeIsTrial: false),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
      test("setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        const pillNumberForFromMenstruation = 0;
        const durationMenstruation = 0;
        const setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          timezoneDatabaseName: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: mockToday,
          lastTakenDate: null,
          createdAt: now(),
          pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: mockToday, toDate: null),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
    });
    group("pillSheetAppearanceMode is date", () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.date;
      test("it is isPremium or isTrial", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        const pillNumberForFromMenstruation = 22;
        const durationMenstruation = 4;
        const setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          timezoneDatabaseName: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: mockToday,
          lastTakenDate: null,
          createdAt: now(),
          pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: mockToday, toDate: null),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillDate>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<MenstruationPillDate>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillDate>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
      test("it is not isPremium and isTrial. it is means expired trial or premium user", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        const pillNumberForFromMenstruation = 22;
        const durationMenstruation = 4;
        const setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          timezoneDatabaseName: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: mockToday,
          lastTakenDate: null,
          createdAt: now(),
          pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: mockToday, toDate: null),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: false, fakeIsTrial: false),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
      test("isPremium == true && (setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0)", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        const pillNumberForFromMenstruation = 0;
        const durationMenstruation = 0;
        const setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          timezoneDatabaseName: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: mockToday,
          lastTakenDate: null,
          createdAt: now(),
          pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: mockToday, toDate: null),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillDate>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillDate>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillDate>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
    });
    group("pillSheetAppearanceMode is sequential", () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.sequential;
      test("it is isPremium or isTrial", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        const pillNumberForFromMenstruation = 22;
        const durationMenstruation = 4;
        const setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          timezoneDatabaseName: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: mockToday,
          lastTakenDate: null,
          createdAt: now(),
          pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: mockToday, toDate: null),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());
        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<SequentialPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<MenstruationSequentialPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<SequentialPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
      test("it is not isPremium and isTrial", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        const pillNumberForFromMenstruation = 22;
        const durationMenstruation = 4;
        const setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          timezoneDatabaseName: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: mockToday,
          lastTakenDate: null,
          createdAt: now(),
          pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: mockToday, toDate: null),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: false, fakeIsTrial: false),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<SequentialPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<SequentialPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<SequentialPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
      test("setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        const pillNumberForFromMenstruation = 0;
        const durationMenstruation = 0;
        const setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          timezoneDatabaseName: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginingDate: mockToday,
          lastTakenDate: null,
          createdAt: now(),
          pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: mockToday, toDate: null),
        );

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["pill_sheet_id"],
          pillSheets: [pillSheet],
          createdAt: today(),
        );

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<SequentialPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<SequentialPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<SequentialPillNumber>(), reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
    });
  });
  group("#RecordPagePillSheet.pillTakenDateFromPillNumber", () {
    test("it is not have rest duration", () {
      final originalTodayRepository = todayRepository;
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
      addTearDown(() {
        todayRepository = originalTodayRepository;
      });

      final PillSheet pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21_0, fromDate: DateTime.parse("2020-09-01"), toDate: null),
      );

      expect(pillSheet.pillTakenDateFromPillNumber(1), DateTime.parse("2020-09-01"));
      expect(pillSheet.pillTakenDateFromPillNumber(2), DateTime.parse("2020-09-02"));
      expect(pillSheet.pillTakenDateFromPillNumber(3), DateTime.parse("2020-09-03"));

      expect(pillSheet.pillTakenDateFromPillNumber(10), DateTime.parse("2020-09-10"));
      expect(pillSheet.pillTakenDateFromPillNumber(11), DateTime.parse("2020-09-11"));
      expect(pillSheet.pillTakenDateFromPillNumber(12), DateTime.parse("2020-09-12"));

      expect(pillSheet.pillTakenDateFromPillNumber(26), DateTime.parse("2020-09-26"));
      expect(pillSheet.pillTakenDateFromPillNumber(27), DateTime.parse("2020-09-27"));
      expect(pillSheet.pillTakenDateFromPillNumber(28), DateTime.parse("2020-09-28"));
    });
    group("it is have rest duration", () {
      group("it is not ended rest duration", () {
        test("simualte begin rest duration. pillSheet.lastTakenDate is yesterday and restDuration.beginDate is mockToday.", () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-11"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-11"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          final PillSheet pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_21_0, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-10")),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
              ),
            ],
          );

          expect(pillSheet.pillTakenDateFromPillNumber(1), DateTime.parse("2020-09-01"));
          expect(pillSheet.pillTakenDateFromPillNumber(2), DateTime.parse("2020-09-02"));
          expect(pillSheet.pillTakenDateFromPillNumber(3), DateTime.parse("2020-09-03"));

          expect(pillSheet.pillTakenDateFromPillNumber(10), DateTime.parse("2020-09-10"));
          expect(pillSheet.pillTakenDateFromPillNumber(11), DateTime.parse("2020-09-11"));
          expect(pillSheet.pillTakenDateFromPillNumber(12), DateTime.parse("2020-09-12"));

          expect(pillSheet.pillTakenDateFromPillNumber(26), DateTime.parse("2020-09-26"));
          expect(pillSheet.pillTakenDateFromPillNumber(27), DateTime.parse("2020-09-27"));
          expect(pillSheet.pillTakenDateFromPillNumber(28), DateTime.parse("2020-09-28"));
        });
        test("pillSheet.lastTakenDate is two days ago and restDuration.beginDate from yesterday", () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-12"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-12"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          final PillSheet pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_21_0, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-10")),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
              ),
            ],
          );

          expect(pillSheet.pillTakenDateFromPillNumber(1), DateTime.parse("2020-09-01"));
          expect(pillSheet.pillTakenDateFromPillNumber(2), DateTime.parse("2020-09-02"));
          expect(pillSheet.pillTakenDateFromPillNumber(3), DateTime.parse("2020-09-03"));

          expect(pillSheet.pillTakenDateFromPillNumber(10), DateTime.parse("2020-09-10"));
          expect(pillSheet.pillTakenDateFromPillNumber(11), DateTime.parse("2020-09-12"));
          expect(pillSheet.pillTakenDateFromPillNumber(12), DateTime.parse("2020-09-13"));

          expect(pillSheet.pillTakenDateFromPillNumber(26), DateTime.parse("2020-09-27"));
          expect(pillSheet.pillTakenDateFromPillNumber(27), DateTime.parse("2020-09-28"));
          expect(pillSheet.pillTakenDateFromPillNumber(28), DateTime.parse("2020-09-29"));
        });
      });
      group("it is ended rest duration", () {
        test("pillSheet.lastTakenDate is yesterday and restDuration.endDate is today", () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-11"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-11"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          final PillSheet pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_21_0, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-10")),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
                endDate: DateTime.parse("2020-09-11"),
              ),
            ],
          );

          expect(pillSheet.pillTakenDateFromPillNumber(1), DateTime.parse("2020-09-01"));
          expect(pillSheet.pillTakenDateFromPillNumber(2), DateTime.parse("2020-09-02"));
          expect(pillSheet.pillTakenDateFromPillNumber(3), DateTime.parse("2020-09-03"));

          expect(pillSheet.pillTakenDateFromPillNumber(10), DateTime.parse("2020-09-10"));
          expect(pillSheet.pillTakenDateFromPillNumber(11), DateTime.parse("2020-09-11"));
          expect(pillSheet.pillTakenDateFromPillNumber(12), DateTime.parse("2020-09-12"));

          expect(pillSheet.pillTakenDateFromPillNumber(26), DateTime.parse("2020-09-26"));
          expect(pillSheet.pillTakenDateFromPillNumber(27), DateTime.parse("2020-09-27"));
          expect(pillSheet.pillTakenDateFromPillNumber(28), DateTime.parse("2020-09-28"));
        });

        test("pillSheet.lastTakenDate is two days ago and restDuration.endDate is today", () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-12"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-12"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          final PillSheet pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_21_0, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-10")),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
                endDate: DateTime.parse("2020-09-12"),
              ),
            ],
          );

          expect(pillSheet.pillTakenDateFromPillNumber(1), DateTime.parse("2020-09-01"));
          expect(pillSheet.pillTakenDateFromPillNumber(2), DateTime.parse("2020-09-02"));
          expect(pillSheet.pillTakenDateFromPillNumber(3), DateTime.parse("2020-09-03"));

          expect(pillSheet.pillTakenDateFromPillNumber(10), DateTime.parse("2020-09-10"));
          expect(pillSheet.pillTakenDateFromPillNumber(11), DateTime.parse("2020-09-12"));
          expect(pillSheet.pillTakenDateFromPillNumber(12), DateTime.parse("2020-09-13"));

          expect(pillSheet.pillTakenDateFromPillNumber(13), DateTime.parse("2020-09-14"));
          expect(pillSheet.pillTakenDateFromPillNumber(14), DateTime.parse("2020-09-15"));

          expect(pillSheet.pillTakenDateFromPillNumber(26), DateTime.parse("2020-09-27"));
          expect(pillSheet.pillTakenDateFromPillNumber(27), DateTime.parse("2020-09-28"));
          expect(pillSheet.pillTakenDateFromPillNumber(28), DateTime.parse("2020-09-29"));
        });

        test("Real bug case ", () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-01-14"));
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-01-14"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          final PillSheet pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
            beginingDate: DateTime.parse("2021-12-17"),
            lastTakenDate: DateTime.parse("2022-01-19"),
            createdAt: now(),
            pills: Pill.generateAndFillTo(
                pillSheetType: PillSheetType.pillsheet_28_4, fromDate: DateTime.parse("2021-12-17"), toDate: DateTime.parse("2022-01-19")),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2022-01-10"),
                createdDate: DateTime.parse("2022-01-10"),
                endDate: DateTime.parse("2022-01-10"),
              ),
              RestDuration(
                beginDate: DateTime.parse("2022-01-10"),
                createdDate: DateTime.parse("2022-01-10"),
                endDate: DateTime.parse("2022-01-14"),
              ),
            ],
          );

          expect(pillSheet.pillTakenDateFromPillNumber(1), DateTime.parse("2021-12-17"));
          expect(pillSheet.pillTakenDateFromPillNumber(24), DateTime.parse("2022-01-09"));

          // Bug: Got 2022-01-18
          expect(pillSheet.pillTakenDateFromPillNumber(25), DateTime.parse("2022-01-14"));

          expect(pillSheet.pillTakenDateFromPillNumber(26), DateTime.parse("2022-01-15"));
          expect(pillSheet.pillTakenDateFromPillNumber(28), DateTime.parse("2022-01-17"));
        });
      });
    });
    test("Bugfix 2023-02-11 dev:/users/Ka9rvL7WdFfmV7ZJe24XD9QfBAF2/pill_sheet_groups/pPJ3ncti5k3HfvbxU5Xe", () async {
      final originalTodayRepository = todayRepository;
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2023-01-14"));
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2023-01-14"));
      addTearDown(() {
        todayRepository = originalTodayRepository;
      });

      final PillSheet pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
        beginingDate: DateTime.parse("2023-01-10"),
        lastTakenDate: null,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_4, fromDate: DateTime.parse("2023-01-10"), toDate: null),
        restDurations: [
          RestDuration(
            beginDate: DateTime.parse("2023-01-17"),
            createdDate: DateTime.parse("2023-01-17"),
            endDate: DateTime.parse("2023-01-24"),
          ),
          RestDuration(
            beginDate: DateTime.parse("2023-02-02"),
            createdDate: DateTime.parse("2023-02-02"),
            endDate: DateTime.parse("2023-02-08"),
          ),
        ],
      );

      expect(pillSheet.pillTakenDateFromPillNumber(1), DateTime.parse("2023-01-10"));

      expect(pillSheet.pillTakenDateFromPillNumber(7), DateTime.parse("2023-01-16"));
      expect(pillSheet.pillTakenDateFromPillNumber(8), DateTime.parse("2023-01-24"));

      expect(pillSheet.pillTakenDateFromPillNumber(15), DateTime.parse("2023-01-31"));
      expect(pillSheet.pillTakenDateFromPillNumber(16), DateTime.parse("2023-02-01"));
      expect(pillSheet.pillTakenDateFromPillNumber(17), DateTime.parse("2023-02-08"));

      expect(pillSheet.pillTakenDateFromPillNumber(19), DateTime.parse("2023-02-10"));
      expect(pillSheet.pillTakenDateFromPillNumber(20), DateTime.parse("2023-02-11"));
    });
  });
  group("#RecordPagePillSheet.isContainedMenstruationDuration", () {
    test("group has only one pill sheet", () async {
      final anyDate = DateTime.parse("2020-09-19");
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 0,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1"],
        pillSheets: [pillSheet],
        createdAt: anyDate,
      );
      const setting = Setting(
        pillSheetTypes: [PillSheetType.pillsheet_28_0],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
      );
      const pageIndex = 0;

      for (int i = 1; i <= 28; i++) {
        expect(
            RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: i, pillSheetGroup: pillSheetGroup, pageIndex: pageIndex, setting: setting),
            22 <= i && i <= 24,
            reason: "print debug informations pillNumberIntoPillSheet is $i");
      }
    });
    test("group has three pill sheet and scheduled menstruation begin No.2 pillSheet", () async {
      final anyDate = DateTime.parse("2020-09-19");
      final one = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 0,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final two = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 1,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final three = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 2,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1", "2", "3"],
        pillSheets: [one, two, three],
        createdAt: anyDate,
      );
      const setting = Setting(
        pillSheetTypes: [PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_28_0],
        pillNumberForFromMenstruation: 46,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
      );
      final pillSheetTypes = [PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_28_0];

      for (int pageIndex = 0; pageIndex < pillSheetTypes.length; pageIndex++) {
        for (int pillNumberIntoPillSheet = 1; pillNumberIntoPillSheet <= pillSheetTypes[pageIndex].totalCount; pillNumberIntoPillSheet++) {
          expect(
              RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: pillNumberIntoPillSheet,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting,
              ),
              (pageIndex == 1 && 18 <= pillNumberIntoPillSheet && pillNumberIntoPillSheet <= 20),
              reason: "print debug informations pillNumberIntoPillSheet is $pillNumberIntoPillSheet, pageIndex: $pageIndex");
        }
      }
    });
    test("group has three pill sheet and scheduled menstruation have all sheets", () async {
      final anyDate = DateTime.parse("2020-09-19");
      final one = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 0,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final two = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 1,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final three = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 2,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1", "2", "3"],
        pillSheets: [one, two, three],
        createdAt: anyDate,
      );
      const setting = Setting(
        pillSheetTypes: [PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_28_0],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
      );
      final pillSheetTypes = [PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_28_0, PillSheetType.pillsheet_28_0];

      for (int pageIndex = 0; pageIndex < pillSheetTypes.length; pageIndex++) {
        for (int pillNumberIntoPillSheet = 1; pillNumberIntoPillSheet <= pillSheetTypes[pageIndex].totalCount; pillNumberIntoPillSheet++) {
          expect(
              RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: pillNumberIntoPillSheet,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting,
              ),
              22 <= pillNumberIntoPillSheet && pillNumberIntoPillSheet <= 24,
              reason: "print debug informations pillNumberIntoPillSheet is $pillNumberIntoPillSheet, pageIndex: $pageIndex");
        }
      }
    });
    // 仕様的にはこの内容になるけど、ユーザーの入力としては想定されていない。なので仕様がおかしいとなったらこのテストは守らなくて良い
    test("group has five pill sheet and scheduled menstruation begin No.2 pillSheet", () async {
      final anyDate = DateTime.parse("2020-09-19");
      final one = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 0,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final two = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 1,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final three = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 2,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final four = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 3,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final five = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 4,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1", "2", "3", "4", "5"],
        pillSheets: [one, two, three, four, five],
        createdAt: anyDate,
      );
      const setting = Setting(
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        pillNumberForFromMenstruation: 46,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
      );

      final pillSheetTypes = [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ];

      for (int pageIndex = 0; pageIndex < pillSheetTypes.length; pageIndex++) {
        for (int pillNumberIntoPillSheet = 1; pillNumberIntoPillSheet <= pillSheetTypes[pageIndex].totalCount; pillNumberIntoPillSheet++) {
          final firstMatched = pageIndex == 1 && 18 <= pillNumberIntoPillSheet && pillNumberIntoPillSheet <= 20;
          final secondMatched = pageIndex == 3 && 8 <= pillNumberIntoPillSheet && pillNumberIntoPillSheet <= 10;
          final thirdPatched = pageIndex == 4 && 26 <= pillNumberIntoPillSheet && pillNumberIntoPillSheet <= 28;
          expect(
              RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: pillNumberIntoPillSheet,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting,
              ),
              firstMatched || secondMatched || thirdPatched,
              reason: "print debug informations pillNumberIntoPillSheet is $pillNumberIntoPillSheet, pageIndex: $pageIndex");
        }
      }
    });
    test("for ヤーズフレックス", () async {
      final anyDate = DateTime.parse("2020-09-19");
      final one = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 0,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final two = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 1,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final three = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 2,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final four = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 3,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final five = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        lastTakenDate: null,
        groupIndex: 4,
        createdAt: now(),
        pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_28_0, fromDate: anyDate, toDate: null),
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1", "2", "3", "4", "5"],
        pillSheets: [one, two, three, four, five],
        createdAt: anyDate,
      );
      const setting = Setting(
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        pillNumberForFromMenstruation: 120,
        durationMenstruation: 3,
        isOnReminder: true,
        timezoneDatabaseName: null,
      );

      final pillSheetTypes = [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ];

      for (int pageIndex = 0; pageIndex < pillSheetTypes.length; pageIndex++) {
        for (int pillNumberIntoPillSheet = 1; pillNumberIntoPillSheet <= pillSheetTypes[pageIndex].totalCount; pillNumberIntoPillSheet++) {
          expect(
              RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: pillNumberIntoPillSheet,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting,
              ),
              pageIndex == 4 && 8 <= pillNumberIntoPillSheet && pillNumberIntoPillSheet <= 10,
              reason: "print debug informations pillNumberIntoPillSheet is $pillNumberIntoPillSheet, pageIndex: $pageIndex");
        }
      }
    });
  });
}
