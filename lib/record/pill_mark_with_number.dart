import 'package:Pilll/color.dart';
import 'package:Pilll/record/pill_mark.dart';
import 'package:flutter/widgets.dart';

class PillMarkWithNumber extends StatelessWidget {
  final int number;
  const PillMarkWithNumber({Key key, this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("$number", style: TextStyle(color: PilllColors.weekday)),
        PillMark(),
      ],
    );
  }
}
