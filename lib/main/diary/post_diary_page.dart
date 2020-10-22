import 'package:Pilll/theme/color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostDiaryPage extends StatelessWidget {
  final DateTime date;
  const PostDiaryPage({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateTimeFormatter.yearAndMonthAndDay(date)),
            _physicalConditions(),
            Text("体調詳細"),
            _conditions(),
          ],
        ),
      ),
    );
  }

  Widget _physicalConditions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("体調"),
        Spacer(),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: PilllColors.divider,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              IconButton(
                  icon: SvgPicture.asset("images/laugh.svg"), onPressed: null),
              Container(
                  height: 48,
                  child: VerticalDivider(width: 1, color: PilllColors.divider)),
              IconButton(
                  icon: SvgPicture.asset("images/angry.svg"), onPressed: null),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _conditions() {
    // TODO: move to firestore
    final dataSource = [
      "頭痛",
      "腹痛",
      "吐き気",
      "貧血",
      "下痢",
      "便秘",
      "ほてり",
      "眠気",
      "腰痛",
      "動悸",
      "不正出血",
      "食欲不振",
    ];
    return Wrap(
      spacing: 10,
      children: dataSource.map((e) => Chip(label: Text(e))).toList(),
    );
  }
}
