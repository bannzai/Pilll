import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_type_column.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilll/signin/signin_sheet.dart';
import 'package:pilll/signin/signin_sheet_state.dart';

class PillSheetTypeSelectPageLayout extends StatelessWidget {
  final String title;
  final PrimaryButton? doneButton;
  final Widget? signinWidget;
  final PillSheetType? selectedPillSheetType;
  final void Function(PillSheetType type) onSelect;

  final bool backButtonIsHidden;

  const PillSheetTypeSelectPageLayout({
    Key? key,
    required this.title,
    required this.doneButton,
    required this.signinWidget,
    required this.backButtonIsHidden,
    required this.onSelect,
    required this.selectedPillSheetType,
  }) : super(key: key);

  @override
  Scaffold build(BuildContext context) {
    final doneButton = this.doneButton;
    final signinWidget = this.signinWidget;
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
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 24),
            Text("飲んでいるピルシートのタイプはどれ？",
                style: FontType.sBigTitle.merge(TextColorStyle.main)),
            SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                padding: EdgeInsets.only(left: 34, right: 34),
                childAspectRatio: PillSheetTypeColumnConstant.aspectRatio,
                crossAxisCount: 2,
                children: [
                  ...PillSheetType.values.map((e) => _pillSheet(e)).toList(),
                ],
              ),
            ),
            SizedBox(height: 10),
            if (doneButton != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: doneButton,
              ),
            if (signinWidget != null) ...[
              SizedBox(height: 20),
              signinWidget,
            ],
            SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _pillSheet(PillSheetType type) {
    return GestureDetector(
      onTap: () {
        onSelect(type);
      },
      child: PillSheetTypeColumn(
        pillSheetType: type,
        selected: selectedPillSheetType == type,
      ),
    );
  }
}

extension PillSheetTypeSelectPageRoute on PillSheetTypeSelectPageLayout {
  static Route<dynamic> route({
    required String title,
    required bool backButtonIsHidden,
    required void Function(PillSheetType type) selected,
    required VoidCallback? done,
    required String doneButtonText,
    required PillSheetType selectedPillSheetType,
    required Function(LinkAccountType)? signinAccount,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "PillSheetTypeSelectPage"),
      builder: (_) => PillSheetTypeSelectPageLayout(
        title: title,
        backButtonIsHidden: backButtonIsHidden,
        onSelect: selected,
        done: done,
        doneButtonText: doneButtonText,
        selectedPillSheetType: selectedPillSheetType,
        signinAccount: signinAccount,
      ),
    );
  }
}
