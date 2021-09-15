import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/template/pill_sheet_type_setting/pill_sheet_type_select_body_template.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class PillSheetGroupSelectPillSheetTypePage extends HookWidget {
  final PillSheetType? pillSheetType;
  final Function(PillSheetType) onSelect;

  const PillSheetGroupSelectPillSheetTypePage(
      {Key? key, required this.pillSheetType, required this.onSelect})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          child: ListView(
            controller: scrollController,
            children: [
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 16),
                  Text(
                    "ピルの種類を選択",
                    style: TextStyle(
                      color: TextColor.main,
                      fontSize: 20,
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              PillSheetTypeSelectBodyTemplate(
                onSelect: (e) {
                  Navigator.of(context).pop();
                  onSelect(e);
                },
                selectedPillSheetType: pillSheetType,
              ),
              SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }
}

void showSettingPillSheetGroupSelectPillSheetTypePage({
  required BuildContext context,
  required final PillSheetType? pillSheetType,
  required final Function(PillSheetType) onSelect,
}) {
  analytics.setCurrentScreen(
      screenName: "PillSheetGroupSelectPillSheetTypePage");
  showModalBottomSheet(
    context: context,
    builder: (context) => PillSheetGroupSelectPillSheetTypePage(
      pillSheetType: pillSheetType,
      onSelect: onSelect,
    ),
  );
}
