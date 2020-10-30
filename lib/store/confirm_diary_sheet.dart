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

class ConfirmDiarySheet extends HookWidget {
  final DateTime date;

  ConfirmDiarySheet(this.date);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: PilllColors.white,
      ),
      padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateTimeFormatter.yearAndMonthAndDay(this.date),
                style: FontType.sBigTitle.merge(TextColorStyle.main)),
            ...[
              _physicalCondition(),
              _physicalConditionDetails(),
              _sex(),
            ].map((e) => _withContentSpacer(e)),
          ]),
    );
  }

  Widget _withContentSpacer(Widget content) {
    return Container(
      child: content,
      padding: EdgeInsets.only(top: 10, bottom: 10),
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
      children: [
        Text("体調", style: FontType.componentTitle.merge(TextColorStyle.black)),
        SizedBox(width: 16),
        _physicalConditionImage(state.entity.physicalConditionStatus),
      ],
    );
  }

  Widget _physicalConditionDetails() {
    final diary = useProvider(_confirmDiaryProvider(date).state).entity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("体調詳細",
            style: FontType.componentTitle.merge(TextColorStyle.black)),
        SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: diary.physicalConditions
              .map((e) => ChoiceChip(
                    label: Text(e),
                    labelStyle:
                        FontType.assisting.merge(TextColorStyle.primary),
                    selectedColor: PilllColors.primarySheet,
                    selected: true,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _sex() {
    final diary = useProvider(_confirmDiaryProvider(date).state).entity;
    return Container(
      padding: EdgeInsets.all(4),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: diary.hasSex
              ? PilllColors.primarySheet
              : PilllColors.disabledSheet),
      child: SvgPicture.asset("images/heart.svg",
          color: diary.hasSex ? PilllColors.primary : TextColor.darkGray),
    );
  }
}
