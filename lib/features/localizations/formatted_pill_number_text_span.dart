import 'package:flutter/painting.dart';
import 'package:pilll/features/localizations/l.dart';

/// [L.formattedPillNumber] の訳文を、ピル番号を [numberStyle]、番号の前後の文字列を [labelStyle] にした TextSpan で返す。
/// 番号の前後どちらに文字列が付くかは言語で異なる (ja「5番」、en「No. 5」) ため、訳文を番号の位置で分ける。
/// 訳文は {number} をちょうど 1 つ含む前提で、translate-app-arb の check がプレースホルダーの一致を検査している。
TextSpan formattedPillNumberTextSpan({
  required String pillNumber,
  required TextStyle numberStyle,
  required TextStyle labelStyle,
}) {
  const placeholder = '{number}';
  final [prefix, suffix] = L.formattedPillNumber(placeholder).split(placeholder);
  return TextSpan(
    children: [
      TextSpan(text: prefix, style: labelStyle),
      TextSpan(text: pillNumber, style: numberStyle),
      TextSpan(text: suffix, style: labelStyle),
    ],
  );
}
