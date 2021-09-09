import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/template/pill_sheet_type_setting/pill_sheet_type_select_body_template.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class InitialSettingPillSheetGroupSelectPillSheetTypePage
    extends StatelessWidget {
  final PillSheetType? pillSheetType;
  final Function(PillSheetType) onSelect;

  const InitialSettingPillSheetGroupSelectPillSheetTypePage(
      {Key? key, required this.pillSheetType, required this.onSelect})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          child: Column(
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Container(
                child: PillSheetTypeSelectBodyTemplate(
                  doneButton: null,
                  signinButton: null,
                  onSelect: onSelect,
                  selectedPillSheetType: pillSheetType,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void showInitialSettingPillSheetGroupSelectPillSheetTypePage({
  required BuildContext context,
  required final PillSheetType? pillSheetType,
  required final Function(PillSheetType) onSelect,
}) {
  analytics.setCurrentScreen(
      screenName: "InitialSettingPillSheetGroupSelectPillSheetTypePage");
  showModalBottomSheet(
    context: context,
    builder: (context) => InitialSettingPillSheetGroupSelectPillSheetTypePage(
      pillSheetType: pillSheetType,
      onSelect: onSelect,
    ),
  );
}
