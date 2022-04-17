import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

const _defaultBegin = 3;
const _defaultEnd = 120;

class DisplayNumberSettingSheet extends HookConsumerWidget {
  final DisplayNumberSetting? offsetPillNumber;
  final RecordPageStore store;

  DisplayNumberSettingSheet({
    required this.offsetPillNumber,
    required this.store,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final begin = useState(offsetPillNumber?.beginPillNumber ?? _defaultBegin);
    final end = useState(offsetPillNumber?.endPillNumber ?? _defaultEnd);
    final beginTextFieldController =
        useTextEditingController(text: "${begin.value}");
    final endTextFieldController =
        useTextEditingController(text: "${end.value}");

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: PilllColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "表示する番号を調整できます",
            style: TextStyle(
              color: TextColor.main,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(maxWidth: 60),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: PilllColors.primary),
                      ),
                      counter: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "1番→${begin.value}番",
                            style: TextStyle(
                              fontFamily: FontFamily.japanese,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: TextColor.darkGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    onChanged: (_begin) {
                      try {
                        begin.value = int.parse(_begin);
                        store.setDisplayNumberSettingBegin(begin.value);
                      } catch (_) {}
                    },
                    controller: beginTextFieldController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(width: 10),
                  const Text("から始める"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(maxWidth: 60),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: PilllColors.primary),
                      ),
                      counter: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${end.value + 1}番→1番",
                            style: TextStyle(
                              fontFamily: FontFamily.japanese,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: TextColor.darkGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    onChanged: (_end) {
                      try {
                        end.value = int.parse(_end);
                        store.setDisplayNumberSettingEnd(end.value);
                      } catch (_) {}
                    },
                    controller: endTextFieldController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(width: 10),
                  const Text("を番号の最後にする"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
