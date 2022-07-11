import 'package:pilll/util/toolbar/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';

class TimePicker extends StatelessWidget {
  final DateTime initialDateTime;
  final void Function(DateTime datetime) done;

  const TimePicker({
    Key? key,
    required this.initialDateTime,
    required this.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedDateTime = initialDateTime;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PickerToolbar(
          done: (() {
            done(selectedDateTime);
          }),
          cancel: (() => Navigator.pop(context)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CupertinoDatePicker(
                use24hFormat: true,
                minuteInterval: 10,
                initialDateTime: selectedDateTime,
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (DateTime value) {
                  selectedDateTime = value;
                },
              )),
        ),
      ],
    );
  }
}
