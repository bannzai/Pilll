import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';

class DisplayNumberSetting extends StatelessWidget {
  final RecordPageStore store;
  final RecordPageState state;

  const DisplayNumberSetting({
    Key? key,
    required this.store,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pillSheetGroup = state.pillSheetGroup;
    if (pillSheetGroup == null ||
        state.appearanceMode != PillSheetAppearanceMode.sequential) {
      return Container();
    }

    final estimatedEndPillNumber = pillSheetGroup.estimatedEndPillNumber;
    // TODO:
    final textFieldController = useTextEditingController(text: "111");
    // TODO:
    final number = 121;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "服用",
              style: TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
            TextField(
              controller: textFieldController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: (text) {
                // TODO:
              },
            ),
            const Text(
              "日目からスタート",
              style: TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "前回のシートの最後：$number",
              style: const TextStyle(
                  fontFamily: FontFamily.japanese,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
