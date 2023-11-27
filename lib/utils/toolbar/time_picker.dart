import 'package:pilll/utils/environment.dart';
import 'package:pilll/utils/toolbar/picker_toolbar.dart';
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
    // TODO: ローカル通知の検証が終わったら10分刻みにする
    var minimumInterval = 10;
    minimumInterval = 1;
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
                minuteInterval: minimumInterval,
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
