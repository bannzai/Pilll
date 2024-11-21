import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/formatter/text_input_formatter.dart';

class DisplayNumberSetting extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final Function(PillSheetGroupDisplayNumberSetting) onChanged;

  const DisplayNumberSetting({
    super.key,
    required this.pillSheetGroup,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!pillSheetGroup.pillSheetAppearanceMode.isSequential) {
      return Container();
    }

    final estimatedEndPillNumber = pillSheetGroup.sequentialEstimatedEndPillNumber;
    final beginDisplayPillNumber = useState(estimatedEndPillNumber + 1);
    final textFieldController = useTextEditingController(text: '${beginDisplayPillNumber.value}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '服用',
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
                style: const TextStyle(
                  color: TextColor.darkGray,
                  fontSize: 15,
                  fontFamily: FontFamily.number,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                controller: textFieldController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  AppTextFieldFormatter.greaterThanZero,
                ],
                decoration: const InputDecoration(
                  fillColor: PilllColors.mat,
                  filled: true,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 8),
                ),
                onChanged: (text) {
                  try {
                    analytics.logEvent(name: 'on_changed_display_number', parameters: {'text': text});
                    beginDisplayPillNumber.value = int.parse(text);
                    onChanged(PillSheetGroupDisplayNumberSetting(beginPillNumber: beginDisplayPillNumber.value));
                  } catch (_) {}
                },
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              '番からスタート',
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
              '前回のシートの最後：$estimatedEndPillNumber番',
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
