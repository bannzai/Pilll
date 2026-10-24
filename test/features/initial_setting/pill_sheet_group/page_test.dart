import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/features/initial_setting/pill_sheet_group/page.dart';
import 'package:pilll/features/initial_setting/yaz_flex/page.dart';
import 'package:pilll/features/sign_in/sign_in_sheet.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/auth/apple.dart';
import 'package:pilll/utils/auth/google.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    Environment.isTest = true;
    // ルートの screen() が logScreenView で FirebaseAnalytics を直接呼ぶため、Firebase の無いテストでは差し替える
    analytics = MockAnalytics();

    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));
  });

  // ルートの pop のアニメーション (最長 300ms) とルートが外れた後の再描画を終えるまで進める。HUD のインジケータが回り続けるため pumpAndSettle は使えない
  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }
  }

  group("#InitialSettingPillSheetGroupPage 既存アカウントでのログイン", () {
    // 初期設定 (InitialSettingYazFlexPage が最初のルート) とホームを切り替える InitialSettingOrAppPage の代わり
    final showsHomeProvider = StateProvider((ref) => false);

    testWidgets("「いいえ」で開いたこのページからログインすると最初のページまで戻り、ホームに切り替わった後に初期設定のページが残らない",
        (WidgetTester tester) async {
      // ログインのシートのボタンの文字がテスト用フォントだと iPhone SE の幅で 12px はみ出す (既存のシートの問題) ため、iPhone 14 の幅で描画する
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            initialSettingStateNotifierProvider.overrideWith(
              (ref) => InitialSettingStateNotifier(
                MockEndInitialSetting(),
                MockBatchFactory(),
                MockBatchSetSetting(),
                MockBatchSetPillSheetModifiedHistory(),
                MockBatchSetPillSheetGroup(),
                MockRegisterReminderLocalNotificationRunner(),
                DateTime.parse("2022-03-02"),
              ),
            ),
            firebaseUserStateProvider.overrideWith((ref) => Stream.value(null)),
            isAppleLinkedProvider.overrideWithValue(false),
            isGoogleLinkedProvider.overrideWithValue(false),
            linkAppleProvider
                .overrideWithValue(LinkApple(MockDatabaseConnection())),
            linkGoogleProvider
                .overrideWithValue(LinkGoogle(MockDatabaseConnection())),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) => ref.watch(showsHomeProvider)
                  ? const Scaffold(key: Key('home'))
                  : const InitialSettingYazFlexPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 「いいえ」でこのページを push する
      await tester.tap(find.byType(AppOutlinedButton));
      await tester.pumpAndSettle();
      expect(find.byType(InitialSettingPillSheetGroupPage), findsOneWidget);

      // 「すでにアカウントをお持ちの方はこちら」でログインのシートを開く
      await tester.tap(find.byType(AlertButton));
      await tester.pumpAndSettle();
      expect(find.byType(SignInSheet), findsOneWidget);
      // ログインのシートのボタンの文字はテスト用フォントだと横にはみ出す (既存のシートの問題)。このテストの対象ではないので RenderFlex overflow の例外を捨てる
      tester.takeException();

      // Apple / Google のログインは Firebase が要るため、ログインが決まった後にシートが呼ぶ onSignIn を直接呼ぶ
      await tester
          .widget<SignInSheet>(find.byType(SignInSheet))
          .onSignIn!(LinkAccountType.apple);
      // onSignIn が HUD (回り続けるインジケータ) を出すため pumpAndSettle は終わらない。ルートの遷移のアニメーションと、ルートが外れた後の描画が終わるまで数フレーム進める
      await pumpFrames(tester);
      expect(find.byType(SignInSheet), findsNothing);
      expect(find.byType(InitialSettingPillSheetGroupPage), findsNothing);
      expect(find.byType(InitialSettingYazFlexPage), findsOneWidget);

      // ログイン後に userProvider が更新されて InitialSettingOrAppPage がホームに切り替わる。push したページが残っていればホームの上に見えてしまう
      final element = tester.element(find.byType(InitialSettingYazFlexPage));
      ProviderScope.containerOf(element)
          .read(showsHomeProvider.notifier)
          .state = true;
      await pumpFrames(tester);
      expect(find.byKey(const Key('home')), findsOneWidget);
      expect(find.byType(InitialSettingYazFlexPage), findsNothing);
      expect(find.byType(InitialSettingPillSheetGroupPage), findsNothing);
    });
  });
}
