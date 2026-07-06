import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/settings/components/rows/end_trial_for_debug.dart';
import 'package:pilll/utils/environment.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Environment.isTest = true;
  });

  group('#EndTrialForDebugRow', () {
    testWidgets('トライアル解除の行が ListTile として表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Material(child: EndTrialForDebugRow()),
          ),
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byIcon(Icons.timer_off), findsOneWidget);
    });
  });
}
