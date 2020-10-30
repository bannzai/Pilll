import 'package:Pilll/model/diary.dart';
import 'package:Pilll/service/diary.dart';
import 'package:Pilll/state/diary.dart';
import 'package:Pilll/store/diaries.dart';
import 'package:Pilll/store/post_diary.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/all.dart';

final _confirmDiaryProvider = StateNotifierProvider.autoDispose
    .family<PostDiaryStore, DateTime>((ref, date) {
  final diary = ref.watch(diariesStoreProvider.state).diaryForDateTime(date);
  final service = ref.watch(diaryServiceProvider);
  return PostDiaryStore(service, DiaryState(entity: diary.copyWith()));
});

class EditDiarySheet extends HookWidget {
  final DateTime date;

  EditDiarySheet(this.date);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(DateTimeFormatter.yearAndMonthAndDay(this.date),
              style: FontType.sBigTitle.merge(TextColorStyle.main)),
          _physicalCondition(),
        ],
      ),
    );
  }

  Widget _physicalConditionImage(PhysicalConditionStatus status) {
    switch (status) {
      case PhysicalConditionStatus.fine:
        return SvgPicture.asset("images/laugh.svg", color: PilllColors.primary);
      case PhysicalConditionStatus.bad:
        return SvgPicture.asset("images/laugh.svg", color: PilllColors.primary);
      default:
        return Container();
    }
  }

  Widget _physicalCondition() {
    final state = useProvider(_confirmDiaryProvider(date).state);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("体調", style: FontType.componentTitle.merge(TextColorStyle.black)),
        SizedBox(width: 16),
        _physicalConditionImage(state.entity.physicalConditionStatus),
      ],
    );
  }
}
