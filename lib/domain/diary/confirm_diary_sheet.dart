import 'package:pilll/domain/diary/post_diary_page.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/state/diary.dart';
import 'package:pilll/store/diaries.dart';
import 'package:pilll/store/post_diary.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _confirmDiaryProvider = StateNotifierProvider.autoDispose
    .family<PostDiaryStore, DateTime>((ref, date) {
  final diary = ref.watch(diariesStoreProvider.state).diaryForDateTime(date);
  final service = ref.watch(diaryServiceProvider);
  return PostDiaryStore(
      service as DiaryService, DiaryState(entity: diary.copyWith()));
});

class ConfirmDiarySheet extends HookWidget {
  final DateTime date;

  ConfirmDiarySheet(this.date);
  @override
  Widget build(BuildContext context) {
    final state = useProvider(_confirmDiaryProvider(date).state);
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
    final store = useProvider(_confirmDiaryProvider(date));
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(DateTimeFormatter.yearAndMonthAndDay(this.date),
            style: FontType.sBigTitle.merge(TextColorStyle.main)),
        Spacer(),
        IconButton(
          icon: SvgPicture.asset("images/edit.svg"),
          onPressed: () {
            Navigator.of(context).push(PostDiaryPageRoute.route(date));
          },
        ),
        SizedBox(width: 12),
        IconButton(
          icon: SvgPicture.asset("images/trash.svg"),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDeleteDiary(onDelete: () {
                    int counter = 0;
                    store.delete().then((value) =>
                        Navigator.popUntil(context, (route) => counter++ >= 2));
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
        Wrap(
          spacing: 10,
          children: diary.physicalConditions
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
    final diary = useProvider(_confirmDiaryProvider(date).state).entity;
    return Text(
      diary.memo,
      maxLines: 2,
    );
  }
}

class ConfirmDeleteDiary extends StatelessWidget {
  final Function() onDelete;

  const ConfirmDeleteDiary({Key? key, required this.onDelete})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SvgPicture.asset("images/alert_24.svg"),
      content: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("日記を削除します",
                style: FontType.subTitle.merge(TextColorStyle.black)),
            SizedBox(
              height: 15,
            ),
            Text("削除された日記は復元ができません",
                style: FontType.assisting.merge(TextColorStyle.lightGray)),
          ],
        ),
      ),
      actions: <Widget>[
        SecondaryButton(
          text: "キャンセル",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        SecondaryButton(
          text: "削除する",
          onPressed: () {
            onDelete();
          },
        ),
      ],
    );
  }
}
