import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/store_review/pre_store_review_modal.dart';
import 'package:pilll/utils/analytics.dart';

import '../../helper/fake.dart';

void main() {
  setUp(() {
    analytics = FakeAnalytics();
  });

  // ホームインジケータのある端末を再現する。SafeArea の下端インセットぶん、内容に使える高さが縮む
  const homeIndicatorInset = EdgeInsets.only(bottom: 34);

  Widget subject() {
    return ProviderScope(
      child: MaterialApp(
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(padding: homeIndicatorInset),
            child: const Material(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: PreStoreReviewModal(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('#PreStoreReviewModal', () {
    setUp(() {
      final view = TestWidgetsFlutterBinding.ensureInitialized()
          .platformDispatcher
          .views
          .first;
      view.physicalSize = const Size(1170, 2532);
      view.devicePixelRatio = 3.0;
      addTearDown(view.reset);
    });

    testWidgets('回答カード未選択の場合、「決定」ボタンを表示しない', (tester) async {
      await tester.pumpWidget(subject());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(PrimaryButton), findsNothing);
    });

    // NOTE: 選択状態は useState でコンポーネント内に閉じており外から与えられないため、
    // セットアップとしてカードをタップする。検証するのはタップの挙動ではなく選択後の表示状態
    testWidgets('回答カードを選択した場合、ホームインジケータのある端末でもオーバーフローせず「決定」ボタンが収まる',
        (tester) async {
      await tester.pumpWidget(subject());
      await tester.pumpAndSettle();

      await tester.tap(find.text(L.satisfied));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(
        tester.getRect(find.byType(PrimaryButton)).bottom,
        lessThanOrEqualTo(
            tester.getRect(find.byType(PreStoreReviewModal)).bottom -
                homeIndicatorInset.bottom),
      );
    });
  });
}
