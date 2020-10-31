import 'package:Pilll/model/diary.dart';
import 'package:Pilll/state/diaries.dart';
import 'package:Pilll/util/environment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUp(() {
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
  });
  group("#reduced", () {
    test("match only one elements", () {
      final subject = Diary.fromDate(DateTime(2020, 09, 14));
      List<Diary> entities = [
        subject,
        Diary.fromDate(DateTime(2020, 09, 15)),
      ];
      final state = DiariesState(entities: entities);
      expect(entities.length, equals(2));
      final result = state.reduced([Diary.fromDate(DateTime(2020, 09, 15))]);
      expect(result, equals([subject]));
      expect(result.length, equals(1));
    });
    test("for bugfix", () {
      List<Diary> entities = [
        Diary.fromDate(DateTime(2020, 10, 14)),
        Diary.fromDate(DateTime(2020, 10, 21)),
        Diary.fromDate(DateTime(2020, 10, 22)),
      ];
      final state = DiariesState(entities: entities);
      final result = state.reduced([Diary.fromDate(DateTime(2020, 10, 21))]);
      expect(
        result,
        equals([
          Diary.fromDate(DateTime(2020, 10, 14)),
          Diary.fromDate(DateTime(2020, 10, 22)),
        ]),
      );
    });
  });
  group("#merged", () {
    test("add elements to last", () {
      List<Diary> entities = [
        Diary.fromDate(DateTime(2020, 09, 14)),
        Diary.fromDate(DateTime(2020, 09, 15)),
      ];
      final state = DiariesState(entities: entities);
      final result = state.merged([Diary.fromDate(DateTime(2020, 09, 16))]);
      expect(
        result,
        equals(<Diary>[
          Diary.fromDate(DateTime(2020, 09, 14)),
          Diary.fromDate(DateTime(2020, 09, 15)),
          Diary.fromDate(DateTime(2020, 09, 16)),
        ]),
      );
    });
    test("insert element", () {
      List<Diary> entities = [
        Diary.fromDate(DateTime(2020, 09, 14)),
        Diary.fromDate(DateTime(2020, 09, 16)),
      ];
      final state = DiariesState(entities: entities);
      final result = state.merged([Diary.fromDate(DateTime(2020, 09, 15))]);
      expect(
        result,
        equals(<Diary>[
          Diary.fromDate(DateTime(2020, 09, 14)),
          Diary.fromDate(DateTime(2020, 09, 15)),
          Diary.fromDate(DateTime(2020, 09, 16)),
        ]),
      );
    });
    test("replaced elements", () {
      List<Diary> entities = [
        Diary.fromDate(DateTime(2020, 09, 14)),
        Diary.fromDate(DateTime(2020, 09, 15)),
      ];
      final state = DiariesState(entities: entities);
      final result = state.merged(
          [Diary.fromDate(DateTime(2020, 09, 15)).copyWith(hasSex: true)]);
      expect(
        result,
        equals(<Diary>[
          Diary.fromDate(DateTime(2020, 09, 14)),
          Diary.fromDate(DateTime(2020, 09, 15)).copyWith(hasSex: true),
        ]),
      );
    });
  });
}
