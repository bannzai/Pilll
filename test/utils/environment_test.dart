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

  group('#Environment.resolveMaintenanceStateURL', () {
    const productionURL =
        'https://service-maintenance.star-kojiki.workers.dev/pilll';
    const overriddenURL = 'https://example.com/maintenance/pilll.json';

    test('開発用の flavor で差し替えの URL がある時は、差し替えの URL を返す', () {
      expect(
          Environment.resolveMaintenanceStateURL(
              overriddenURL: overriddenURL, isDevelopment: true),
          overriddenURL);
    });

    test('本番の flavor で差し替えの URL がある時は、差し替えを使わず本番の URL を返す', () {
      expect(
          Environment.resolveMaintenanceStateURL(
              overriddenURL: overriddenURL, isDevelopment: false),
          productionURL);
    });

    test('開発用の flavor で差し替えの URL が空の時は、本番の URL を返す', () {
      expect(
          Environment.resolveMaintenanceStateURL(
              overriddenURL: '', isDevelopment: true),
          productionURL);
    });
  });
}
