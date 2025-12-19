import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/utils/validator.dart';

void main() {
  group('#isValidEmail', () {
    group('有効なメールアドレス', () {
      test('基本形式: user@example.com', () {
        expect(isValidEmail('user@example.com'), isTrue);
      });

      test('エイリアス付き: user+alias@gmail.com', () {
        expect(isValidEmail('user+alias@gmail.com'), isTrue);
      });

      test('サブドメイン: user@mail.example.com', () {
        expect(isValidEmail('user@mail.example.com'), isTrue);
      });

      test('アンダースコア含む: user_name@example.com', () {
        expect(isValidEmail('user_name@example.com'), isTrue);
      });

      test('ドット含む: user.name@example.com', () {
        expect(isValidEmail('user.name@example.com'), isTrue);
      });

      test('ハイフン含む: user-name@example.com', () {
        expect(isValidEmail('user-name@example.com'), isTrue);
      });

      test('数字含む: user123@example.com', () {
        expect(isValidEmail('user123@example.com'), isTrue);
      });

      test('ドメインにハイフン含む: user@exam-ple.com', () {
        expect(isValidEmail('user@exam-ple.com'), isTrue);
      });

      test('複数のサブドメイン: user@mail.sub.example.com', () {
        expect(isValidEmail('user@mail.sub.example.com'), isTrue);
      });

      test('国別TLD: user@example.co.jp', () {
        expect(isValidEmail('user@example.co.jp'), isTrue);
      });

      test('複合パターン: user.name+alias@mail.example.co.jp', () {
        expect(isValidEmail('user.name+alias@mail.example.co.jp'), isTrue);
      });
    });

    group('無効なメールアドレス', () {
      test('空文字', () {
        expect(isValidEmail(''), isFalse);
      });

      test('@がない: userexample.com', () {
        expect(isValidEmail('userexample.com'), isFalse);
      });

      test('ドメインがない: user@', () {
        expect(isValidEmail('user@'), isFalse);
      });

      test('ユーザー名がない: @example.com', () {
        expect(isValidEmail('@example.com'), isFalse);
      });

      test('TLDがない: user@example', () {
        expect(isValidEmail('user@example'), isFalse);
      });

      test('@が複数: user@@example.com', () {
        expect(isValidEmail('user@@example.com'), isFalse);
      });

      test('スペース含む: user @example.com', () {
        expect(isValidEmail('user @example.com'), isFalse);
      });

      test('日本語含む: ユーザー@example.com', () {
        expect(isValidEmail('ユーザー@example.com'), isFalse);
      });
    });
  });
}
