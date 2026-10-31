import 'package:flutter_test/flutter_test.dart';
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
}
