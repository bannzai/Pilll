import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/features/special_offering/page2.dart';
import 'package:pilll/features/special_offering/special_offering_copy_variant.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/utils/environment.dart';

import '../../helper/fake.dart';

void main() {
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    TestWidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    for (var element in RendererBinding.instance.renderViews) {
      element.configuration = TestViewConfiguration.fromView(
        view: WidgetsBinding.instance.platformDispatcher.views.single,
        size: const Size(414.0, 896.0),
      );
    }
  });

  group('#SpecialOfferingPageBody', () {
    Future<void> pumpPage(
      WidgetTester tester, {
      required SpecialOfferingCopyVariant copyVariant,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            remoteConfigParameterProvider.overrideWithValue(
              RemoteConfigParameter(
                  specialOfferingCopyVariant: copyVariant.value),
            ),
            monthlyPremiumPackageProvider
                .overrideWith((ref) => FakeRevenueCatPackage()),
            monthlySpecialOfferingPackageProvider
                .overrideWith((ref) => FakeRevenueCatPackage()),
          ],
          child: MaterialApp(
            home: Material(
              child: SpecialOfferingPageBody(
                user: const User(
                  isPremium: false,
                  trialDeadlineDate: null,
                  beginTrialDate: null,
                  discountEntitlementDeadlineDate: null,
                ),
                specialOfferingIsClosed2: ValueNotifier(false),
                source: PaywallSource.specialOfferingBar2,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      debugDefaultTargetPlatformOverride = null;
    }

    testWidgets('defaultバリアントで現行の訴求コピーが表示される', (WidgetTester tester) async {
      await pumpPage(tester,
          copyVariant: SpecialOfferingCopyVariant.defaultVariant);

      expect(find.text('今回だけの特別価格でプレミアム機能をゲット！'), findsOneWidget);
      expect(find.text('このチャンスは今回限り。特別価格でプレミアム機能をゲット！'), findsNothing);
    });

    testWidgets('scarcityバリアントで希少性訴求のコピーが表示される', (WidgetTester tester) async {
      await pumpPage(tester, copyVariant: SpecialOfferingCopyVariant.scarcity);

      expect(find.text('このチャンスは今回限り。特別価格でプレミアム機能をゲット！'), findsOneWidget);
      expect(find.text('今回だけの特別価格でプレミアム機能をゲット！'), findsNothing);
    });
  });
}
