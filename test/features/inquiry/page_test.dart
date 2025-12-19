import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/inquiry/page.dart';
import 'package:pilll/utils/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/supported_device.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    Environment.isTest = true;
  });

  group('InquiryPage', () {
    group('メールアドレスバリデーション', () {
      testWidgets('メールアドレスが空の時はエラーを表示しない', (WidgetTester tester) async {
        SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

        await tester.pumpWidget(
          const MaterialApp(
            home: InquiryPage(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('有効なメールアドレスを入力してください'), findsNothing);
      });

      testWidgets('メールアドレスが不正な形式の時はエラーを表示する', (WidgetTester tester) async {
        SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

        await tester.pumpWidget(
          const MaterialApp(
            home: InquiryPage(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
        await tester.pumpAndSettle();

        expect(find.text('有効なメールアドレスを入力してください'), findsOneWidget);
      });

      testWidgets('メールアドレスが正しい形式の時はエラーを表示しない', (WidgetTester tester) async {
        SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

        await tester.pumpWidget(
          const MaterialApp(
            home: InquiryPage(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.pumpAndSettle();

        expect(find.text('有効なメールアドレスを入力してください'), findsNothing);
      });
    });

    group('お問い合わせ内容バリデーション', () {
      testWidgets('メールアドレスが正しくお問い合わせ内容が空の時はエラーを表示する', (WidgetTester tester) async {
        SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

        await tester.pumpWidget(
          const MaterialApp(
            home: InquiryPage(),
          ),
        );
        await tester.pumpAndSettle();

        // メールアドレスを入力
        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.pumpAndSettle();

        // "お問い合わせ内容は必須です" というエラーメッセージ
        expect(find.text('お問い合わせ内容は必須です'), findsOneWidget);
      });

      testWidgets('メールアドレスが不正な時はお問い合わせ内容のエラーを表示しない', (WidgetTester tester) async {
        SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

        await tester.pumpWidget(
          const MaterialApp(
            home: InquiryPage(),
          ),
        );
        await tester.pumpAndSettle();

        // 不正なメールアドレスを入力
        await tester.enterText(find.byType(TextFormField).first, 'invalid');
        await tester.pumpAndSettle();

        expect(find.text('お問い合わせ内容は必須です'), findsNothing);
      });

      testWidgets('お問い合わせ内容が入力されている時はエラーを表示しない', (WidgetTester tester) async {
        SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

        await tester.pumpWidget(
          const MaterialApp(
            home: InquiryPage(),
          ),
        );
        await tester.pumpAndSettle();

        // メールアドレスを入力
        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.pumpAndSettle();

        // お問い合わせ内容を入力
        await tester.enterText(find.byType(TextFormField).at(1), 'テスト内容');
        await tester.pumpAndSettle();

        expect(find.text('お問い合わせ内容は必須です'), findsNothing);
      });
    });

    group('送信ボタン', () {
      testWidgets('フォームが不正な時は送信ボタンがdisabled', (WidgetTester tester) async {
        SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

        await tester.pumpWidget(
          const MaterialApp(
            home: InquiryPage(),
          ),
        );
        await tester.pumpAndSettle();

        final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
        expect(button.onPressed, isNull);
      });

      testWidgets('メールアドレスのみ入力時は送信ボタンがdisabled', (WidgetTester tester) async {
        SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

        await tester.pumpWidget(
          const MaterialApp(
            home: InquiryPage(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.pumpAndSettle();

        final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
        expect(button.onPressed, isNull);
      });

      testWidgets('フォームが正しい時は送信ボタンがenabled', (WidgetTester tester) async {
        SupportedDeviceType.iPhone5SE2nd.binding(tester.view);

        await tester.pumpWidget(
          const MaterialApp(
            home: InquiryPage(),
          ),
        );
        await tester.pumpAndSettle();

        // メールアドレスを入力
        await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
        await tester.pumpAndSettle();

        // お問い合わせ内容を入力
        await tester.enterText(find.byType(TextFormField).at(1), 'テスト内容');
        await tester.pumpAndSettle();

        final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
        expect(button.onPressed, isNotNull);
      });
    });
  });
}
