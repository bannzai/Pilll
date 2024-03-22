import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class CalendarPickersSheet extends HookWidget {
  final String title;
  final List<Widget> rows;

  const CalendarPickersSheet({
    Key? key,
    required this.title,
    required this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: MediaQuery.of(context).size.height * 0.5,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          for (final row in rows) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: row,
            ),
          ],
        ],
      ),
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
    final dateTime = useState(this.dateTime);

    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: TextColor.main,
            fontWeight: FontWeight.w500,
            fontFamily: FontFamily.japanese,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () async {
            dateTime.value = await showDatePicker(
              context: context,
              firstDate: DateTime.parse("2020-01-01"),
              lastDate: now(),
            );
            onSelect(dateTime.value);
          },
          child: dateTime.value != null ? Text(DateTimeFormatter.yearAndMonthAndDay(dateTime.value!)) : const Text("未選択"),
        ),
      ],
    );
  }
}

void showCalendarsPickerSheet(BuildContext context, CalendarPickersSheet sheet) {
  showModalBottomSheet(
    context: context,
    builder: (context) => sheet,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
