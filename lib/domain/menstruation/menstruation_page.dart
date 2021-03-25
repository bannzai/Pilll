import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class MenstruationPage extends StatefulWidget {
  @override
  MenstruationPageState createState() => MenstruationPageState();
}

class MenstruationPageState extends State<MenstruationPage> {
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        actions: [
          AppBarTextActionButton(onPressed: () {}, text: "今日"),
        ],
        title: SizedBox(
          child: Text(
            DateTimeFormatter.jaMonth(today()),
            style: TextStyle(color: TextColor.black),
          ),
        ),
        backgroundColor: PilllColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                  height: 62,
                  color: PilllColors.white,
                  child: ListView.builder(
                    itemBuilder: (context, int) {
return _Tile(day: day, isToday: isToday, weekday: weekday, onTap: onTap)
                  },
                  itemCount: Weekday.values.length,
                  )

            ],
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final int day;
  final bool isToday;
  final Weekday weekday;
  final VoidCallback? onTap;

  const _Tile({
    Key? key,
    required this.day,
    required this.isToday,
    required this.weekday,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      "$day",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: onTap == null
            ? weekday.weekdayColor().withAlpha((255 * 0.4).floor())
            : weekday.weekdayColor(),
      ).merge(FontType.gridElement),
    ));
  }
}
