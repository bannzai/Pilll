import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/cupertino.dart';

class PickerToolbar extends StatelessWidget {
  final VoidCallback done;
  final VoidCallback cancel;

  const PickerToolbar({Key? key, required this.done, required this.cancel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CupertinoButton(
            child: Text('キャンセル',
                style: FontType.assisting.merge(TextColorStyle.primary)),
            onPressed: () {
              cancel();
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 5.0,
            ),
          ),
          CupertinoButton(
            child:
                Text('完了', style: FontType.done.merge(TextColorStyle.primary)),
            onPressed: () {
              done();
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 5.0,
            ),
          )
        ],
      ),
    );
  }
}
