import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/setting.codegen.dart';

class DisplayNumberSetting extends HookConsumerWidget {
  final RecordPageStore store;
  final RecordPageState state;

  const DisplayNumberSetting({
    Key? key,
    required this.store,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillSheetGroup = state.pillSheetGroup;
    if (pillSheetGroup == null ||
        state.appearanceMode != PillSheetAppearanceMode.sequential) {
      return Container();
    }

    final estimatedEndPillNumber = pillSheetGroup.estimatedEndPillNumber;
    final textFieldController =
        useTextEditingController(text: "${estimatedEndPillNumber + 1}");

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
                fontWeight: FontWeight.w400,
                color: TextColor.main,
              ),
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: 42,
              height: 40,
              child: TextField(
                style: TextStyle(
                  color: TextColor.darkGray,
                  fontSize: 15,
                  fontFamily: FontFamily.number,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                controller: textFieldController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  fillColor: PilllColors.mat,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 8),
                ),
                onChanged: (text) {
                  // TODO:
                },
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              "日目からスタート",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: TextColor.main,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "前回のシートの最後：$estimatedEndPillNumber",
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: TextColor.main,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
