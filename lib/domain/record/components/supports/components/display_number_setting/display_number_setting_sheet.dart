import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

class DisplayNumberSettingSheet extends HookConsumerWidget {
  final PillSheetGroup? beforePillSheetGroup;
  final PillSheetGroup pillSheetGroup;
  final RecordPageStore store;

  DisplayNumberSettingSheet({
    required this.beforePillSheetGroup,
    required this.pillSheetGroup,
    required this.store,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final begin =
        useState(pillSheetGroup.displayNumberSetting?.beginPillNumber ?? 1);
    final end = useState(pillSheetGroup.displayNumberSetting?.endPillNumber ??
        pillSheetGroup.estimatedEndPillNumber);

    final beginTextFieldController =
        useTextEditingController(text: "${begin.value}");
    final endTextFieldController =
        useTextEditingController(text: "${end.value}");

    final beforePillSheetGroup = this.beforePillSheetGroup;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: PilllColors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                const Text(
                  "シートの服用日数を変更",
                  style: TextStyle(
                    color: TextColor.main,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                const Text(
                  "変更",
                  style: TextStyle(
                    color: TextColor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.japanese,
                  ),
                )
              ]),
              const SizedBox(height: 24),
              Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                              "images/begin_display_number_setting.svg"),
                          const SizedBox(width: 4),
                          const Text(
                            "服用日数の始まり",
                            style: TextStyle(
                              fontFamily: FontFamily.japanese,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: TextColor.main,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
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
                              controller: beginTextFieldController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
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
                                  begin.value = int.parse(text);
                                  store.setBeginDisplayPillNumber(begin.value);
                                } catch (_) {}
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
                      if (beforePillSheetGroup != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "前回のシートの最後：${beforePillSheetGroup.estimatedEndPillNumber}",
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
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

void showDisplayNumberSettingSheet(
  BuildContext context, {
  required PillSheetGroup? beforePillSheetGroup,
  required PillSheetGroup pillSheetGroup,
  required RecordPageStore store,
}) {
  analytics.setCurrentScreen(screenName: "DisplayNumberSettingSheet");
  showModalBottomSheet(
    context: context,
    builder: (context) => DisplayNumberSettingSheet(
      beforePillSheetGroup: beforePillSheetGroup,
      pillSheetGroup: pillSheetGroup,
      store: store,
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
