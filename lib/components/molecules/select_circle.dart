import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectCircle extends StatelessWidget {
  final bool isSelected;

  const SelectCircle({Key? key, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset("images/circle.line.svg")),
        if (isSelected)
          Positioned(
              top: 5,
              left: 5,
              width: 10,
              height: 10,
              child: SvgPicture.asset("images/circle.fill.svg")),
      ],
    );
  }
}
