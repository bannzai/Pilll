import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:pilll/features/localizations/l.dart';

class PickerToolbar extends StatelessWidget {
  final VoidCallback done;
  final VoidCallback cancel;

  const PickerToolbar({super.key, required this.done, required this.cancel});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CupertinoButton(
            onPressed: () {
              cancel();
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 5.0,
            ),
            child: Text(
              L.cancel,
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.primary,
              ),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              done();
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 5.0,
            ),
            child: Text(
              L.completed,
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: TextColor.primary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
