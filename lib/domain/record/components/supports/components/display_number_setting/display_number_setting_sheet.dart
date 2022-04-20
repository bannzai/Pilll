import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/components/supports/components/display_number_setting/store.dart';

class DisplayNumberSettingSheet extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(displayNumberSettingStateStoreProvider);
    final store = ref.watch(displayNumberSettingStateStoreProvider.notifier);

    final begin = useState(
        state.pillSheetGroup.displayNumberSetting?.beginPillNumber ?? 1);
    final end = useState(
        state.pillSheetGroup.displayNumberSetting?.endPillNumber ??
            state.pillSheetGroup.estimatedEndPillNumber);

    final beginTextFieldController =
        useTextEditingController(text: "${begin.value}");
    final endTextFieldController =
        useTextEditingController(text: "${end.value}");

    final beforePillSheetGroup = state.beforePillSheetGroup;

    final estimatedKeyboardHeight = 216;
    final offset = 24;
    final height = 1 -
        ((estimatedKeyboardHeight - offset) /
            MediaQuery.of(context).size.height);

    return DraggableScrollableSheet(
      initialChildSize: height,
      maxChildSize: height,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: PilllColors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                SecondaryButton(
                  text: "変更",
                  onPressed: () async {
                    await store.modify();
                    Navigator.of(context).pop();
                  },
                )
              ]),
              const SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      if (beforePillSheetGroup != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "前回のシートの最後：${beforePillSheetGroup.estimatedEndPillNumber}日目",
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
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      SvgPicture.asset("images/end_display_number_setting.svg"),
                      const SizedBox(width: 4),
                      const Text(
                        "服用日数の終わり",
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
                          controller: endTextFieldController,
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
                              end.value = int.parse(text);
                              store.setEndDisplayPillNumber(end.value);
                            } catch (_) {}
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "日目に変更",
                        style: TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontSize: 14,
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
        );
      },
    );
  }
}

void showDisplayNumberSettingSheet(
  BuildContext context,
) {
  analytics.setCurrentScreen(screenName: "DisplayNumberSettingSheet");
  showModalBottomSheet(
    context: context,
    builder: (context) => DisplayNumberSettingSheet(),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
