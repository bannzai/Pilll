/// App Store スクリーンショットを生成する対象デバイスの定義。
///
/// 出力画像のピクセル寸法・Mock 画面を描く論理サイズ・キャッチコピーや
/// iPhone フレームのレイアウト比率をまとめて保持する SSOT。
/// deliver は画像のピクセル寸法からデバイス種別を自動判定するため、
/// [fastlaneLabel] は出力ファイル名の可読性のためだけに使う。
///
/// 現状は iPhone 6.7" のみ定義する。将来 iPad 等を足す場合は
/// 同じフィールド構成で別インスタンスを追加する。
class ScreenshotDevice {
  const ScreenshotDevice({
    required this.fastlaneLabel,
    required this.outputWidth,
    required this.outputHeight,
    required this.logicalWidth,
    required this.logicalHeight,
    required this.safeAreaTop,
    required this.textBandTop,
    required this.textBandHeight,
    required this.textSidePadding,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.titleSubtitleGap,
    required this.frameTop,
    required this.frameWidth,
    required this.frameBezel,
  });

  /// deliver / fastlane 上のデバイス種別ラベル。出力ファイル名に埋め込む。
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

  /// キャッチコピー帯の高さ（出力ピクセル）。この範囲内で上下中央に配置する。
  final double textBandHeight;

  /// キャッチコピーの左右パディング（出力ピクセル）。
  final double textSidePadding;

  /// タイトルのフォントサイズ（出力ピクセル）。
  final double titleFontSize;

  /// サブタイトルのフォントサイズ（出力ピクセル）。
  final double subtitleFontSize;

  /// タイトルとサブタイトルの間隔（出力ピクセル）。
  final double titleSubtitleGap;

  /// iPhone フレーム上端の y 座標（出力ピクセル）。
  final double frameTop;

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

  /// フレームを横中央に置いたときの左端 x 座標。
  double get frameLeft => (outputWidth - frameWidth) / 2;

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
    textBandHeight: 450,
    textSidePadding: 90,
    titleFontSize: 80,
    subtitleFontSize: 44,
    titleSubtitleGap: 24,
    frameTop: 640,
    frameWidth: 1010,
    frameBezel: 20,
  );
}
