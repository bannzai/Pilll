import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_pill_sheet_list.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class ModifingPillNumberPage extends StatefulWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;
  final SettingStateStore store;

  const ModifingPillNumberPage({
    Key? key,
    required this.pillSheetGroup,
    required this.activedPillSheet,
    required this.store,
  }) : super(key: key);

  @override
  _ModifingPillNumberPageState createState() => _ModifingPillNumberPageState();
}

class _ModifingPillNumberPageState extends State<ModifingPillNumberPage> {
  int? selectedPillSheetPageIndex;
  int? selectedPillMarkNumberIntoPillSheet;

  @override
  Widget build(BuildContext context) {
    final selectedPillSheetPageIndex = this.selectedPillSheetPageIndex;
    final selectedPillMarkNumberIntoPillSheet =
        this.selectedPillMarkNumberIntoPillSheet;
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "ピル番号の変更",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 32),
                child: Text("今日${_today()}に飲む・飲んだピル番号をタップ",
                    style: FontType.sBigTitle.merge(TextColorStyle.main)),
              ),
              SizedBox(height: 56),
              Center(
                child: SettingTodayPillNumberPillSheetList(
                  pillSheetGroup: widget.pillSheetGroup,
                  activedPillSheet: widget.activedPillSheet,
                  store: widget.store,
                ),
              ),
              SizedBox(height: 20),
              PrimaryButton(
                onPressed: selectedPillMarkNumberIntoPillSheet != null &&
                        selectedPillSheetPageIndex != null
                    ? () => widget.store.modifyBeginingDate(
                          pageIndex: selectedPillSheetPageIndex,
                          pillNumberIntoPillSheet:
                              selectedPillMarkNumberIntoPillSheet,
                        )
                    : null,
                text: "変更する",
              )
            ],
          ),
        ),
      ),
    );
  }

  String _today() {
    return "${DateTimeFormatter.slashYearAndMonthAndDay(DateTime.now())}(${DateTimeFormatter.weekday(DateTime.now())})";
  }
}

extension ModifingPillNumberPageRoute on ModifingPillNumberPage {
  static Route<dynamic> route({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
    required SettingStateStore store,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "ModifingPillNumberPage"),
      builder: (_) => ModifingPillNumberPage(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: activedPillSheet,
        store: store,
      ),
    );
  }
}
