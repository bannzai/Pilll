import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostDiaryPage extends StatefulWidget {
  final DateTime date;
  const PostDiaryPage({Key key, this.date}) : super(key: key);

  @override
  _PostDiaryPageState createState() => _PostDiaryPageState();
}

class _PostDiaryPageState extends State<PostDiaryPage> {
  List<String> selectedConditions = [];
  List<String> get dataSource => [
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
            Text(DateTimeFormatter.yearAndMonthAndDay(widget.date)),
            _physicalConditions(),
            Text("体調詳細"),
            _conditions(),
            _sex(),
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
    return Wrap(
      spacing: 10,
      children: dataSource
          .map((e) => ChoiceChip(
                label: Text(e),
                labelStyle: FontType.assisting.merge(
                    selectedConditions.contains(e)
                        ? TextColorStyle.primary
                        : TextColorStyle.darkGray),
                disabledColor: PilllColors.disabledSheet,
                selectedColor: PilllColors.primarySheet,
                selected: selectedConditions.contains(e),
                onSelected: (selected) {
                  setState(() {
                    selectedConditions.contains(e)
                        ? selectedConditions.remove(e)
                        : selectedConditions.add(e);
                  });
                },
              ))
          .toList(),
    );
  }

  Widget _sex() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("sex"),
        SizedBox(width: 80),
        Container(
            padding: EdgeInsets.all(4),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: PilllColors.disabledSheet),
            child: SvgPicture.asset("images/heart.svg",
                color: TextColor.darkGray)),
        Spacer(),
      ],
    );
  }
}
