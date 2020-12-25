import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/components/organisms/pill/pill_sheet.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/entity/pill_mark_type.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class ModifingPillNumberPage extends StatefulWidget {
  final PillMarkSelected markSelected;

  const ModifingPillNumberPage({
    Key key,
    @required this.markSelected,
  }) : super(key: key);

  @override
  _ModifingPillNumberPageState createState() => _ModifingPillNumberPageState();
}

class _ModifingPillNumberPageState extends State<ModifingPillNumberPage> {
  int selectedPillMarkNumber;
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
          "番号変更",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: Container(
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
                  ? () => widget.markSelected(selectedPillMarkNumber)
                  : null,
              text: "変更する",
            )
          ],
        ),
      ),
    );
  }

  String _today() => DateTimeFormatter.slashYearAndMonthAndDay(DateTime.now());
}

extension ModifingPillNumberPageRoute on ModifingPillNumberPage {
  static Route<dynamic> route({@required PillMarkSelected markSelected}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "ModifingPillNumberPage"),
      builder: (_) => ModifingPillNumberPage(markSelected: markSelected),
    );
  }
}
