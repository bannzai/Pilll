import 'package:Pilll/main/components/pill/pill_mark_model.dart';
import 'package:Pilll/main/components/pill/pill_sheet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum PillMarkState {
  none,
  notTaken,
  todo,
  done,
}

class PillMark extends StatelessWidget {
  final int number;
  int get index => number - 1;
  const PillMark({
    Key key,
    @required this.number,
  }) : super(key: key);

  PillMarkModel model(BuildContext context) {
    return Provider.of<PillSheetModel>(context).marks[index];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 20,
        height: 20,
        child: Center(
          child: model(context).image(),
        ),
        decoration: BoxDecoration(
          color: model(context).color(),
          shape: BoxShape.circle,
        ),
      ),
      onTap: () {
        Provider.of<PillSheetModel>(context, listen: false).number = number;
      },
    );
  }
}
