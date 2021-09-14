import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_pill_sheet_list.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
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
  late int selectedPillSheetPageIndex;
  late int selectedPillMarkNumberIntoPillSheet;

  @override
  void initState() {
    super.initState();
    selectedPillSheetPageIndex = widget.activedPillSheet.groupIndex;
    selectedPillMarkNumberIntoPillSheet =
        _pillNumberIntoPillSheet(widget.activedPillSheet.groupIndex);
  }

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
          child: Center(
            child: Stack(
              children: [
                ListView(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "今日(${_today()})\n飲む・飲んだピルの番号をタップ",
                      style: FontType.sBigTitle.merge(TextColorStyle.main),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 56),
                    Center(
                      child: SettingTodayPillNumberPillSheetList(
                        pillSheetTypes: widget.pillSheetGroup.pillSheets
                            .map((e) => e.pillSheetType)
                            .toList(),
                        selectedPageIndex: selectedPillSheetPageIndex,
                        selectedTodayPillNumberIntoPillSheet:
                            selectedPillMarkNumberIntoPillSheet,
                        markSelected: (pageIndex, pillNumberIntoPillSheet) {
                          setState(() {
                            this.selectedPillSheetPageIndex = pageIndex;
                            this.selectedPillMarkNumberIntoPillSheet =
                                pillNumberIntoPillSheet;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PrimaryButton(
                        onPressed: () {
                          widget.store.modifyBeginingDate(
                            pageIndex: selectedPillSheetPageIndex,
                            pillNumberIntoPillSheet:
                                selectedPillMarkNumberIntoPillSheet,
                          );
                          Navigator.of(context).pop();
                        },
                        text: "変更する",
                      ),
                      SizedBox(height: 35),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _today() {
    return "${DateTimeFormatter.slashYearAndMonthAndDay(DateTime.now())}(${DateTimeFormatter.weekday(DateTime.now())})";
  }

  int _pillNumberIntoPillSheet(int pageIndex) {
    final pillSheetTypes =
        widget.pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();
    final _pastedTotalCount =
        pastedTotalCount(pillSheetTypes: pillSheetTypes, pageIndex: pageIndex);
    if (_pastedTotalCount >= widget.activedPillSheet.todayPillNumber) {
      return widget.activedPillSheet.todayPillNumber;
    }
    return widget.activedPillSheet.todayPillNumber - _pastedTotalCount;
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
