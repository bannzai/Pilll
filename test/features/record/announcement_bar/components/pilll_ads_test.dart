import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pilll_ads.codegen.dart';
import 'package:pilll/features/record/components/announcement_bar/components/pilll_ads.dart';

PilllAds _pilllAds({
  required String? pilllAdID,
  required String destinationURL,
}) {
  return PilllAds(
    pilllAdID: pilllAdID,
    description: 'desc',
    destinationURL: destinationURL,
    endDateTime: DateTime(2026, 5, 31),
    startDateTime: DateTime(2026, 5, 1),
    hexColor: 'FF0000',
    imageURL: null,
  );
}

void main() {
  group('#pilllAdsLaunchURLForTest', () {
    test('pilllAdID が null の時、utm_campaign は pilll_ads になる', () {
      final uri = pilllAdsLaunchURLForTest(
        _pilllAds(pilllAdID: null, destinationURL: 'https://example.com/lp'),
      );

      expect(uri.queryParameters['utm_source'], 'pilll');
      expect(uri.queryParameters['utm_medium'], 'announcement_bar');
      expect(uri.queryParameters['utm_campaign'], 'pilll_ads');
    });

    test('pilllAdID が指定されている時、utm_campaign に値が入る', () {
      final uri = pilllAdsLaunchURLForTest(
        _pilllAds(
          pilllAdID: 'campaign_2026_05',
          destinationURL: 'https://example.com/lp',
        ),
      );

      expect(uri.queryParameters['utm_campaign'], 'campaign_2026_05');
      expect(uri.queryParameters['utm_source'], 'pilll');
      expect(uri.queryParameters['utm_medium'], 'announcement_bar');
    });

    test('destinationURL に既存の query があれば残り、UTM の重複キーは destinationURL を優先する',
        () {
      final uri = pilllAdsLaunchURLForTest(
        _pilllAds(
          pilllAdID: 'campaign_2026_05',
          destinationURL:
              'https://example.com/lp?ref=abc&utm_campaign=existing',
        ),
      );

      expect(uri.queryParameters['ref'], 'abc');
      expect(uri.queryParameters['utm_campaign'], 'existing');
      expect(uri.queryParameters['utm_source'], 'pilll');
      expect(uri.queryParameters['utm_medium'], 'announcement_bar');
    });
  });
}
