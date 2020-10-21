import 'package:Pilll/theme/color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class PostDiaryPage extends StatelessWidget {
  final DateTime date;
  const PostDiaryPage({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        backgroundColor: PilllColors.background,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateTimeFormatter.yearAndMonthAndDay(date)),
          ],
        ),
      ),
    );
  }
}
