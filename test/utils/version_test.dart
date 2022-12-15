import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/utils/version/version.dart';

void main() {
  group("#Version.parse", () {
    test("0.0.0", () {
      expect(Version.parse("0.0.0").version, "0.0.0");
    });
    test("1.0.0", () {
      expect(Version.parse("1.0.0").version, "1.0.0");
    });
  });

  group("#Version.isLessThan", () {
    test("lhs: 0.0.0, rhs: 1.0.0", () {
      expect(Version.parse("0.0.0").isLessThan(Version.parse("1.0.0")), true);
    });
    test("lhs: 0.0.1, rhs: 1.0.0", () {
      expect(Version.parse("0.0.1").isLessThan(Version.parse("1.0.0")), true);
    });
    test("lhs: 0.1.0, rhs: 1.0.0", () {
      expect(Version.parse("0.1.0").isLessThan(Version.parse("1.0.0")), true);
    });
    test("lhs: 1.0.0, rhs: 1.0.0", () {
      expect(Version.parse("1.0.0").isLessThan(Version.parse("1.0.0")), false);
    });
    test("lhs: 1.0.1, rhs: 1.0.0", () {
      expect(Version.parse("1.0.1").isLessThan(Version.parse("1.0.0")), false);
    });
    test("lhs: 1.1.0, rhs: 1.0.0", () {
      expect(Version.parse("1.1.0").isLessThan(Version.parse("1.0.0")), false);
    });
    test("lhs: 2.0.0, rhs: 1.0.0", () {
      expect(Version.parse("2.0.0").isLessThan(Version.parse("1.0.0")), false);
    });
  });
}
