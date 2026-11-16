import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/native/pill.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/fake.dart';

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

  group('#recordPillFromAppIntent', () {
    // 今日 (2024-01-15) は 2024-01-10 に始めたシートの 6 番目
    final mockNow = DateTime.parse('2024-01-15T09:00:00');
    final beginDate = DateTime.parse('2024-01-10');
    final typeInfo = PillSheetTypeInfo(
      dosingPeriod: PillSheetType.pillsheet_28_7.dosingPeriod,
      name: PillSheetType.pillsheet_28_7.fullName,
      totalCount: PillSheetType.pillsheet_28_7.totalCount,
      pillSheetTypeReferencePath: PillSheetType.pillsheet_28_7.rawPath,
    );
    // quick record がバッジを消す時に呼ぶ plugin の MethodChannel
    const appBadgePlusChannel = MethodChannel('app_badge_plus');

    setUp(() {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockNow);
      analytics = FakeAnalytics();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(appBadgePlusChannel, (call) async => null);
    });
    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(appBadgePlusChannel, null);
    });

    PillSheetGroup v1PillSheetGroup({required DateTime? lastTakenDate}) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: ['pill_sheet_id'],
        pillSheets: [
          PillSheet.v1(
            id: 'pill_sheet_id',
            beginDate: beginDate,
            lastTakenDate: lastTakenDate,
            createdAt: mockNow,
            typeInfo: typeInfo,
          ),
        ],
        createdAt: mockNow,
      );
    }

    // 1 日 2 回服用するシート。昨日までの分は 2 回とも記録済みで、今日の分は todayTakenCount 回だけ記録済み
    PillSheetGroup v2PillSheetGroup({required int todayTakenCount}) {
      return PillSheetGroup(
        id: 'group_id',
        pillSheetIDs: ['pill_sheet_id'],
        pillSheets: [
          PillSheet.v2(
            id: 'pill_sheet_id',
            beginDate: beginDate,
            createdAt: mockNow,
            groupIndex: 0,
            restDurations: [],
            typeInfo: typeInfo,
            pills: List.generate(typeInfo.totalCount, (index) {
              return Pill(
                takenCount: 2,
                index: index,
                createdDateTime: mockNow,
                updatedDateTime: mockNow,
                pillTakens: List.generate(
                  index < 5
                      ? 2
                      : index == 5
                          ? todayTakenCount
                          : 0,
                  (_) => PillTaken(
                    recordedTakenDateTime: beginDate.add(Duration(days: index)),
                    createdDateTime: mockNow,
                    updatedDateTime: mockNow,
                  ),
                ),
              );
            }),
          ),
        ],
        createdAt: mockNow,
      );
    }

    // Firestore へ書き込む batch だけを Mock にした実物の TakePill。書き込みの有無は batch.commit で確かめる
    (TakePill, MockWriteBatch) takePillWithMockBatch() {
      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(any, any)).thenAnswer(
        (invocation) => invocation.positionalArguments[1] as PillSheetGroup,
      );
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(any, any)).thenReturn(null);
      return (
        TakePill(
          batchFactory: batchFactory,
          batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
        ),
        batch,
      );
    }

    group('プレミアムとトライアルの判定', () {
      test('プレミアムでもトライアル中でもない場合は記録せず notPremiumOrTrial を返す', () async {
        final (takePill, batch) = takePillWithMockBatch();
        final pillSheetGroup = v1PillSheetGroup(
          lastTakenDate: DateTime.parse('2024-01-14'),
        );

        final (result, resultPillSheetGroup) = await recordPillFromAppIntent(
          user: const User(isPremium: false, trialDeadlineDate: null),
          pillSheetGroup: pillSheetGroup,
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.notPremiumOrTrial);
        expect(resultPillSheetGroup, pillSheetGroup);
        verifyNever(batch.commit());
      });

      test('トライアルの期限ちょうどの時刻は、トライアル中ではないので記録しない', () async {
        final (takePill, batch) = takePillWithMockBatch();

        final (result, _) = await recordPillFromAppIntent(
          user: User(isPremium: false, trialDeadlineDate: mockNow),
          pillSheetGroup: v1PillSheetGroup(
            lastTakenDate: DateTime.parse('2024-01-14'),
          ),
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.notPremiumOrTrial);
        verifyNever(batch.commit());
      });

      test('トライアルの期限の 1 秒前は、トライアル中なので記録する', () async {
        final (takePill, batch) = takePillWithMockBatch();

        final (result, resultPillSheetGroup) = await recordPillFromAppIntent(
          user: User(
            isPremium: false,
            trialDeadlineDate: mockNow.add(const Duration(seconds: 1)),
          ),
          pillSheetGroup: v1PillSheetGroup(
            lastTakenDate: DateTime.parse('2024-01-14'),
          ),
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.recorded);
        expect(resultPillSheetGroup?.activePillSheet?.lastTakenDate, mockNow);
        verify(batch.commit()).called(1);
      });

      test('トライアルの期限を過ぎていてもプレミアムなら記録する', () async {
        final (takePill, batch) = takePillWithMockBatch();

        final (result, _) = await recordPillFromAppIntent(
          user: User(
            isPremium: true,
            trialDeadlineDate: mockNow.subtract(const Duration(days: 1)),
          ),
          pillSheetGroup: v1PillSheetGroup(
            lastTakenDate: DateTime.parse('2024-01-14'),
          ),
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.recorded);
        verify(batch.commit()).called(1);
      });
    });

    group('v1', () {
      test('今日の分が未服用の場合は、今の時刻を最後の服用日時にして recorded を返す', () async {
        final (takePill, batch) = takePillWithMockBatch();

        final (result, resultPillSheetGroup) = await recordPillFromAppIntent(
          user: const User(isPremium: true),
          pillSheetGroup: v1PillSheetGroup(
            lastTakenDate: DateTime.parse('2024-01-14'),
          ),
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.recorded);
        expect(resultPillSheetGroup?.activePillSheet?.lastTakenDate, mockNow);
        verify(batch.commit()).called(1);
      });

      test('まだ 1 度も服用していないシートでも記録する', () async {
        final (takePill, batch) = takePillWithMockBatch();

        final (result, resultPillSheetGroup) = await recordPillFromAppIntent(
          user: const User(isPremium: true),
          pillSheetGroup: v1PillSheetGroup(lastTakenDate: null),
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.recorded);
        expect(resultPillSheetGroup?.activePillSheet?.lastTakenDate, mockNow);
        verify(batch.commit()).called(1);
      });

      test('今日の分が服用済みの場合は記録せず alreadyTaken を返す', () async {
        final (takePill, batch) = takePillWithMockBatch();
        final pillSheetGroup = v1PillSheetGroup(
          lastTakenDate: DateTime.parse('2024-01-15'),
        );

        final (result, resultPillSheetGroup) = await recordPillFromAppIntent(
          user: const User(isPremium: true),
          pillSheetGroup: pillSheetGroup,
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.alreadyTaken);
        expect(resultPillSheetGroup, pillSheetGroup);
        verifyNever(batch.commit());
      });
    });

    group('v2', () {
      test('今日の分を 1 回も記録していない場合は 1 回分だけ記録し、今日の分は服用済みにならない', () async {
        final (takePill, batch) = takePillWithMockBatch();

        final (result, resultPillSheetGroup) = await recordPillFromAppIntent(
          user: const User(isPremium: true),
          pillSheetGroup: v2PillSheetGroup(todayTakenCount: 0),
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.recorded);
        final resultPillSheet =
            resultPillSheetGroup?.activePillSheet as PillSheetV2;
        expect(resultPillSheet.pills[5].pillTakens.length, 1);
        expect(resultPillSheet.todayPillAllTaken, false);
        verify(batch.commit()).called(1);
      });

      test('今日の分を 1 回だけ記録している場合は残りの 1 回を記録し、今日の分が服用済みになる', () async {
        final (takePill, batch) = takePillWithMockBatch();

        final (result, resultPillSheetGroup) = await recordPillFromAppIntent(
          user: const User(isPremium: true),
          pillSheetGroup: v2PillSheetGroup(todayTakenCount: 1),
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.recorded);
        final resultPillSheet =
            resultPillSheetGroup?.activePillSheet as PillSheetV2;
        expect(resultPillSheet.pills[5].pillTakens.length, 2);
        expect(resultPillSheet.todayPillAllTaken, true);
        verify(batch.commit()).called(1);
      });

      test('今日の分を 2 回とも記録している場合は記録せず alreadyTaken を返す', () async {
        final (takePill, batch) = takePillWithMockBatch();

        final (result, _) = await recordPillFromAppIntent(
          user: const User(isPremium: true),
          pillSheetGroup: v2PillSheetGroup(todayTakenCount: 2),
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.alreadyTaken);
        verifyNever(batch.commit());
      });
    });

    group('記録する先のピルシートが無い', () {
      test('ピルシートグループが無い場合は noActivePillSheet を返す', () async {
        final (takePill, batch) = takePillWithMockBatch();

        final (result, resultPillSheetGroup) = await recordPillFromAppIntent(
          user: const User(isPremium: true),
          pillSheetGroup: null,
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.noActivePillSheet);
        expect(resultPillSheetGroup, null);
        verifyNever(batch.commit());
      });

      test('シートの最終日 (28 番目) の翌日は有効なピルシートが無いので noActivePillSheet を返す', () async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2024-02-07T09:00:00'));
        final (takePill, batch) = takePillWithMockBatch();

        final (result, _) = await recordPillFromAppIntent(
          user: const User(isPremium: true),
          pillSheetGroup: v1PillSheetGroup(
            lastTakenDate: DateTime.parse('2024-02-06'),
          ),
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.noActivePillSheet);
        verifyNever(batch.commit());
      });

      test('シートの最終日 (28 番目) で未服用の場合は記録する', () async {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now())
            .thenReturn(DateTime.parse('2024-02-06T09:00:00'));
        final (takePill, batch) = takePillWithMockBatch();

        final (result, _) = await recordPillFromAppIntent(
          user: const User(isPremium: true),
          pillSheetGroup: v1PillSheetGroup(
            lastTakenDate: DateTime.parse('2024-02-05'),
          ),
          takePill: takePill,
        );

        expect(result, AppIntentRecordPillResult.recorded);
        verify(batch.commit()).called(1);
      });
    });

    test('TakePill が記録せずに null を返した場合は failed と受け取った PillSheetGroup を返す',
        () async {
      final takePill = MockTakePill();
      final pillSheetGroup = v1PillSheetGroup(
        lastTakenDate: DateTime.parse('2024-01-14'),
      );
      when(
        takePill(
          takenDate: mockNow,
          pillSheetGroup: pillSheetGroup,
          activePillSheet: pillSheetGroup.pillSheets.single,
          isQuickRecord: true,
        ),
      ).thenAnswer((_) async => null);

      final (result, resultPillSheetGroup) = await recordPillFromAppIntent(
        user: const User(isPremium: true),
        pillSheetGroup: pillSheetGroup,
        takePill: takePill,
      );

      expect(result, AppIntentRecordPillResult.failed);
      expect(resultPillSheetGroup, pillSheetGroup);
    });
  });
}
