import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/appstore_screenshot/frame_layout.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_background.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_device.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('#ScreenshotDevice', () {
    // 寸法の出典: Apple「Screenshot specifications」
    // https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications
    test('iPhone 6.7" の出力寸法は 1290×2796', () {
      expect(ScreenshotDevice.iPhone67.outputWidth, 1290);
      expect(ScreenshotDevice.iPhone67.outputHeight, 2796);
    });

    test('iPhone Duo 外側の出力寸法は 1398×2034（縦）', () {
      expect(ScreenshotDevice.iPhoneDuoOuter.outputWidth, 1398);
      expect(ScreenshotDevice.iPhoneDuoOuter.outputHeight, 2034);
    });

    test('iPhone Duo 内側の出力寸法は 2853×2007（横）', () {
      expect(ScreenshotDevice.iPhoneDuoInner.outputWidth, 2853);
      expect(ScreenshotDevice.iPhoneDuoInner.outputHeight, 2007);
    });

    test('全デバイスで iPhone フレームが出力画像の横幅に収まる', () {
      for (final device in ScreenshotDevice.all) {
        expect(device.frameLeft + device.frameWidth, lessThanOrEqualTo(device.outputWidth), reason: device.fastlaneLabel);
        expect(device.frameLeft, greaterThanOrEqualTo(0), reason: device.fastlaneLabel);
      }
    });

    test('全デバイスでキャッチコピー帯が出力画像に収まる', () {
      for (final device in ScreenshotDevice.all) {
        expect(device.textBandLeft + device.textBandWidth, lessThanOrEqualTo(device.outputWidth), reason: device.fastlaneLabel);
        expect(device.textBandTop + device.textBandHeight, lessThanOrEqualTo(device.outputHeight), reason: device.fastlaneLabel);
      }
    });

    test('全デバイスでキャッチコピー帯と iPhone フレームが重ならない', () {
      for (final device in ScreenshotDevice.all) {
        // 縦は帯の下端がフレームの上端より上、横は帯の右端がフレームの左端より左のどちらかを満たす
        expect(
          device.textBandTop + device.textBandHeight <= device.frameTop || device.textBandLeft + device.textBandWidth <= device.frameLeft,
          isTrue,
          reason: device.fastlaneLabel,
        );
      }
    });

    test('Duo 外側は Mock 画面の主要部（下端の約 66px を除く）がフレーム内に見える', () {
      // frameTop + frameHeight が出力高さを超える量は、Mock のホームインジケータ相当の帯に収まる 100px 未満にする。
      expect(ScreenshotDevice.iPhoneDuoOuter.frameTop + ScreenshotDevice.iPhoneDuoOuter.frameHeight - ScreenshotDevice.iPhoneDuoOuter.outputHeight,
          lessThan(100));
    });

    test('Duo 内側は Mock 画面の主要部（下端の約 57px を除く）がフレーム内に見える', () {
      expect(ScreenshotDevice.iPhoneDuoInner.frameTop + ScreenshotDevice.iPhoneDuoInner.frameHeight - ScreenshotDevice.iPhoneDuoInner.outputHeight,
          lessThan(100));
    });
  });

  group('#screenshotDeviceForScreen', () {
    test('iPhone 15 Pro Max の論理サイズ 430×932 なら iPhone 6.7"', () {
      expect(screenshotDeviceForScreen(screenSize: const Size(430, 932)), ScreenshotDevice.iPhone67);
    });

    test('iPhone Duo 外側の論理サイズ 466×678 なら Duo 外側', () {
      expect(screenshotDeviceForScreen(screenSize: const Size(466, 678)), ScreenshotDevice.iPhoneDuoOuter);
    });

    test('iPhone Duo 内側の論理サイズ 951×669（横）なら Duo 内側', () {
      expect(screenshotDeviceForScreen(screenSize: const Size(951, 669)), ScreenshotDevice.iPhoneDuoInner);
    });

    test('出力寸法そのもの（ピクセル）を渡しても同じデバイスを選ぶ', () {
      for (final device in ScreenshotDevice.all) {
        expect(screenshotDeviceForScreen(screenSize: Size(device.outputWidth, device.outputHeight)), device, reason: device.fastlaneLabel);
      }
    });
  });

  group('#AppStoreScreenshotFrameLayout', () {
    // Mock 画面（ピルシート等）はテスト用フォント（Ahem）だと本番部品の固定レイアウトが数 px はみ出すため
    // （generate_screenshots_test.dart の _loadFonts のコメント参照）、ここでは帯とフレームの配置だけを
    // 単色の child で検証する。Mock 込みの見た目は generate_screenshots_test.dart（フォント取得後）と
    // Simulator 実撮影で確認する。
    for (final device in ScreenshotDevice.all) {
      testWidgets('${device.fastlaneLabel} の ${device.outputWidth.toInt()}×${device.outputHeight.toInt()} で帯とフレームが例外なく描画される', (tester) async {
        tester.view.physicalSize = Size(device.outputWidth, device.outputHeight);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(useMaterial3: false),
            home: AppStoreScreenshotFrameLayout(
              device: device,
              background: ScreenshotBackground.of(page: 1),
              title: 'ピルの服用を\nかんたん管理',
              subtitle: '飲み忘れを防ぐリマインダー',
              titleAccentWord: 'かんたん',
              child: const ColoredBox(color: Colors.white),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // フレーム内の Mock 領域（child）が出力画像の横幅に収まり、帯のテキストが描画されている。
        final childRect = tester.getRect(find.byType(ColoredBox).last);
        expect(childRect.left, greaterThanOrEqualTo(device.frameLeft));
        expect(childRect.right, lessThanOrEqualTo(device.frameLeft + device.frameWidth));
        expect(find.byType(Text), findsAtLeast(2));
      });
    }
  });
}
