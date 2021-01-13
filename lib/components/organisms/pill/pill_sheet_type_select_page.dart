import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/domain/initial_setting/pill_sheet.dart';
import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillSheetTypeSelectPage extends StatelessWidget {
  final String title;
  final bool backButtonIsHidden;
  final void Function(PillSheetType type) selected;
  final VoidCallback done;
  final String doneButtonText;
  final PillSheetType selectedPillSheetType;

  const PillSheetTypeSelectPage({
    Key key,
    @required this.title,
    @required this.backButtonIsHidden,
    @required this.selected,
    @required this.done,
    @required this.doneButtonText,
    @required this.selectedPillSheetType,
  }) : super(key: key);

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: backButtonIsHidden
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
        title: Text(
          title,
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 24),
                Text("飲んでいるピルのタイプはどれ？",
                    style: FontType.sBigTitle.merge(TextColorStyle.main)),
                SizedBox(height: 24),
                Container(
                  height: 461,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        PillSheetType.values.map((e) => _pillSheet(e)).toList(),
                  ),
                ),
                Spacer(),
                if (done != null)
                  PrimaryButton(
                    text: doneButtonText,
                    onPressed: done,
                  ),
                SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pillSheet(PillSheetType type) {
    return GestureDetector(
      onTap: () {
        selected(type);
      },
      child: PillSheet(
        pillSheetType: type,
        selected: selectedPillSheetType == type,
      ),
    );
  }
}

extension PillSheetTypeSelectPageRoute on PillSheetTypeSelectPage {
  static Route<dynamic> route({
    @required String title,
    @required bool backButtonIsHidden,
    @required void Function(PillSheetType type) selected,
    @required VoidCallback done,
    @required String doneButtonText,
    @required PillSheetType selectedPillSheetType,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "PillSheetTypeSelectPage"),
      builder: (_) => PillSheetTypeSelectPage(
        title: title,
        backButtonIsHidden: backButtonIsHidden,
        selected: selected,
        done: done,
        doneButtonText: doneButtonText,
        selectedPillSheetType: selectedPillSheetType,
      ),
    );
  }
}
