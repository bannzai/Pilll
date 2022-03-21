import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/entity/initial_setting_pill_category_type.dart';

class PillSheetCountSheet extends StatelessWidget {
  final InitialSettingPillCategoryType pillCategoryType;
  final InitialSettingStateStore store;

  const PillSheetCountSheet(
      {Key? key, required this.pillCategoryType, required this.store})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      height: 235,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("images/notch.svg"),
          const SizedBox(height: 24),
          const Text("処方されるシート数は？",
              style: TextStyle(
                color: TextColor.main,
                fontSize: 16,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(6, (index) => index + 1).map((number) {
                return GestureDetector(
                  onTap: () {
                    analytics.logEvent(
                        name: "i_s_pill_sheet_count_sheet_selected",
                        parameters: {
                          "pill_sheet_count": number,
                          "pill_category_type": pillCategoryType.toString(),
                        });
                    Navigator.of(context).pop();

                    store.selectedPillCategoryType(pillCategoryType, number);

                    Navigator.of(context)
                        .push(InitialSettingPillSheetGroupPageRoute.route());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.5, vertical: 11),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: PilllColors.secondary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(46),
                    ),
                    child: Text("$number",
                        style: const TextStyle(
                          color: TextColor.main,
                          fontSize: 16,
                          fontFamily: FontFamily.number,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}

void showPillSheetCountSheet(BuildContext context,
    {required InitialSettingPillCategoryType pillCategoryType,
    required InitialSettingStateStore store}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => PillSheetCountSheet(
      pillCategoryType: pillCategoryType,
      store: store,
    ),
  );
}
