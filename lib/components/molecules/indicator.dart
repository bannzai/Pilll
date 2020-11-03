import 'package:Pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(PilllColors.primary)),
      ),
    );
  }
}
