import 'package:Pilll/color.dart';
import 'package:flutter/widgets.dart';

class PillMark extends StatelessWidget {
  const PillMark({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: PilllColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
