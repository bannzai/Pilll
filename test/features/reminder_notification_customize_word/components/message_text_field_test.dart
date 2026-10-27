import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/features/reminder_notification_customize_word/components/daily_taken_message_text_field.dart';
import 'package:pilll/features/reminder_notification_customize_word/components/missed_taken_message_text_field.dart';

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

  Future<void> useGerman(WidgetTester tester) async {
    final originalL = L;
    addTearDown(() => L = originalL);
    L = lookupAppLocalizations(const Locale('de'));
    tester.view.physicalSize = const Size(screenWidth, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

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
