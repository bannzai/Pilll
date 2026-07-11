import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/lifetime_offer/lifetime_offer_copy_variant.dart';
import 'package:pilll/features/lifetime_offer/lifetime_offer_plan.dart';
import 'package:pilll/features/lifetime_offer/provider.dart';
import 'package:pilll/features/record/components/announcement_bar/components/lifetime_offer.dart';
import 'package:pilll/utils/analytics.dart';

import '../../../../helper/fake.dart';

void main() {
  setUp(() {
    // viewed useEffect で analytics.setUserProperties/logEvent を呼ぶため、Firebase未初期化のテストではFakeに差し替える
    analytics = FakeAnalytics();
  });

  group('#LifetimeOfferAnnouncementBar', () {
    Future<void> pumpBar(
      WidgetTester tester, {
      required LifetimeOfferCopyVariant copyVariant,
      LifetimeOfferPlan offerPlan = LifetimeOfferPlan.lifetime,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // 残り時間>0でバー本体が描画される。tick/期限計算に依存しないよう固定値でoverrideする
            lifetimeOfferRemainingDurationProvider
                .overrideWith((ref) => const Duration(hours: 12)),
            // useEffect内の初回表示時刻セットを無効化するため周期をnullにする（cycle==nullで何もしない）
            lifetimeOfferCycleProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Material(
              child: LifetimeOfferAnnouncementBar(
                  copyVariant: copyVariant, offerPlan: offerPlan),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('defaultバリアントで現行の感謝文言が表示される', (WidgetTester tester) async {
      await pumpBar(tester,
          copyVariant: LifetimeOfferCopyVariant.defaultVariant);

      expect(find.textContaining('Pilllのご利用ありがとうございます！'), findsOneWidget);
      expect(find.textContaining('一度の購入でずっとプレミアム！'), findsNothing);
    });

    testWidgets('ownershipバリアントで所有価値訴求の文言が表示される', (WidgetTester tester) async {
      await pumpBar(tester, copyVariant: LifetimeOfferCopyVariant.ownership);

      expect(find.textContaining('一度の購入でずっとプレミアム！'), findsOneWidget);
      expect(find.textContaining('Pilllのご利用ありがとうございます！'), findsNothing);
    });

    testWidgets('月額300円プランで3年以上利用者向けの文言が表示される', (WidgetTester tester) async {
      await pumpBar(
        tester,
        copyVariant: LifetimeOfferCopyVariant.defaultVariant,
        offerPlan: LifetimeOfferPlan.monthly300,
      );

      expect(find.textContaining('長くご愛顧いただいている皆様へ！'), findsOneWidget);
    });
  });
}
