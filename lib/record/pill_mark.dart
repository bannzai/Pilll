import 'package:Pilll/record/pill_mark_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum PillMarkState {
  none,
  notTaken,
  todo,
  done,
}

class PillMark extends StatelessWidget {
  final PillMarkModel model;
  const PillMark({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      child: Center(child: model.image()),
      decoration: BoxDecoration(
        color: model.color(),
        shape: BoxShape.circle,
      ),
    );
  }
}
