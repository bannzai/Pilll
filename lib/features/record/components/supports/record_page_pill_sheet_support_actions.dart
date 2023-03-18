import 'package:flutter/material.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/features/record/components/supports/components/appearance_mode/switching_appearance_mode.dart';
import 'package:pilll/features/record/components/supports/components/display_number_setting/display_number_setting_button.dart';
import 'package:pilll/features/record/components/supports/components/rest_duration/begin_manual_rest_duration_button.dart';
import 'package:pilll/features/record/components/supports/components/rest_duration/end_manual_rest_duration_button.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';

class RecordPagePillSheetSupportActions extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;
  final Setting setting;
  final PremiumAndTrial premiumAndTrial;

  const RecordPagePillSheetSupportActions({
    Key? key,
    required this.pillSheetGroup,
    required this.activedPillSheet,
    required this.setting,
    required this.premiumAndTrial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RestDuration? restDuration = activedPillSheet.activeRestDuration;

    return SizedBox(
      width: PillSheetViewLayout.width,
      child: Row(
        children: [
          SwitchingAppearanceMode(
            setting: setting,
            premiumAndTrial: premiumAndTrial,
          ),
          const Spacer(),
          if (setting.pillSheetAppearanceMode == PillSheetAppearanceMode.sequential) ...[
            DisplayNumberSettingButton(
              pillSheetGroup: pillSheetGroup,
            ),
          ],
          const Spacer(),
          if (restDuration != null) ...[
            EndManualRestDurationButton(
              restDuration: restDuration,
              activedPillSheet: activedPillSheet,
              pillSheetGroup: pillSheetGroup,
              didEndRestDuration: () {
                if (pillSheetGroup.sequentialLastTakenPillNumber > 0 && setting.pillSheetAppearanceMode == PillSheetAppearanceMode.sequential) {
                  showEndRestDurationModal(
                    context,
                    pillSheetGroup: pillSheetGroup,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(
                        seconds: 2,
                      ),
                      content: Text("服用お休みが終了しました"),
                    ),
                  );
                }
              },
            ),
          ] else ...[
            BeginManualRestDurationButton(
              appearanceMode: setting.pillSheetAppearanceMode,
              activedPillSheet: activedPillSheet,
              pillSheetGroup: pillSheetGroup,
              didBeginRestDuration: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(
                      seconds: 2,
                    ),
                    content: Text("服用お休みを開始しました"),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ],
      ),
    );
  }
}
