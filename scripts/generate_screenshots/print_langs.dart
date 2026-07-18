import 'package:pilll/features/appstore_screenshot/screenshot_locale.dart';

/// 生成対象の全 arb 言語コードをカンマ区切りで出力する。
/// capture_screenshots.sh が撮影対象言語の既定値を得るために使う。
void main() {
  print(allScreenshotLanguages.join(','));
}
