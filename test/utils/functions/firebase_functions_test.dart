import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/utils/functions/firebase_functions.dart';

void main() {
  group('#mapToJSON', () {
    test('フラットなMapを変換できる', () {
      final input = <dynamic, dynamic>{
        'name': 'test',
        'age': 25,
        'active': true,
      };

      final result = mapToJSON(input);

      expect(result, isA<Map<String, dynamic>>());
      expect(result['name'], 'test');
      expect(result['age'], 25);
      expect(result['active'], true);
    });

    test('ネストしたMapを再帰的に変換できる', () {
      final input = <dynamic, dynamic>{
        'user': <dynamic, dynamic>{
          'name': 'test',
          'profile': <dynamic, dynamic>{'bio': 'hello'},
        },
      };

      final result = mapToJSON(input);

      expect(result, isA<Map<String, dynamic>>());
      expect(result['user'], isA<Map<String, dynamic>>());
      expect(result['user']['profile'], isA<Map<String, dynamic>>());
      expect(result['user']['profile']['bio'], 'hello');
    });

    test('List内のMapも変換できる', () {
      final input = <dynamic, dynamic>{
        'items': [
          <dynamic, dynamic>{'id': 1, 'name': 'item1'},
          <dynamic, dynamic>{'id': 2, 'name': 'item2'},
        ],
      };

      final result = mapToJSON(input);

      expect(result['items'], isA<List>());
      expect(result['items'][0], isA<Map<String, dynamic>>());
      expect(result['items'][0]['id'], 1);
      expect(result['items'][1]['name'], 'item2');
    });

    test('List内のプリミティブ値はそのまま保持される', () {
      final input = <dynamic, dynamic>{
        'numbers': [1, 2, 3],
        'strings': ['a', 'b', 'c'],
      };

      final result = mapToJSON(input);

      expect(result['numbers'], [1, 2, 3]);
      expect(result['strings'], ['a', 'b', 'c']);
    });

    test('元のMapを変更しない（純粋関数）', () {
      final input = <dynamic, dynamic>{
        'nested': <dynamic, dynamic>{'value': 'original'},
      };
      final originalNested = input['nested'];

      mapToJSON(input);

      // 元のMapが変更されていないことを確認
      expect(input['nested'], same(originalNested));
    });

    test('空のMapを処理できる', () {
      final input = <dynamic, dynamic>{};

      final result = mapToJSON(input);

      expect(result, isA<Map<String, dynamic>>());
      expect(result.isEmpty, true);
    });

    test('null値を含むMapを処理できる', () {
      final input = <dynamic, dynamic>{'name': 'test', 'value': null};

      final result = mapToJSON(input);

      expect(result['name'], 'test');
      expect(result['value'], null);
    });

    test('数値キーを文字列に変換する', () {
      final input = <dynamic, dynamic>{1: 'one', 2: 'two'};

      final result = mapToJSON(input);

      expect(result['1'], 'one');
      expect(result['2'], 'two');
    });
  });
}
