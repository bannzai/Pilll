import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

const double _tileHeight = 48;

class DiaryOrScheduleSheet extends StatelessWidget {
  final VoidCallback showDiary;
  final VoidCallback showSchedule;

  const DiaryOrScheduleSheet({super.key, required this.showDiary, required this.showSchedule});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _tile(
              title: "日記を記録",
              onTap: () => showDiary(),
              leading: const Icon(Icons.note_alt),
            ),
            _tile(title: "予定を記入", onTap: () => showSchedule(), leading: const Icon(Icons.event)),
          ],
        ),
      ),
    );
  }

  Widget _tile({required String title, required VoidCallback onTap, required Widget leading}) {
    return SizedBox(
      height: _tileHeight,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: TextColor.main,
          ),
        ),
        leading: leading,
        onTap: () => onTap(),
      ),
    );
  }
}
