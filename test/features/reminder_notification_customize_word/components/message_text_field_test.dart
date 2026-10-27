import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/features/reminder_notification_customize_word/components/daily_taken_message_text_field.dart';
import 'package:pilll/features/reminder_notification_customize_word/components/missed_taken_message_text_field.dart';
import 'package:pilll/features/reminder_notification_customize_word/components/word_text_field.dart';

void main() {
  // iPhone 17 の論理幅 (402pt) に合わせる。説明文が長い言語でこの幅を超えて counter の Row が溢れていた
  const screenWidth = 402.0;

  Widget subject(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(width: screenWidth, child: child),
      ),
    );
  }

  Future<void> useLanguage(WidgetTester tester, String lang) async {
    final originalL = L;
    addTearDown(() => L = originalL);
    L = lookupAppLocalizations(Locale(lang));
    tester.view.physicalSize = const Size(screenWidth, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> useGerman(WidgetTester tester) => useLanguage(tester, 'de');

  group('#WordTextField', () {
    // 通知タイトル欄の説明行は、QA で mk・hy・ka の訳文が溢れた (ka の超過幅が最大)
    testWidgets('説明文が長い言語 (ジョージア語) で未入力でも counter の Row が溢れない', (tester) async {
      await useLanguage(tester, 'ka');
      await tester.pumpWidget(subject(WordTextField(
        word: ValueNotifier(''),
        textFieldController: TextEditingController(),
        focusNode: FocusNode(),
        submit: () {},
      )));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('説明文が長い言語 (ジョージア語) で入力中でも counter の Row が溢れない', (tester) async {
      await useLanguage(tester, 'ka');
      await tester.pumpWidget(subject(WordTextField(
        word: ValueNotifier('text'),
        textFieldController: TextEditingController(text: 'text'),
        focusNode: FocusNode(),
        submit: () {},
      )));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('4/8'), findsOneWidget);
    });
  });

  group('#DailyTakenMessageTextField', () {
    testWidgets('説明文が長い言語 (ドイツ語) で入力中でも counter の Row が溢れない', (tester) async {
      await useGerman(tester);
      await tester.pumpWidget(subject(DailyTakenMessageTextField(
        dailyTakenMessage: ValueNotifier('text'),
        textFieldController: TextEditingController(text: 'text'),
        focusNode: FocusNode(),
      )));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('4/100'), findsOneWidget);
    });
  });

  group('#MissedTakenMessageTextField', () {
    testWidgets('説明文が長い言語 (ドイツ語) で入力中でも counter の Row が溢れない', (tester) async {
      await useGerman(tester);
      await tester.pumpWidget(subject(MissedTakenMessageTextField(
        missedTakenMessage: ValueNotifier('text'),
        textFieldController: TextEditingController(text: 'text'),
        focusNode: FocusNode(),
      )));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('4/100'), findsOneWidget);
    });
  });
}
