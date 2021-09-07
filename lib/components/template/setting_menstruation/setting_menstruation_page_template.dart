import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_dynamic_description.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_pill_sheet_list.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class SettingMenstruationPageConstants {
  static final List<String> durationList = [
    "-",
    ...List<String>.generate(7, (index) => (index + 1).toString())
  ];
}

class SettingMenstruationPageModel {
  int selectedFromMenstruation;
  int selectedDurationMenstruation;
  PillSheetType pillSheetType;

  SettingMenstruationPageModel({
    required this.selectedFromMenstruation,
    required this.selectedDurationMenstruation,
    required this.pillSheetType,
  });
}

class SettingMenstruationPage extends StatelessWidget {
  final String title;
  final int pillSheetPageCount;
  final bool isOnSequenceAppearance;
  final SettingMenstruationPillSheetList pillSheetList;
  final SettingPillSheetView pillSheetView;
  final SettingMenstruationDynamicDescription dynamicDescription;
  final PrimaryButton? doneButton;

  const SettingMenstruationPage({
    Key? key,
    required this.title,
    required this.pillSheetPageCount,
    required this.isOnSequenceAppearance,
    required this.pillSheetList,
    required this.pillSheetView,
    required this.dynamicDescription,
    required this.doneButton,
  }) : super(key: key);

  @override
  Scaffold build(BuildContext context) {
    final doneButton = this.doneButton;
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          this.title,
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, viewport) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: viewport.maxHeight),
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 24),
                    Text(
                      "生理がはじまるピル番号をタップ",
                      style: FontType.sBigTitle.merge(TextColorStyle.main),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    () {
                      if (isOnSequenceAppearance)
                        return pillSheetList;
                      else
                        return pillSheetView;
                    }(),
                    SizedBox(height: 24),
                    dynamicDescription,
                    if (doneButton != null) ...[
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(minHeight: 32),
                        ),
                      ),
                      doneButton,
                      SizedBox(height: 35),
                    ]
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

extension SettingMenstruationPageRoute on SettingMenstruationPage {
  static Route<dynamic> route({
    required String title,
    required String? doneText,
    required VoidCallback? done,
    required int pillSheetTotalCount,
    required int pillSheetPageCount,
    required SettingMenstruationPageModel model,
    required void Function(int from) fromMenstructionDidDecide,
    required void Function(int duration) durationMenstructionDidDecide,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "SettingMenstruationPage"),
      builder: (_) => SettingMenstruationPage(
        title: title,
        doneText: doneText,
        done: done,
        pillSheetTotalCount: pillSheetTotalCount,
        pillSheetPageCount: pillSheetPageCount,
        model: model,
        fromMenstructionDidDecide: fromMenstructionDidDecide,
        durationMenstructionDidDecide: durationMenstructionDidDecide,
      ),
    );
  }
}
