import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/features/initial_setting/pill_sheet_group/page.dart';

void main() {
  group('#snackbarAccountTypeForLinkedUser', () {
    test('この画面でサインイン未完了かつ Apple link 済み (iOS Keychain による自動復元のみ) のとき、null を返す',
        () {
      expect(
        snackbarAccountTypeForLinkedUser(
          didSignInThisSession: false,
          isAppleLinked: true,
          isGoogleLinked: false,
        ),
        null,
      );
    });

    test('この画面でサインイン未完了かつ Google link 済み (iOS Keychain による自動復元のみ) のとき、null を返す',
        () {
      expect(
        snackbarAccountTypeForLinkedUser(
          didSignInThisSession: false,
          isAppleLinked: false,
          isGoogleLinked: true,
        ),
        null,
      );
    });

    test('この画面でサインイン未完了かつ両方 link されているとき、null を返す', () {
      expect(
        snackbarAccountTypeForLinkedUser(
          didSignInThisSession: false,
          isAppleLinked: true,
          isGoogleLinked: true,
        ),
        null,
      );
    });

    test('この画面でサインイン完了かつ Apple link 済みのとき、apple を返す', () {
      expect(
        snackbarAccountTypeForLinkedUser(
          didSignInThisSession: true,
          isAppleLinked: true,
          isGoogleLinked: false,
        ),
        LinkAccountType.apple,
      );
    });

    test('この画面でサインイン完了かつ Google link 済みのとき、google を返す', () {
      expect(
        snackbarAccountTypeForLinkedUser(
          didSignInThisSession: true,
          isAppleLinked: false,
          isGoogleLinked: true,
        ),
        LinkAccountType.google,
      );
    });

    test('この画面でサインイン完了かつ両方 link されているとき、apple を優先して返す', () {
      expect(
        snackbarAccountTypeForLinkedUser(
          didSignInThisSession: true,
          isAppleLinked: true,
          isGoogleLinked: true,
        ),
        LinkAccountType.apple,
      );
    });

    test('この画面でサインイン完了でも両方 link されていないとき、null を返す', () {
      expect(
        snackbarAccountTypeForLinkedUser(
          didSignInThisSession: true,
          isAppleLinked: false,
          isGoogleLinked: false,
        ),
        null,
      );
    });
  });
}
