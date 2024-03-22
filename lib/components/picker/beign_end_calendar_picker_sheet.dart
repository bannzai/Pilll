import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/picker/picker_toolbar.dart';

class BeginEndCalendarPickerSheet extends HookWidget {
  final String title;
  final String? beginDateTimeTitle;
  final String? endDateTimeTitle;
  final DateTime? initialBeginDateTime;
  final DateTime? initialEndDateTime;
  final void Function(DateTime begin, DateTime end) done;

  const BeginEndCalendarPickerSheet({
    Key? key,
    required this.title,
    required this.beginDateTimeTitle,
    required this.endDateTimeTitle,
    required this.initialBeginDateTime,
    required this.initialEndDateTime,
    required this.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedBeginDateTime = useState(initialBeginDateTime);
    final selectedEndDateTime = useState(initialEndDateTime);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PickerToolbar(
          done: (() {
            done(selectedBeginDateTime, selectedEndDateTime);
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
                initialDateTime: selectedBeginDateTime,
                mode: CupertinoDatePickerMode.dateAndTime,
                onDateTimeChanged: (DateTime value) {
                  selectedBeginDateTime = value;
                },
              )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CupertinoDatePicker(
                use24hFormat: true,
                initialDateTime: selectedEndDateTime,
                mode: CupertinoDatePickerMode.dateAndTime,
                onDateTimeChanged: (DateTime value) {
                  selectedEndDateTime = value;
                },
              )),
        ),
      ],
    );
  }
}
