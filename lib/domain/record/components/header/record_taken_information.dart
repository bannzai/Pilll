import 'package:flutter/cupertino.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/components/header/take_today.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';

abstract class RecordTakenInformationConst {
  static final double height = 130;
}

class RecordTakenInformation extends StatelessWidget {
  final DateTime today;
  final PillSheetGroup? pillSheetGroup;
  final RecordPageStore store;
  const RecordTakenInformation({
    Key? key,
    required this.today,
    required this.pillSheetGroup,
    required this.store,
  }) : super(key: key);

  String _formattedToday() => DateTimeFormatter.monthAndDay(this.today);
  String _todayWeekday() => DateTimeFormatter.weekday(this.today);

  @override
  Widget build(BuildContext context) {
    final pillSheet = pillSheetGroup?.activedPillSheet;

    return Container(
      height: RecordTakenInformationConst.height,
      child: Column(
        children: <Widget>[
          SizedBox(height: 34),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _todayWidget(),
              SizedBox(width: 28),
              Container(
                height: 64,
                child: VerticalDivider(
                  width: 10,
                  color: PilllColors.divider,
                ),
              ),
              SizedBox(width: 28),
              TakeToday(
                  pillSheetGroup: pillSheetGroup,
                  onPressed: () {
                    analytics.logEvent(
                        name: "tapped_record_information_header");
                    if (pillSheet != null) {
                      _showBeginDatePicker(context, pillSheet, store);
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Center _todayWidget() {
    return Center(
      child: Text(
        "${_formattedToday()} (${_todayWeekday()})",
        style: FontType.xBigNumber.merge(TextColorStyle.gray),
      ),
    );
  }

  _showBeginDatePicker(
      BuildContext context, PillSheet currentPillSheet, RecordPageStore store) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        var selectedTodayPillNumber = currentPillSheet.todayPillNumber;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                store.modifyBeginingDate(selectedTodayPillNumber);
                Navigator.pop(context);
              }),
              cancel: (() {
                Navigator.pop(context);
              }),
            ),
            Container(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: List.generate(currentPillSheet.typeInfo.totalCount,
                      (index) => Text("${index + 1}")),
                  onSelectedItemChanged: (index) {
                    selectedTodayPillNumber = index + 1;
                  },
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedTodayPillNumber - 1,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
