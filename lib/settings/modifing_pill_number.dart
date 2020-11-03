import 'package:Pilll/application/components/pill/pill_sheet.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class ModifingPillNumberPage extends StatefulWidget {
  final PillMarkTypeBuilder pillMarkTypeBuilder;
  final PillMarkSelected markSelected;

  const ModifingPillNumberPage({
    Key key,
    @required this.pillMarkTypeBuilder,
    @required this.markSelected,
  }) : super(key: key);

  @override
  _ModifingPillNumberPageState createState() => _ModifingPillNumberPageState();
}

class _ModifingPillNumberPageState extends State<ModifingPillNumberPage> {
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
                pillMarkTypeBuilder: widget.pillMarkTypeBuilder,
                enabledMarkAnimation: null,
                markSelected: (number) {
                  setState(() => widget.markSelected(number));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _today() => DateTimeFormatter.slashYearAndMonthAndDay(DateTime.now());
}
