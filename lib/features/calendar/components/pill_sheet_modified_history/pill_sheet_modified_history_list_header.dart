import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';

class PillSheetModifiedHisotiryListHeader extends StatelessWidget {
  const PillSheetModifiedHisotiryListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return _HeaderLayout(
      day: Container(width: 64),
      pillNumbersOrHyphen: Container(),
      detail: Text(
        L.takingTime,
        style: const TextStyle(
          color: TextColor.main,
          fontFamily: FontFamily.japanese,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.left,
      ),
      takenPillActionOList: PillSheetModifiedHistoryListHeaderWrappedLabel(
        text: L.alreadyTaken,
        style: const TextStyle(
          color: TextColor.main,
          fontFamily: FontFamily.japanese,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

/// 服用履歴の列見出しのうち、幅の狭い列 (服用済み) に置くラベル。
/// 語の境界で折り返し、幅より長い語がある言語 (de「Pille eingenommen」の「eingenommen」等) では、その語が収まるまで全体を縮小する。
/// Text をそのまま置くと、幅より長い語が語の途中で折り返される
class PillSheetModifiedHistoryListHeaderWrappedLabel extends StatelessWidget {
  /// 列見出しの訳語
  final String text;

  /// 縮小する前の文字のスタイル
  final TextStyle style;

  const PillSheetModifiedHistoryListHeaderWrappedLabel({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 空白で区切った語のうち、語の途中で改行できない語の最長の幅を測る。
        // 空白を入れない文字 (漢字・かな・タイ文字・ラオ文字・クメール文字・ビルマ文字) を含む語は語の途中で改行できるため測らない。
        // TextPainter.minIntrinsicWidth は、制約なしで layout すると漢字の文字列を 1 語として測るなど、layout の幅で値が変わり使えない (widget test で実測)
        final longestWordWidth = text.split(RegExp(r'\s+')).where((word) => !word.contains(RegExp(r'[฀-໿က-႟ក-៿぀-ヿ㐀-鿿豈-﫿]'))).map((word) {
          final painter = TextPainter(
            text: TextSpan(
              text: word,
              // Text.build と同じく、「文字を太くする」設定の時は bold を重ねてから測る (重ねないと描く時の字幅が測った幅より広くなる)
              style: DefaultTextStyle.of(context)
                  .style
                  .merge(style)
                  .merge(MediaQuery.boldTextOf(context) ? const TextStyle(fontWeight: FontWeight.bold) : null),
            ),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
            maxLines: 1,
          )..layout();
          final width = painter.width;
          painter.dispose();
          return width;
        }).fold<double>(0, (longest, width) => width > longest ? width : longest);
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: longestWordWidth > constraints.maxWidth ? longestWordWidth.ceilToDouble() : constraints.maxWidth,
            child: Text(text, style: style, textAlign: TextAlign.center),
          ),
        );
      },
    );
  }
}

// Copied from RowLayout
class _HeaderLayout extends StatelessWidget {
  final Widget day;
  final Widget pillNumbersOrHyphen;
  final Widget detail;
  final Widget takenPillActionOList;

  const _HeaderLayout({
    required this.day,
    required this.pillNumbersOrHyphen,
    required this.detail,
    required this.takenPillActionOList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        // 訳の長い言語で片方の見出しだけ 2 行になっても、見出しの下端を揃える
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          day,
          const SizedBox(width: 8),
          SizedBox(width: 79, child: pillNumbersOrHyphen),
          const SizedBox(width: 8),
          Expanded(child: detail),
          const SizedBox(width: 8),
          SizedBox(width: 57, child: takenPillActionOList),
        ],
      ),
    );
  }
}
