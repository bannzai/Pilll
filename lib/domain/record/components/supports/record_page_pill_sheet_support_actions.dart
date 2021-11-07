import 'package:flutter/material.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/domain/record/components/supports/components/appearance_mode/switching_appearance_mode.dart';
import 'package:pilll/domain/record/components/supports/components/rest_duration/manual_rest_duration_button.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';

class RecordPagePillSheetSupportActions extends StatelessWidget {
  final RecordPageStore store;
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;

  const RecordPagePillSheetSupportActions({
    Key? key,
    required this.store,
    required this.pillSheetGroup,
    required this.activedPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RestDuration? restDuration = activedPillSheet.activeRestDuration;

    return Container(
      width: PillSheetViewLayout.width,
      child: Row(children: [
        SwitchingAppearanceMode(store: store),
        Spacer(),
        if (!pillSheetGroup.hasPillSheetRestDuration)
          ManualRestDurationButton(
              restDuration: restDuration,
              activedPillSheet: activedPillSheet,
              store: store,
              pillSheetGroup: pillSheetGroup),
      ]),
    );
  }
}
