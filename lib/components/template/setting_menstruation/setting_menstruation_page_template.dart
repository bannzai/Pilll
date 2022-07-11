import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_dynamic_description.dart';
import 'package:pilll/components/template/setting_menstruation/setting_menstruation_pill_sheet_list.dart';
import 'package:flutter/material.dart';

class SettingMenstruationPageTemplate extends StatelessWidget {
  final String title;
  final SettingMenstruationPillSheetList pillSheetList;
  final SettingMenstruationDynamicDescription dynamicDescription;
  final PrimaryButton? doneButton;

  const SettingMenstruationPageTemplate({
    Key? key,
    required this.title,
    required this.pillSheetList,
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 24),
                  Text(
                    "生理がはじまるピル番号をタップ",
                    style: FontType.sBigTitle.merge(TextColorStyle.main),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 59),
                  pillSheetList,
                  const SizedBox(height: 24),
                  dynamicDescription,
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (doneButton != null) ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  doneButton,
                  const SizedBox(height: 35),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
