import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_components.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_social_proof_screen.dart';

void main() {
  group("#socialProofUserCountText", () {
    // テストを実行するマシンの言語 (Platform.localeName) に依らず、撮影する言語の書式になることを確かめる
    test("lang が ja の時は日本語の短縮表記になる", () {
      expect(socialProofUserCountText(lang: 'ja'), '14万');
    });

    test("lang が en の時は英語の短縮表記になる", () {
      expect(socialProofUserCountText(lang: 'en'), '140K');
    });

    // CLDR の de の短縮表記は千の位に略語を持たない (パターンが "0") ため、略さず桁区切りも無い数になる
    test("lang が de の時はドイツ語の書式になる", () {
      expect(socialProofUserCountText(lang: 'de'), '140000');
    });
  });

  group("NotificationBanner", () {
    // 通知バナーは記録画面の生理案内バー (紺地に白文字) に重なるため、背景が透けると白文字が通知本文に重なって見える (Issue #2076)
    // 記録画面ごと描画するとテスト用フォント (Ahem) の字幅でピルシートが溢れるため、MockSocialProofScreen の build が組む子の設定だけを確かめる
    testWidgets("記録画面に重ねる通知バナーの背景は不透明で、下の生理案内バーの文字を透かさない", (tester) async {
      late Widget socialProofScreenTree;
      await tester.pumpWidget(Builder(builder: (context) {
        socialProofScreenTree =
            const MockSocialProofScreen(lang: 'ja').build(context);
        return const SizedBox();
      }));

      final notificationBanner = (socialProofScreenTree as Stack)
          .children
          .whereType<Positioned>()
          .map((positioned) => positioned.child)
          .whereType<NotificationBanner>()
          .single;
      expect(notificationBanner.opacity, 1.0);
    });
  });
}
