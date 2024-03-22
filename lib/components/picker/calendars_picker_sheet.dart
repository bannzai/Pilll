import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class CalendarPickersSheet extends HookWidget {
  final String title;
  final List<Widget> rows;
  final void Function(DateTime begin, DateTime end) done;

  const CalendarPickersSheet({
    Key? key,
    required this.title,
    required this.rows,
    required this.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: TextColor.main,
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w600,
          ),
        ),
        for (final row in rows) ...[
          row,
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class CalendarPickersSheetRow extends HookWidget {
  final String title;
  final DateTime? dateTime;
  final Function(DateTime?) onSelect;

  const CalendarPickersSheetRow({
    super.key,
    required this.title,
    required this.dateTime,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final dateTimeState = useState(this.dateTime);
    final dateTime = dateTimeState.value;

    return Row(
      children: [
        Text(title),
        const Spacer(),
        TextButton(
          onPressed: () async {
            final dateTime = await showDatePicker(
              context: context,
              firstDate: DateTime.parse("2020-01-01"),
              lastDate: now(),
            );
            dateTimeState.value = dateTime;
            onSelect(dateTime);
          },
          child: dateTime != null ? Text(DateTimeFormatter.yearAndMonthAndDay(dateTime)) : const Text("未選択"),
        ),
      ],
    );
  }
}
