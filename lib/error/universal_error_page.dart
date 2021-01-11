import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/entity/user_error.dart';
import 'package:flutter/material.dart';

class UniversalErrorPage extends StatelessWidget {
  final UserDisplayedError error;
  final Widget child;

  const UniversalErrorPage({Key key, @required this.error, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (this.error == null && this.child != null) {
      return child;
    }
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "images/universal_error.png",
                width: 200,
                height: 190,
              ),
              SizedBox(height: 25),
              Text(error.toString(),
                  style: FontType.assisting.merge(TextColorStyle.main)),
            ],
          ),
        ),
      ),
    );
  }
}
