import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/diary/post_diary_page.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/state/diary.dart';
import 'package:pilll/store/confirm_diary.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _confirmDiaryProvider =
    StateNotifierProvider.autoDispose.family<ConfirmDiary, Diary>((ref, diary) {
  final service = ref.watch(diaryServiceProvider);
  return ConfirmDiary(service, DiaryState(entity: diary.copyWith()));
});

class ConfirmDiarySheet extends HookWidget {
  final Diary _diary;

  ConfirmDiarySheet(this._diary);
  @override
  Widget build(BuildContext context) {
    final state = useProvider(_confirmDiaryProvider(_diary).state);
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
            _title(context),
            ...[
              if (state.hasPhysicalConditionStatus()) _physicalCondition(),
              _physicalConditionDetails(),
              if (state.entity.hasSex) _sex(),
              _memo(),
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

  Widget _title(BuildContext context) {
    final store = useProvider(_confirmDiaryProvider(_diary));
    final state = useProvider(_confirmDiaryProvider(_diary).state);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(DateTimeFormatter.yearAndMonthAndDay(state.entity.date),
            style: FontType.sBigTitle.merge(TextColorStyle.main)),
        Spacer(),
        IconButton(
          icon: SvgPicture.asset("images/edit.svg"),
          onPressed: () {
            Navigator.of(context)
                .push(PostDiaryPageRoute.route(state.entity.date));
          },
        ),
        SizedBox(width: 12),
        IconButton(
          icon: SvgPicture.asset("images/trash.svg"),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return DiscardDialog(
                      title: "日記を削除します",
                      message: "削除された日記は復元ができません",
                      doneButtonText: "削除する",
                      done: () {
                        int counter = 0;
                        store.delete().then((value) => Navigator.popUntil(
                            context, (route) => counter++ >= 1));
                      });
                });
          },
        ),
      ],
    );
  }

  Widget _physicalConditionImage(PhysicalConditionStatus? status) {
    switch (status) {
      case PhysicalConditionStatus.fine:
        return SvgPicture.asset("images/laugh.svg",
            color: PilllColors.secondary);
      case PhysicalConditionStatus.bad:
        return SvgPicture.asset("images/angry.svg",
            color: PilllColors.secondary);
      default:
        return Container();
    }
  }

  Widget _physicalCondition() {
    final state = useProvider(_confirmDiaryProvider(_diary).state);
    return Row(
      children: [
        Text("体調", style: FontType.componentTitle.merge(TextColorStyle.black)),
        SizedBox(width: 16),
        _physicalConditionImage(state.entity.physicalConditionStatus),
      ],
    );
  }

  Widget _physicalConditionDetails() {
    final state = useProvider(_confirmDiaryProvider(_diary).state);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          children: state.entity.physicalConditions
              .map((e) => ChoiceChip(
                    label: Text(e),
                    labelStyle: FontType.assisting.merge(TextColorStyle.white),
                    selectedColor: PilllColors.secondary,
                    selected: true,
                    onSelected: (selected) {},
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _sex() {
    return Container(
      padding: EdgeInsets.all(4),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: PilllColors.thinSecondary),
      child: SvgPicture.asset("images/heart.svg", color: PilllColors.secondary),
    );
  }

  Widget _memo() {
    final state = useProvider(_confirmDiaryProvider(_diary).state);
    return Text(
      state.entity.memo,
      maxLines: 2,
    );
  }
}
