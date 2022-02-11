import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/util/version/version.dart';

void main() {
  group("#Version.parse", () {
    test("0.0.0", () {
      expect(Version.parse("0.0.0").version, "0.0.0");
    });
    test("1.0.0", () {
      expect(Version.parse("1.0.0").version, "1.0.0");
    });
  });
}
