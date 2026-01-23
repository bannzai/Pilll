import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  group('#shouldSkipQuickRecord', () {
    group('PillSheetV1 (1錠飲み)', () {
      test('今日のピルを飲んでいない場合はfalse', () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2024-01-15'));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet.v1(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse('2024-01-10'),
          lastTakenDate: DateTime.parse('2024-01-14'),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        expect(shouldSkipQuickRecord(pillSheet), false);
      });

      test('今日のピルを飲んでいる場合はtrue', () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2024-01-15'));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet.v1(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse('2024-01-10'),
          lastTakenDate: DateTime.parse('2024-01-15'),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        expect(shouldSkipQuickRecord(pillSheet), true);
      });
    });

    group('PillSheetV2 (2錠飲み)', () {
      test('今日のピルを1錠も飲んでいない場合はfalse', () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2024-01-15'));

        const sheetType = PillSheetType.pillsheet_28_7;
        final pillSheet = PillSheet.v2(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse('2024-01-10'),
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          pills: List.generate(sheetType.totalCount, (index) {
            return Pill(
              takenCount: 2,
              index: index,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        ) as PillSheetV2;

        expect(shouldSkipQuickRecord(pillSheet), false);
      });

      test('今日のピルを1錠だけ飲んでいる場合はfalse（バグ修正のコアケース）', () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2024-01-15'));

        const sheetType = PillSheetType.pillsheet_28_7;
        // 今日は6番目のピル（index=5）
        final pillSheet = PillSheet.v2(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse('2024-01-10'),
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          pills: List.generate(sheetType.totalCount, (index) {
            if (index == 5) {
              // 今日のピル（1錠目だけ服用）
              return Pill(
                takenCount: 2,
                index: index,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse('2024-01-15'),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            } else if (index < 5) {
              // 過去のピル（2錠とも服用完了）
              return Pill(
                takenCount: 2,
                index: index,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime:
                        DateTime.parse('2024-01-10').add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime:
                        DateTime.parse('2024-01-10').add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              takenCount: 2,
              index: index,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        ) as PillSheetV2;

        // 1錠目服用後は2錠目を飲めるべき（falseを返す）
        expect(shouldSkipQuickRecord(pillSheet), false);
      });

      test('今日のピルを2錠とも飲んでいる場合はtrue', () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2024-01-15'));

        const sheetType = PillSheetType.pillsheet_28_7;
        // 今日は6番目のピル（index=5）
        final pillSheet = PillSheet.v2(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse('2024-01-10'),
          createdAt: now(),
          groupIndex: 0,
          restDurations: [],
          pills: List.generate(sheetType.totalCount, (index) {
            if (index == 5) {
              // 今日のピル（2錠とも服用完了）
              return Pill(
                takenCount: 2,
                index: index,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse('2024-01-15'),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime: DateTime.parse('2024-01-15'),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            } else if (index < 5) {
              // 過去のピル（2錠とも服用完了）
              return Pill(
                takenCount: 2,
                index: index,
                createdDateTime: now(),
                updatedDateTime: now(),
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime:
                        DateTime.parse('2024-01-10').add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                  PillTaken(
                    recordedTakenDateTime:
                        DateTime.parse('2024-01-10').add(Duration(days: index)),
                    createdDateTime: now(),
                    updatedDateTime: now(),
                  ),
                ],
              );
            }
            return Pill(
              takenCount: 2,
              index: index,
              createdDateTime: now(),
              updatedDateTime: now(),
              pillTakens: [],
            );
          }),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        ) as PillSheetV2;

        expect(shouldSkipQuickRecord(pillSheet), true);
      });
    });
  });
}
