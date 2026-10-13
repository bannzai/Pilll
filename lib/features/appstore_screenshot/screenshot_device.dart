import 'dart:math' as math;
import 'dart:ui';

/// App Store スクリーンショットを生成する対象デバイスの定義。
///
/// 出力画像のピクセル寸法・Mock 画面を描く論理サイズ・キャッチコピーや
/// iPhone フレームのレイアウト座標をまとめて保持する SSOT。
/// deliver は画像のピクセル寸法からデバイス種別を自動判定するため、
/// [fastlaneLabel] は出力ファイル名の可読性のためだけに使う。
///
/// iPhone 6.7"（縦）と iPhone Duo の外側（縦）・内側（横）を定義する。縦横どちらも
/// 「背景 + キャッチコピー帯 + iPhone フレーム」の同じレイヤ構造で、帯とフレームの
/// 座標だけが変わる（縦は帯が上・フレームが下、横は帯が左・フレームが右）。
class ScreenshotDevice {
  const ScreenshotDevice({
    required this.fastlaneLabel,
    required this.outputWidth,
    required this.outputHeight,
    required this.logicalWidth,
    required this.logicalHeight,
    required this.safeAreaTop,
    required this.textBandTop,
    required this.textBandLeft,
    required this.textBandWidth,
    required this.textBandHeight,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.titleSubtitleGap,
    required this.frameTop,
    required this.frameLeft,
    required this.frameWidth,
    required this.frameBezel,
  });

  /// 出力ファイル名に埋め込むデバイス種別ラベル。
  final String fastlaneLabel;

  /// 出力 PNG の横ピクセル数。6.7" は 1290。
  final double outputWidth;

  /// 出力 PNG の縦ピクセル数。6.7" は 2796。
  final double outputHeight;

  /// フレーム内に描く Mock 画面の論理幅。iPhone 相当の 430。
  /// この論理サイズで UI を描いてから実寸へ拡大するのが肝。
  final double logicalWidth;

  /// フレーム内に描く Mock 画面の論理高さ。iPhone 相当の 932。
  final double logicalHeight;

  /// Mock 画面上部のセーフエリア（ステータスバー相当）の論理高さ。
  final double safeAreaTop;

  /// キャッチコピーを縦方向に中央寄せする帯の開始 y 座標（出力ピクセル）。
  final double textBandTop;

  /// キャッチコピー帯の左端 x 座標（出力ピクセル）。
  final double textBandLeft;

  /// キャッチコピー帯の幅（出力ピクセル）。この幅に収まるよう語中折り返しせずに縮小する。
  final double textBandWidth;

  /// キャッチコピー帯の高さ（出力ピクセル）。この範囲内で上下中央に配置する。
  final double textBandHeight;

  /// タイトルのフォントサイズ（出力ピクセル）。
  final double titleFontSize;

  /// サブタイトルのフォントサイズ（出力ピクセル）。
  final double subtitleFontSize;

  /// タイトルとサブタイトルの間隔（出力ピクセル）。
  final double titleSubtitleGap;

  /// iPhone フレーム上端の y 座標（出力ピクセル）。
  final double frameTop;

  /// iPhone フレーム左端の x 座標（出力ピクセル）。
  final double frameLeft;

  /// iPhone フレームの外形幅（出力ピクセル）。
  final double frameWidth;

  /// iPhone フレームのベゼル幅（出力ピクセル）。フレーム内側の余白にあたる。
  final double frameBezel;

  /// フレーム内側（画面表示領域）の幅。
  double get innerScreenWidth => frameWidth - frameBezel * 2;

  /// 論理幅から実寸へ拡大する倍率。
  double get screenScale => innerScreenWidth / logicalWidth;

  /// フレーム内側（画面表示領域）の高さ。論理サイズの縦横比を保つ。
  double get innerScreenHeight => logicalHeight * screenScale;

  /// iPhone フレームの外形高さ。
  double get frameHeight => innerScreenHeight + frameBezel * 2;

  /// 出力画像の縦横比（幅 ÷ 高さ）。[screenshotDeviceForScreen] が端末画面との照合に使う。
  double get outputAspectRatio => outputWidth / outputHeight;

  /// iPhone 6.7"（1290×2796）。App Store の 6.7" 必須枠に対応する。
  ///
  /// 各座標・寸法は 1290×2796 の実測値から、テキスト帯・フレームが
  /// 縦にきれいに収まるよう決めた固定値。フレーム下端は
  /// frameTop(640) + frameHeight(約2142) ≒ 2782 で、下辺に僅かな余白を残す。
  static const ScreenshotDevice iPhone67 = ScreenshotDevice(
    fastlaneLabel: 'APP_IPHONE_67',
    outputWidth: 1290,
    outputHeight: 2796,
    logicalWidth: 430,
    logicalHeight: 932,
    safeAreaTop: 59,
    textBandTop: 190,
    textBandLeft: 90,
    textBandWidth: 1110,
    textBandHeight: 450,
    titleFontSize: 80,
    subtitleFontSize: 44,
    titleSubtitleGap: 24,
    frameTop: 640,
    frameLeft: 140,
    frameWidth: 1010,
    frameBezel: 20,
  );

  /// iPhone Duo の外側ディスプレイ（1398×2034、縦）。
  ///
  /// 寸法の出典: Apple「Screenshot specifications」の iPhone Duo の節
  /// （ https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications ）。
  /// 6.7"（縦横比 0.46）より横に広い 0.69 のため、6.7" のフレーム幅をそのまま使うと
  /// Mock 画面の下 4 割が切れる。フレーム幅を 760 に絞り、下端が
  /// frameTop(500) + frameHeight(約1600) ≒ 2100 で画面下端(2034)から約 66px だけ
  /// はみ出す（Mock のホームインジケータ相当の帯だけが切れる）配置にする。
  static const ScreenshotDevice iPhoneDuoOuter = ScreenshotDevice(
    fastlaneLabel: 'APP_IPHONE_DUO_OUTER',
    outputWidth: 1398,
    outputHeight: 2034,
    logicalWidth: 430,
    logicalHeight: 932,
    safeAreaTop: 59,
    // 帯の右端 1180px は、OS が外側ディスプレイの右端の列（約 84pt = 252px）に描く時刻・Wi-Fi の
    // 表示（1200px 付近から）に文言が掛からない幅。左右対称にして画像の中央に置く。
    textBandTop: 110,
    textBandLeft: 218,
    textBandWidth: 962,
    textBandHeight: 370,
    titleFontSize: 72,
    subtitleFontSize: 40,
    titleSubtitleGap: 20,
    frameTop: 500,
    frameLeft: 319,
    frameWidth: 760,
    frameBezel: 20,
  );

  /// iPhone Duo の内側ディスプレイ（2853×2007、横）。
  ///
  /// 寸法の出典は [iPhoneDuoOuter] と同じ。仕様は内側の縦（2007×2853）も受け付けるが、
  /// 開いた姿勢の Simulator が回転なしで横長を返すため横で作る
  /// （appstore-screenshot-builder skill `references/iphone-duo.md` の既定）。
  /// 横長ではキャッチコピー帯を左（x 170〜1640、全高で上下中央）、iPhone フレームを右
  /// （x 1760〜2660）に置く。フレーム下端は frameTop(160) + frameHeight(約1904) ≒ 2064 で、
  /// 外側と同じく下端から約 57px だけはみ出す。
  static const ScreenshotDevice iPhoneDuoInner = ScreenshotDevice(
    fastlaneLabel: 'APP_IPHONE_DUO_INNER',
    outputWidth: 2853,
    outputHeight: 2007,
    logicalWidth: 430,
    logicalHeight: 932,
    safeAreaTop: 59,
    textBandTop: 0,
    textBandLeft: 170,
    textBandWidth: 1470,
    textBandHeight: 2007,
    titleFontSize: 108,
    subtitleFontSize: 56,
    titleSubtitleGap: 28,
    // フレームの右端 2600px は、OS が内側ディスプレイの右上（2640px 付近から）に描く時刻・Wi-Fi の
    // 表示にフレームが掛からない位置。
    frameTop: 160,
    frameLeft: 1700,
    frameWidth: 900,
    frameBezel: 20,
  );

  /// 定義済みの全デバイス。[screenshotDeviceForScreen] の候補。
  static const List<ScreenshotDevice> all = [iPhone67, iPhoneDuoOuter, iPhoneDuoInner];
}

/// 端末画面の論理サイズに最も縦横比が近い [ScreenshotDevice] を返す。
///
/// カタログアプリの全画面プレビューが、載っている Simulator（iPhone 15 Pro Max の 430×932、
/// iPhone Duo 外側の 466×678、同内側の 951×669）に合わせて合成ページを選ぶために使う。
/// 縦横比の差は対数で比べ、縦長・横長のどちらにも同じ尺度で最近傍を決める。
ScreenshotDevice screenshotDeviceForScreen({required Size screenSize}) {
  return ScreenshotDevice.all.reduce((nearest, candidate) {
    return _aspectDistance(screenSize, candidate) < _aspectDistance(screenSize, nearest) ? candidate : nearest;
  });
}

/// 画面と出力画像の縦横比の対数差（絶対値）。
double _aspectDistance(Size screenSize, ScreenshotDevice device) {
  return (math.log(screenSize.width / screenSize.height) - math.log(device.outputAspectRatio)).abs();
}
