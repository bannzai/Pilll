import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/localizations/l.dart';

/// 服用お休みの例を示すピルシートの図。図の吹き出しの文言は言語ごとに訳すため、SVG ではなく Text で重ねる。
/// SVG の viewBox (221x133) の座標で描き、親の幅・高さが足りない時は文字も図と一緒に縦横比を保って縮める
class RestDurationExplainImage extends StatelessWidget {
  /// 日付表示モードなら吹き出しに日付の範囲、それ以外は日数を出す
  final PillSheetAppearanceMode appearanceMode;

  const RestDurationExplainImage({
    super.key,
    required this.appearanceMode,
  });

  @override
  Widget build(BuildContext context) {
    // 画面が狭い時に SVG だけが縮んで吹き出しの文字の位置がずれないよう、文字を含めた全体を縮める
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 221,
        height: 133,
        child: Stack(
          children: [
            SvgPicture.asset(
              appearanceMode == PillSheetAppearanceMode.date ? 'images/explain_rest_duration_date.svg' : 'images/explain_rest_duration_number.svg',
            ),
            // SVG の吹き出しの矩形 (x: 43.8〜147.8, y: 91〜133) に合わせる。文字の左右の余白は、元の画像に焼き込まれていた日本語の文字の位置から取った
            Positioned(
              left: 47.8,
              top: 91,
              width: 96,
              height: 42,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    appearanceMode == PillSheetAppearanceMode.date ? L.exampleRestDurationDateBalloon : L.exampleRestDurationNumberBalloon,
                    textAlign: TextAlign.center,
                    // 元の画像に焼き込まれていた文字は端末の文字サイズの設定で大きさが変わらなかったため、それに合わせて吹き出しからはみ出さないようにする
                    textScaler: TextScaler.noScaling,
                    // fontSize・height は元の画像に焼き込まれていた日本語の文字の大きさ (漢字の高さ約 11)・行の間隔 (約 17) に合わせた
                    style: const TextStyle(
                      color: TextColor.white,
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
