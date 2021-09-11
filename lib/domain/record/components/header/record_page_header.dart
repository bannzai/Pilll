import 'package:flutter/cupertino.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/components/header/take_today.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';

abstract class RecordPageHeaderrmationConst {
  static final double height = 130;
}

class RecordPageHeaderrmation extends StatelessWidget {
  final DateTime today;
  final PillSheetGroup? pillSheetGroup;
  final RecordPageStore store;
  const RecordPageHeaderrmation({
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
      height: RecordPageHeaderrmationConst.height,
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
                      _showBeginDatePicker(context, pillSheetGroup, store);
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

  _showBeginDatePicker(BuildContext context, PillSheetGroup? pillSheetGroup,
      RecordPageStore store) {
    if (pillSheetGroup == null) {
      return;
    }
    var selectedTodayPillNumber = pillSheetGroup.serializedTodayPillNumber;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                final _selectedTodayPillNumber = selectedTodayPillNumber;
                if (_selectedTodayPillNumber == null) {
                  Navigator.pop(context);
                  return;
                }
                store.modifyBeginingDate(_selectedTodayPillNumber);
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
                  children: List.generate(
                      pillSheetGroup.totalPillCountIntoGroup,
                      (index) => Text("${index + 1}")),
                  onSelectedItemChanged: (index) {
                    selectedTodayPillNumber = index + 1;
                  },
                  scrollController: FixedExtentScrollController(
                    initialItem: () {
                      final _selectedTodayPillNumber = selectedTodayPillNumber;
                      if (_selectedTodayPillNumber == null) {
                        return 0;
                      }
                      return _selectedTodayPillNumber - 1;
                    }(),
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
