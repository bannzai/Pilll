import 'package:flutter/material.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/domain/record/components/supports/components/appearance_mode/switching_appearance_mode.dart';
import 'package:pilll/domain/record/components/supports/components/display_number_setting/display_number_setting_button.dart';
import 'package:pilll/domain/record/components/supports/components/rest_duration/begin_manual_rest_duration_button.dart';
import 'package:pilll/domain/record/components/supports/components/rest_duration/end_manual_rest_duration_button.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';

class RecordPagePillSheetSupportActions extends StatelessWidget {
  final RecordPageStore store;
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;
  final Setting setting;

  const RecordPagePillSheetSupportActions({
    Key? key,
    required this.store,
    required this.pillSheetGroup,
    required this.activedPillSheet,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RestDuration? restDuration = activedPillSheet.activeRestDuration;

    return Container(
      width: PillSheetViewLayout.width,
      child: Row(
        children: [
          SwitchingAppearanceMode(
              store: store, mode: setting.pillSheetAppearanceMode),
          const Spacer(),
          if (setting.pillSheetAppearanceMode ==
              PillSheetAppearanceMode.sequential) ...[
            DisplayNumberSettingButton(
              pillSheetGroup: pillSheetGroup,
              store: store,
            ),
          ],
          const Spacer(),
          if (restDuration != null) ...[
            EndManualRestDurationButton(
              restDuration: restDuration,
              activedPillSheet: activedPillSheet,
              pillSheetGroup: pillSheetGroup,
              store: store,
              didEndRestDuration: () {
                showDialog(
                  context: context,
                  builder: (context) => EndRestDurationModal(
                    pillSheetGroup: pillSheetGroup,
                    store: store,
                  ),
                );
              },
            ),
          ] else ...[
            BeginManualRestDurationButton(
              appearanceMode: setting.pillSheetAppearanceMode,
              activedPillSheet: activedPillSheet,
              pillSheetGroup: pillSheetGroup,
              store: store,
              didBeginRestDuration: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(
                      seconds: 2,
                    ),
                    content: Text("休薬期間が始まりました"),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
