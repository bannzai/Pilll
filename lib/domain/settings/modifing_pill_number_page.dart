import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/organisms/pill/pill_sheet.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

import '../../entity/pill_sheet_type.dart';

class ModifingPillNumberPage extends StatefulWidget {
  final PillSheetType pillSheetType;
  final PillMarkSelected markSelected;

  const ModifingPillNumberPage({
    Key? key,
    required this.pillSheetType,
    required this.markSelected,
  }) : super(key: key);

  @override
  _ModifingPillNumberPageState createState() => _ModifingPillNumberPageState();
}

class _ModifingPillNumberPageState extends State<ModifingPillNumberPage> {
  int? selectedPillMarkNumber;
  @override
  Widget build(BuildContext context) {
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
                child: PillSheet(
                  pillSheetType: widget.pillSheetType,
                  pillMarkTypeBuilder: (number) {
                    if (selectedPillMarkNumber == number) {
                      return PillMarkType.selected;
                    }
                    return PillMarkType.normal;
                  },
                  doneStateBuilder: (_) {
                    return false;
                  },
                  enabledMarkAnimation: null,
                  markSelected: (number) {
                    setState(() => selectedPillMarkNumber = number);
                  },
                ),
              ),
              SizedBox(height: 20),
              PrimaryButton(
                onPressed: selectedPillMarkNumber != null
                    ? () => widget.markSelected(selectedPillMarkNumber!)
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
  static Route<dynamic> route(
      {required PillSheetType pillSheetType,
      required PillMarkSelected markSelected}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "ModifingPillNumberPage"),
      builder: (_) => ModifingPillNumberPage(
          pillSheetType: pillSheetType, markSelected: markSelected),
    );
  }
}
