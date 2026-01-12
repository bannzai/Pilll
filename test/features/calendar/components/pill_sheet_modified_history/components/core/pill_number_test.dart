import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';

void main() {
  group('#taken', () {
    group('PillSheetAppearanceMode.number（番号表示）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.number;

      group('v1（1錠飲み）のケース', () {
        test('初回服用（beforeがnull）の場合、「1番」を返す', () {
          final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
            beforeLastTakenPillNumber: null,
            afterLastTakenPillNumber: 1,
            pillSheetAppearanceMode: pillSheetAppearanceMode,
          );
          expect(result, '1番');
        });

        test('1錠分の服用（before=12, after=13）の場合、「13番」を返す', () {
          final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
            beforeLastTakenPillNumber: 12,
            afterLastTakenPillNumber: 13,
            pillSheetAppearanceMode: pillSheetAppearanceMode,
          );
          expect(result, '13番');
        });

        test('複数錠のまとめ飲み（before=10, after=15）の場合、「11-15番」を返す', () {
          final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
            beforeLastTakenPillNumber: 10,
            afterLastTakenPillNumber: 15,
            pillSheetAppearanceMode: pillSheetAppearanceMode,
          );
          expect(result, '11-15番');
        });

        test('ピルシート境界（beforeがnull、after=5）の場合、「1-5番」を返す', () {
          // 1つ前のピルシートの最後の番号の時はnullになる
          final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
            beforeLastTakenPillNumber: null,
            afterLastTakenPillNumber: 5,
            pillSheetAppearanceMode: pillSheetAppearanceMode,
          );
          expect(result, '1-5番');
        });
      });

      group('境界値テスト', () {
        test('before=0, after=1の場合、「1番」を返す', () {
          final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
            beforeLastTakenPillNumber: 0,
            afterLastTakenPillNumber: 1,
            pillSheetAppearanceMode: pillSheetAppearanceMode,
          );
          expect(result, '1番');
        });

        test('before=20, after=21の場合（21錠タイプの最後）、「21番」を返す', () {
          final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
            beforeLastTakenPillNumber: 20,
            afterLastTakenPillNumber: 21,
            pillSheetAppearanceMode: pillSheetAppearanceMode,
          );
          expect(result, '21番');
        });

        test('before=27, after=28の場合（28錠タイプの最後）、「28番」を返す', () {
          final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
            beforeLastTakenPillNumber: 27,
            afterLastTakenPillNumber: 28,
            pillSheetAppearanceMode: pillSheetAppearanceMode,
          );
          expect(result, '28番');
        });
      });
    });

    group('PillSheetAppearanceMode.sequential（連番表示・日目表記）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.sequential;

      test('1錠分の服用（before=12, after=13）の場合、「13日目」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
          beforeLastTakenPillNumber: 12,
          afterLastTakenPillNumber: 13,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '13日目');
      });

      test('複数錠のまとめ飲み（before=10, after=15）の場合、「11-15日目」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
          beforeLastTakenPillNumber: 10,
          afterLastTakenPillNumber: 15,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '11-15日目');
      });
    });

    group('PillSheetAppearanceMode.cyclicSequential（周期的連番表示・日目表記）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.cyclicSequential;

      test('1錠分の服用（before=12, after=13）の場合、「13日目」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
          beforeLastTakenPillNumber: 12,
          afterLastTakenPillNumber: 13,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '13日目');
      });
    });

    group('PillSheetAppearanceMode.date（日付表示・番表記）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.date;

      test('1錠分の服用（before=12, after=13）の場合、「13番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.taken(
          beforeLastTakenPillNumber: 12,
          afterLastTakenPillNumber: 13,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '13番');
      });
    });
  });

  group('#autoTaken', () {
    group('PillSheetAppearanceMode.number（番号表示）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.number;

      test('1錠分の自動服用（before=12, after=13）の場合、「13番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.autoTaken(
          beforeLastTakenPillNumber: 12,
          afterLastTakenPillNumber: 13,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '13番');
      });

      test('複数錠の自動服用（before=10, after=15）の場合、「11-15番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.autoTaken(
          beforeLastTakenPillNumber: 10,
          afterLastTakenPillNumber: 15,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '11-15番');
      });
    });
  });

  group('#revert', () {
    group('PillSheetAppearanceMode.number（番号表示）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.number;

      test('afterがnullの場合（全ての服用を取り消し）、「before番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.revert(
          beforeLastTakenPillNumber: 5,
          afterLastTakenPillNumber: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '5番');
      });

      test('1錠分のrevert（before=13, after=12）の場合、「13番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.revert(
          beforeLastTakenPillNumber: 13,
          afterLastTakenPillNumber: 12,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '13番');
      });

      test('複数錠のrevert（before=15, after=10）の場合、「15-11番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.revert(
          beforeLastTakenPillNumber: 15,
          afterLastTakenPillNumber: 10,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '15-11番');
      });
    });
  });

  group('#takenV2', () {
    group('PillSheetAppearanceMode.number（番号表示）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.number;

      test('1回目の服用（before=12, after=13）の場合、「13番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.takenV2(
          beforeLastTakenPillNumber: 12,
          afterLastTakenPillNumber: 13,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '13番');
      });

      test('2回目の服用（before=13, after=13）の場合、「13番」を返す', () {
        // v2で同じピルを2回目服用した場合、before == after になる
        final result = PillSheetModifiedHistoryPillNumberOrDate.takenV2(
          beforeLastTakenPillNumber: 13,
          afterLastTakenPillNumber: 13,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '13番');
      });

      test('ピルシート最初のピルの2回目服用（before=1, after=1）の場合、「1番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.takenV2(
          beforeLastTakenPillNumber: 1,
          afterLastTakenPillNumber: 1,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '1番');
      });

      test('ピルシート最後のピルの2回目服用（before=28, after=28）の場合、「28番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.takenV2(
          beforeLastTakenPillNumber: 28,
          afterLastTakenPillNumber: 28,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '28番');
      });

      test('初回服用（beforeがnull）の場合、「1番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.takenV2(
          beforeLastTakenPillNumber: null,
          afterLastTakenPillNumber: 1,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '1番');
      });
    });

    group('PillSheetAppearanceMode.sequential（連番表示・日目表記）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.sequential;

      test('2回目の服用（before=13, after=13）の場合、「13日目」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.takenV2(
          beforeLastTakenPillNumber: 13,
          afterLastTakenPillNumber: 13,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '13日目');
      });
    });
  });

  group('#revertV2', () {
    group('PillSheetAppearanceMode.number（番号表示）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.number;

      test('afterがnullの場合（全ての服用を取り消し）、「before番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.revertV2(
          beforeLastTakenPillNumber: 5,
          afterLastTakenPillNumber: null,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '5番');
      });

      test('2回目服用の取り消し（before=13, after=13）の場合、「13番」を返す', () {
        // v2で同じピルの2回目服用を取り消した場合、before == after になる
        final result = PillSheetModifiedHistoryPillNumberOrDate.revertV2(
          beforeLastTakenPillNumber: 13,
          afterLastTakenPillNumber: 13,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '13番');
      });

      test('1錠分のrevert（before=13, after=12）の場合、「13番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.revertV2(
          beforeLastTakenPillNumber: 13,
          afterLastTakenPillNumber: 12,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '13番');
      });

      test('複数錠のrevert（before=15, after=10）の場合、「15-11番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.revertV2(
          beforeLastTakenPillNumber: 15,
          afterLastTakenPillNumber: 10,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '15-11番');
      });
    });
  });

  group('#hyphen', () {
    test('「-」を返す', () {
      final result = PillSheetModifiedHistoryPillNumberOrDate.hyphen();
      expect(result, '-');
    });
  });

  group('#changedPillNumber', () {
    group('PillSheetAppearanceMode.number（番号表示）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.number;

      test('ピル番号変更（before=5, after=10）の場合、「5→10番」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.changedPillNumber(
          beforeTodayPillNumber: 5,
          afterTodayPillNumber: 10,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '5→10番');
      });
    });

    group('PillSheetAppearanceMode.sequential（連番表示・日目表記）', () {
      const pillSheetAppearanceMode = PillSheetAppearanceMode.sequential;

      test('ピル番号変更（before=5, after=10）の場合、「5→10日目」を返す', () {
        final result = PillSheetModifiedHistoryPillNumberOrDate.changedPillNumber(
          beforeTodayPillNumber: 5,
          afterTodayPillNumber: 10,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        expect(result, '5→10日目');
      });
    });
  });

  group('#pillSheetCount', () {
    test('空のリストの場合、「-」を返す', () {
      final result = PillSheetModifiedHistoryPillNumberOrDate.pillSheetCount([]);
      expect(result, '-');
    });

    test('1枚のピルシートIDの場合、「1枚」を返す', () {
      final result = PillSheetModifiedHistoryPillNumberOrDate.pillSheetCount(['id1']);
      expect(result, '1枚');
    });

    test('3枚のピルシートIDの場合、「3枚」を返す', () {
      final result = PillSheetModifiedHistoryPillNumberOrDate.pillSheetCount(['id1', 'id2', 'id3']);
      expect(result, '3枚');
    });
  });
}
