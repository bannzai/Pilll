import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/special_offering/special_offering_copy_variant.dart';

void main() {
  group('#fromString', () {
    test("'default' で defaultVariant を返す", () {
      expect(SpecialOfferingCopyVariant.fromString('default'),
          SpecialOfferingCopyVariant.defaultVariant);
    });

    test("'scarcity' で scarcity を返す", () {
      expect(SpecialOfferingCopyVariant.fromString('scarcity'),
          SpecialOfferingCopyVariant.scarcity);
    });

    test('未知の文字列は defaultVariant にフォールバックする', () {
      expect(SpecialOfferingCopyVariant.fromString('unknown'),
          SpecialOfferingCopyVariant.defaultVariant);
    });

    test('空文字は defaultVariant にフォールバックする', () {
      expect(SpecialOfferingCopyVariant.fromString(''),
          SpecialOfferingCopyVariant.defaultVariant);
    });
  });
}
