import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';

class DateAndTimePicker extends StatelessWidget {
  final DateTime initialDateTime;
  final DateTime? maximumDate;
  final void Function(DateTime datetime) done;

  const DateAndTimePicker({
    Key? key,
    required this.initialDateTime,
    this.maximumDate,
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
                initialDateTime: selectedDateTime,
                maximumDate: maximumDate ?? now(),
                mode: CupertinoDatePickerMode.dateAndTime,
                onDateTimeChanged: (DateTime value) {
                  selectedDateTime = value;
                },
              )),
        ),
      ],
    );
  }
}
