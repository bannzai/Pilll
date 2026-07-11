import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/lifetime_offer/lifetime_offer_copy_variant.dart';

void main() {
  group('#fromString', () {
    test("'default' で defaultVariant を返す", () {
      expect(LifetimeOfferCopyVariant.fromString('default'),
          LifetimeOfferCopyVariant.defaultVariant);
    });

    test("'ownership' で ownership を返す", () {
      expect(LifetimeOfferCopyVariant.fromString('ownership'),
          LifetimeOfferCopyVariant.ownership);
    });

    test('未知の文字列は defaultVariant にフォールバックする', () {
      expect(LifetimeOfferCopyVariant.fromString('unknown'),
          LifetimeOfferCopyVariant.defaultVariant);
    });

    test('空文字は defaultVariant にフォールバックする', () {
      expect(LifetimeOfferCopyVariant.fromString(''),
          LifetimeOfferCopyVariant.defaultVariant);
    });
  });
}
