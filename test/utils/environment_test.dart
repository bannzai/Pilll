import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/utils/environment.dart';

void main() {
  group('#Environment.maintenanceStateURL', () {
    test('dart-define で差し替えていない時は、どの flavor でも本番の Pilll の状態の URL を返す', () {
      final originalFlavor = Environment.flavor;
      addTearDown(() => Environment.flavor = originalFlavor);
      for (final flavor in [...Flavor.values, null]) {
        Environment.flavor = flavor;
        expect(Environment.maintenanceStateURL,
            'https://service-maintenance.star-kojiki.workers.dev/pilll',
            reason: '$flavor');
      }
    });
  });
}
