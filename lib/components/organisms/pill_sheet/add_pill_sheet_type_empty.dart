import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/pill_sheet_group_select_pill_sheet_type_page.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class AddPillSheetTypeEmpty extends HookConsumerWidget {
  final Function(PillSheetType) onSelect;

  const AddPillSheetTypeEmpty({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 80),
          SvgPicture.asset("images/empty_pill_sheet_type.svg"),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            child: PrimaryButton(
                onPressed: () async {
                  analytics.logEvent(name: "empty_pill_sheet_type");
                  showSettingPillSheetGroupSelectPillSheetTypePage(
                    context: context,
                    pillSheetType: null,
                    onSelect: (pillSheetType) {
                      onSelect(pillSheetType);
                    },
                  );
                },
                text: "ピルの種類を選ぶ"),
          ),
        ],
      ),
    );
  }
}
