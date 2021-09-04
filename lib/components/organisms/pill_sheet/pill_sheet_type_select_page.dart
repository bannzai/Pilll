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

class PillSheetTypeSelectPage extends StatelessWidget {
  final String title;
  final bool backButtonIsHidden;
  final void Function(PillSheetType type) selected;
  final VoidCallback? done;
  final String doneButtonText;
  final PillSheetType? selectedPillSheetType;
  final Function(LinkAccountType)? signinAccount;

  const PillSheetTypeSelectPage({
    Key? key,
    required this.title,
    required this.backButtonIsHidden,
    required this.selected,
    required this.done,
    required this.doneButtonText,
    required this.selectedPillSheetType,
    required this.signinAccount,
  }) : super(key: key);

  @override
  Scaffold build(BuildContext context) {
    final signinAccount = this.signinAccount;
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
            if (done != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: PrimaryButton(
                  text: doneButtonText,
                  onPressed: done,
                ),
              ),
            if (signinAccount != null) ...[
              SizedBox(height: 20),
              SecondaryButton(
                onPressed: () {
                  showSigninSheet(context,
                      SigninSheetStateContext.initialSetting, signinAccount);
                },
                text: "すでにアカウントをお持ちの方はこちら",
              ),
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
        selected(type);
      },
      child: PillSheetTypeColumn(
        pillSheetType: type,
        selected: selectedPillSheetType == type,
      ),
    );
  }
}

extension PillSheetTypeSelectPageRoute on PillSheetTypeSelectPage {
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
      builder: (_) => PillSheetTypeSelectPage(
        title: title,
        backButtonIsHidden: backButtonIsHidden,
        selected: selected,
        done: done,
        doneButtonText: doneButtonText,
        selectedPillSheetType: selectedPillSheetType,
        signinAccount: signinAccount,
      ),
    );
  }
}
