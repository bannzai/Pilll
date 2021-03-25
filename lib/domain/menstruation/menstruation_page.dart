import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
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
        title: Text(
          DateTimeFormatter.jaMonth(today()),
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
