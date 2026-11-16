import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/record/components/setting/components/display_number_setting/display_number_setting_sheet.dart';

void main() {
  group('#displayNumberSettingSheetUpdatedDisplayNumberSetting', () {
    test('始まりも終わりも未設定で、どちらも入力していない場合は保存する設定が無い', () {
      expect(
        displayNumberSettingSheetUpdatedDisplayNumberSetting(
          beginPillNumber: null,
          endPillNumber: null,
        ),
        isNull,
      );
    });

    test('始まりも終わりも未設定で、始まりの番号だけを 15 と入力した場合は終わりの番号が未設定のまま保存される', () {
      expect(
        displayNumberSettingSheetUpdatedDisplayNumberSetting(
          beginPillNumber: 15,
          endPillNumber: null,
        ),
        const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 15,
          endPillNumber: null,
        ),
      );
    });

    test(
      '始まりの番号だけが 1 で設定済み (ヤーズフレックス向けの初期設定の状態) で、何も入力していない場合は終わりの番号が未設定のまま保存される',
      () {
        expect(
          displayNumberSettingSheetUpdatedDisplayNumberSetting(
            beginPillNumber: 1,
            endPillNumber: null,
          ),
          const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 1,
            endPillNumber: null,
          ),
        );
      },
    );

    test('終わりの番号を 30 と入力した場合は入力した値が終わりの番号として保存される', () {
      expect(
        displayNumberSettingSheetUpdatedDisplayNumberSetting(
          beginPillNumber: 15,
          endPillNumber: 30,
        ),
        const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 15,
          endPillNumber: 30,
        ),
      );
    });

    test('終わりの番号を 1 と入力した場合は 1 が終わりの番号として保存される', () {
      expect(
        displayNumberSettingSheetUpdatedDisplayNumberSetting(
          beginPillNumber: 15,
          endPillNumber: 1,
        ),
        const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 15,
          endPillNumber: 1,
        ),
      );
    });

    test('始まりの番号が未設定で、終わりの番号だけを 30 と入力した場合は始まりの番号が 1 で保存される', () {
      expect(
        displayNumberSettingSheetUpdatedDisplayNumberSetting(
          beginPillNumber: null,
          endPillNumber: 30,
        ),
        const PillSheetGroupDisplayNumberSetting(
          beginPillNumber: 1,
          endPillNumber: 30,
        ),
      );
    });
  });
}
