import 'package:Pilll/main/calendar/calculator.dart';
import 'package:Pilll/main/calendar/calendar.dart';
import 'package:Pilll/main/calendar/calendar_help.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalendarCard extends StatelessWidget {
  final DateTime date;

  const CalendarCard({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          _header(context),
          Calendar(
            calculator: Calculator(date),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 64),
      child: Row(
        children: [
          SizedBox(width: 16),
          Text(
            DateTimeFormatter.yearAndMonth(date),
            textAlign: TextAlign.left,
            style: FontType.cardHeader.merge(TextColorStyle.noshime),
          ),
          Spacer(),
          IconButton(
            icon: SvgPicture.asset("images/help.svg"),
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => CalendarHelpPage(),
              ));
            },
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
