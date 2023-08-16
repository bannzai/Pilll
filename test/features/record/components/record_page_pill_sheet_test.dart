import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
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
    initializeDateFormatting('ja_JP');
  });
  group("#PillNumber", () {
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
          createdAt: now(),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());
        for (int i = 0; i < 28; i++) {
          final pillNumberInPillSheet = i + 1;
          final widget = PillNumber(
            pillSheetGroup: pillSheetGroup,
            pillSheet: pillSheet,
            pillNumberInPillSheet: pillNumberInPillSheet,
            pageIndex: 0,
            setting: setting,
            premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
          );

          if (pillNumberInPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else if (pillNumberInPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<MenstruationPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
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
          createdAt: now(),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberInPillSheet = i + 1;
          final widget = PillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: false, fakeIsTrial: false),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberInPillSheet: pillNumberInPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberInPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else if (pillNumberInPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
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
          createdAt: now(),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberInPillSheet = i + 1;
          final widget = PillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberInPillSheet: pillNumberInPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberInPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else if (pillNumberInPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
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
          createdAt: now(),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberInPillSheet = i + 1;
          final widget = PillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberInPillSheet: pillNumberInPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberInPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else if (pillNumberInPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<MenstruationPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
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
          createdAt: now(),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberInPillSheet = i + 1;
          final widget = PillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: false, fakeIsTrial: false),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberInPillSheet: pillNumberInPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberInPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else if (pillNumberInPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
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
          createdAt: now(),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberInPillSheet = i + 1;
          final widget = PillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberInPillSheet: pillNumberInPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberInPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else if (pillNumberInPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
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
          createdAt: now(),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());
        for (int i = 0; i < 28; i++) {
          final pillNumberInPillSheet = i + 1;
          final widget = PillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberInPillSheet: pillNumberInPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberInPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else if (pillNumberInPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<MenstruationPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
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
          createdAt: now(),
        );
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberInPillSheet = i + 1;
          final widget = PillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: false, fakeIsTrial: false),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberInPillSheet: pillNumberInPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberInPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else if (pillNumberInPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
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
        final pillSheet =
            PillSheet(id: firestoreIDGenerator(), typeInfo: PillSheetType.pillsheet_21.typeInfo, beginingDate: mockToday, createdAt: now());
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["pill_sheet_id"], pillSheets: [pillSheet], createdAt: today());

        for (int i = 0; i < 28; i++) {
          final pillNumberInPillSheet = i + 1;
          final widget = PillNumber(
              premiumAndTrial: FakePremiumAndTrial(fakeIsPremium: true, fakeIsTrial: true),
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberInPillSheet: pillNumberInPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberInPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else if (pillNumberInPillSheet < pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(), reason: "pillNumberInPillSheet: $pillNumberInPillSheet");
          }
        }
      });
    });
  });
  group("#RecordPagePillSheet.displayPillTakeDate", () {
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
          id: firestoreIDGenerator(), typeInfo: PillSheetType.pillsheet_21_0.typeInfo, beginingDate: DateTime.parse("2020-09-01"), createdAt: now());

      expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2020-09-01"));
      expect(pillSheet.displayPillTakeDate(2), DateTime.parse("2020-09-02"));
      expect(pillSheet.displayPillTakeDate(3), DateTime.parse("2020-09-03"));

      expect(pillSheet.displayPillTakeDate(10), DateTime.parse("2020-09-10"));
      expect(pillSheet.displayPillTakeDate(11), DateTime.parse("2020-09-11"));
      expect(pillSheet.displayPillTakeDate(12), DateTime.parse("2020-09-12"));

      expect(pillSheet.displayPillTakeDate(26), DateTime.parse("2020-09-26"));
      expect(pillSheet.displayPillTakeDate(27), DateTime.parse("2020-09-27"));
      expect(pillSheet.displayPillTakeDate(28), DateTime.parse("2020-09-28"));
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
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
              ),
            ],
          );

          expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2020-09-01"));
          expect(pillSheet.displayPillTakeDate(2), DateTime.parse("2020-09-02"));
          expect(pillSheet.displayPillTakeDate(3), DateTime.parse("2020-09-03"));

          expect(pillSheet.displayPillTakeDate(10), DateTime.parse("2020-09-10"));
          expect(pillSheet.displayPillTakeDate(11), DateTime.parse("2020-09-11"));
          expect(pillSheet.displayPillTakeDate(12), DateTime.parse("2020-09-12"));

          expect(pillSheet.displayPillTakeDate(26), DateTime.parse("2020-09-26"));
          expect(pillSheet.displayPillTakeDate(27), DateTime.parse("2020-09-27"));
          expect(pillSheet.displayPillTakeDate(28), DateTime.parse("2020-09-28"));
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
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
              ),
            ],
          );

          expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2020-09-01"));
          expect(pillSheet.displayPillTakeDate(2), DateTime.parse("2020-09-02"));
          expect(pillSheet.displayPillTakeDate(3), DateTime.parse("2020-09-03"));

          expect(pillSheet.displayPillTakeDate(10), DateTime.parse("2020-09-10"));
          expect(pillSheet.displayPillTakeDate(11), DateTime.parse("2020-09-12"));
          expect(pillSheet.displayPillTakeDate(12), DateTime.parse("2020-09-13"));

          expect(pillSheet.displayPillTakeDate(26), DateTime.parse("2020-09-27"));
          expect(pillSheet.displayPillTakeDate(27), DateTime.parse("2020-09-28"));
          expect(pillSheet.displayPillTakeDate(28), DateTime.parse("2020-09-29"));
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
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
                endDate: DateTime.parse("2020-09-11"),
              ),
            ],
          );

          expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2020-09-01"));
          expect(pillSheet.displayPillTakeDate(2), DateTime.parse("2020-09-02"));
          expect(pillSheet.displayPillTakeDate(3), DateTime.parse("2020-09-03"));

          expect(pillSheet.displayPillTakeDate(10), DateTime.parse("2020-09-10"));
          expect(pillSheet.displayPillTakeDate(11), DateTime.parse("2020-09-11"));
          expect(pillSheet.displayPillTakeDate(12), DateTime.parse("2020-09-12"));

          expect(pillSheet.displayPillTakeDate(26), DateTime.parse("2020-09-26"));
          expect(pillSheet.displayPillTakeDate(27), DateTime.parse("2020-09-27"));
          expect(pillSheet.displayPillTakeDate(28), DateTime.parse("2020-09-28"));
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
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
                endDate: DateTime.parse("2020-09-12"),
              ),
            ],
          );

          expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2020-09-01"));
          expect(pillSheet.displayPillTakeDate(2), DateTime.parse("2020-09-02"));
          expect(pillSheet.displayPillTakeDate(3), DateTime.parse("2020-09-03"));

          expect(pillSheet.displayPillTakeDate(10), DateTime.parse("2020-09-10"));
          expect(pillSheet.displayPillTakeDate(11), DateTime.parse("2020-09-12"));
          expect(pillSheet.displayPillTakeDate(12), DateTime.parse("2020-09-13"));

          expect(pillSheet.displayPillTakeDate(13), DateTime.parse("2020-09-14"));
          expect(pillSheet.displayPillTakeDate(14), DateTime.parse("2020-09-15"));

          expect(pillSheet.displayPillTakeDate(26), DateTime.parse("2020-09-27"));
          expect(pillSheet.displayPillTakeDate(27), DateTime.parse("2020-09-28"));
          expect(pillSheet.displayPillTakeDate(28), DateTime.parse("2020-09-29"));
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

          expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2021-12-17"));
          expect(pillSheet.displayPillTakeDate(24), DateTime.parse("2022-01-09"));

          // Bug: Got 2022-01-18
          expect(pillSheet.displayPillTakeDate(25), DateTime.parse("2022-01-14"));

          expect(pillSheet.displayPillTakeDate(26), DateTime.parse("2022-01-15"));
          expect(pillSheet.displayPillTakeDate(28), DateTime.parse("2022-01-17"));
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
        createdAt: now(),
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

      expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2023-01-10"));

      expect(pillSheet.displayPillTakeDate(7), DateTime.parse("2023-01-16"));
      expect(pillSheet.displayPillTakeDate(8), DateTime.parse("2023-01-24"));

      expect(pillSheet.displayPillTakeDate(15), DateTime.parse("2023-01-31"));
      expect(pillSheet.displayPillTakeDate(16), DateTime.parse("2023-02-01"));
      expect(pillSheet.displayPillTakeDate(17), DateTime.parse("2023-02-08"));

      expect(pillSheet.displayPillTakeDate(19), DateTime.parse("2023-02-10"));
      expect(pillSheet.displayPillTakeDate(20), DateTime.parse("2023-02-11"));
    });
  });
}
