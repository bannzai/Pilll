import 'package:Pilll/model/pill_mark_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillMark extends StatelessWidget {
  final PillMarkType type;
  final VoidCallback tapped;
  const PillMark({
    Key key,
    @required this.type,
    @required this.tapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          width: 20,
          height: 20,
          child: Center(
            child: type.image(),
          ),
          decoration: BoxDecoration(
            color: type.color(),
            shape: BoxShape.circle,
          ),
        ),
        onTap: tapped);
  }
}
