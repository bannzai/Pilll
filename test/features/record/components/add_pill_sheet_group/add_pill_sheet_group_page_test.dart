import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/record/components/add_pill_sheet_group/add_pill_sheet_group_page.dart';
import 'package:pilll/features/record/components/add_pill_sheet_group/provider.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/utils/analytics.dart';

import '../../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    analytics = MockAnalytics();
  });

  group('#AddPillSheetGroupPage 確定ボタンの文言', () {
    // 確定ボタンはピルシートの種類が 1 つ以上ある時だけ表示されるため、種類を設定済みの Setting を使う
    const setting = Setting(
      pillNumberForFromMenstruation: 0,
      durationMenstruation: 0,
      isOnReminder: true,
      timezoneDatabaseName: 'Asia/Tokyo',
      pillSheetTypes: [PillSheetType.pillsheet_28_7],
    );

    /// 書き込みを Mock にした Provider で、ピルシートの無い状態から開いた追加画面を返す
    Widget subject() {
      return ProviderScope(
        overrides: [
          addPillSheetGroupProvider.overrideWith(
            (ref) => AddPillSheetGroup(
              batchFactory: MockBatchFactory(),
              batchSetPillSheetGroup: MockBatchSetPillSheetGroup(),
              batchSetPillSheetModifiedHistory:
                  MockBatchSetPillSheetModifiedHistory(),
              batchSetSetting: MockBatchSetSetting(),
            ),
          ),
        ],
        child: const MaterialApp(
          home: AddPillSheetGroupPage(pillSheetGroup: null, setting: setting),
        ),
      );
    }

    // 期待値は arb の訳文をそのまま書く。L.add で照合すると Widget と同じ定数同士の比較になり、直書きを検出できない
    for (final (lang, expectedText) in [('ja', '追加'), ('de', 'Hinzufügen')]) {
      testWidgets('表示言語が $lang の時、確定ボタンは「$expectedText」と表示される', (tester) async {
        final originalL = L;
        addTearDown(() => L = originalL);
        L = lookupAppLocalizations(Locale(lang));
        // Issue #2078 の再現に使った iPhone 17 の論理サイズ (402 × 874pt)。テストの既定 (800 × 600) では実機と違う幅で描画されるため
        tester.view.physicalSize = const Size(402, 874);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(subject());
        await tester.pump();
        // 服用数の入力欄 (PillTakenCountInput) の文字はテスト用フォントだと de で横にはみ出す。このテストの対象ではないので RenderFlex overflow の例外を捨てる
        tester.takeException();

        expect(
          find.descendant(
              of: find.byType(PrimaryButton),
              matching: find.text(expectedText)),
          findsOneWidget,
        );
      });
    }
  });
}
