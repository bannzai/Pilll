import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/localizations/formatted_pill_number_text_span.dart';
import 'package:pilll/l10n/app_localizations.dart';

void main() {
  group("#formattedPillNumberTextSpan", () {
    const numberStyle = TextStyle(fontSize: 40);
    const labelStyle = TextStyle(fontSize: 14);

    void useLocale(String languageCode) {
      L = lookupAppLocalizations(Locale(languageCode));
      addTearDown(() => L = lookupAppLocalizations(const Locale('ja')));
    }

    List<(String?, TextStyle?)> spans() => formattedPillNumberTextSpan(pillNumber: "5", numberStyle: numberStyle, labelStyle: labelStyle)
        .children!
        .cast<TextSpan>()
        .map((span) => (span.text, span.style))
        .toList();

    test("ja では番号の後ろの「番」だけが番号と別の文字の大きさになる", () {
      useLocale('ja');
      expect(spans(), [("", labelStyle), ("5", numberStyle), ("番", labelStyle)]);
    });

    test("en では番号の前の「No. 」だけが番号と別の文字の大きさになる", () {
      useLocale('en');
      expect(spans(), [("No. ", labelStyle), ("5", numberStyle), ("", labelStyle)]);
    });

    test("fr では番号の前の「n° 」だけが番号と別の文字の大きさになる", () {
      useLocale('fr');
      expect(spans(), [("n° ", labelStyle), ("5", numberStyle), ("", labelStyle)]);
    });
  });
}
