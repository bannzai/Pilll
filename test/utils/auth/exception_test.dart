import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/utils/auth/exception.dart';

void main() {
  group('#mapFromFirebaseAuthException', () {
    for (final accountType in LinkAccountType.values) {
      test(
        'credential-already-in-use の時、$accountType のアカウント名・原因・記録を引き継ぐ手順・退会の注意・詳細を含む AlertError を投げる',
        () {
          expect(
            () => mapFromFirebaseAuthException(
              FirebaseAuthException(
                code: 'credential-already-in-use',
                message: 'firebase detail message',
              ),
              accountType,
            ),
            throwsA(
              isA<AlertError>()
                  .having(
                    (error) => error.faqLinkURL,
                    'faqLinkURL',
                    'https://pilll.notion.site/a8d3c745e58c40f0b8b771bb70f7a7d1',
                  )
                  .having(
                    (error) => error.displayedMessage,
                    'displayedMessage',
                    allOf([
                      startsWith('この${accountType.providerName}アカウントは'),
                      // 原因
                      contains('別の端末での操作やログインで作られた別のPilllのアカウントに紐付いている'),
                      // 退会するのは記録の無い方の端末
                      contains('1. 記録の無い方の端末で「設定」→「アカウント設定」→「退会する」を行う'),
                      contains('2. この端末でもう一度アカウント登録をする'),
                      contains(
                        '3. 記録の無い方の端末でアプリを再起動し「すでにアカウントをお持ちの方はこちら」からログインする',
                      ),
                      contains('記録のある端末では退会しないでください'),
                      contains('残したい記録が別の端末にある場合は、退会せずにFAQをご覧ください'),
                      endsWith('詳細: firebase detail message'),
                    ]),
                  ),
            ),
          );
        },
      );
    }

    test('credential-already-in-use で message が null の時、詳細が空の AlertError を投げる',
        () {
      expect(
        () => mapFromFirebaseAuthException(
          FirebaseAuthException(code: 'credential-already-in-use'),
          LinkAccountType.apple,
        ),
        throwsA(
          isA<AlertError>().having(
            (error) => error.displayedMessage,
            'displayedMessage',
            endsWith('詳細: '),
          ),
        ),
      );
    });

    test('対応していない code の時、例外を投げずに null を返す', () {
      expect(
        mapFromFirebaseAuthException(
          FirebaseAuthException(code: 'network-request-failed'),
          LinkAccountType.google,
        ),
        isNull,
      );
    });
  });
}
