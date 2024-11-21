import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/features/diary_post/diary_post_page.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class DiaryConfirmationSheet extends HookConsumerWidget {
  final DateTime date;

  const DiaryConfirmationSheet({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diary = ref.watch(diaryProvider(date));
    final deleteDiary = ref.watch(deleteDiaryProvider);
    if (diary == null) {
      return const Indicator();
    }

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: PilllColors.white,
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        _title(context, deleteDiary, diary),
        ...[
          if (diary.hasPhysicalConditionStatus) _physicalCondition(diary),
          _physicalConditionDetails(diary),
          if (diary.hasSex) _sex(diary),
          _memo(diary),
        ].map((e) => _withContentSpacer(e)),
      ]),
    );
  }

  Widget _withContentSpacer(Widget content) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: content,
    );
  }

  Widget _title(BuildContext context, DeleteDiary deleteDiary, Diary diary) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(DateTimeFormatter.yearAndMonthAndDay(diary.date),
            style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w500, fontSize: 20, color: TextColor.main)),
        const Spacer(),
        IconButton(
          icon: SvgPicture.asset("images/edit.svg"),
          onPressed: () {
            Navigator.of(context).push(DiaryPostPageRoute.route(diary.date, diary));
          },
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: SvgPicture.asset("images/trash.svg"),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return DiscardDialog(
                    title: "日記を削除します",
                    message: const Text("削除された日記は復元ができません",
                        style: TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w300, fontSize: 14, color: TextColor.main)),
                    actions: [
                      AlertButton(
                        text: "キャンセル",
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                      AlertButton(
                        text: "削除する",
                        onPressed: () async {
                          int counter = 0;
                          final navigator = Navigator.of(context);

                          await deleteDiary(diary);

                          navigator.popUntil((route) => counter++ >= 1);
                          navigator.pop();
                        },
                      ),
                    ],
                  );
                });
          },
        ),
      ],
    );
  }

  Widget _physicalConditionImage(PhysicalConditionStatus? status) {
    switch (status) {
      case PhysicalConditionStatus.fine:
        return SvgPicture.asset("images/laugh.svg", colorFilter: const ColorFilter.mode(PilllColors.primary, BlendMode.srcIn));
      case PhysicalConditionStatus.bad:
        return SvgPicture.asset("images/angry.svg", colorFilter: const ColorFilter.mode(PilllColors.primary, BlendMode.srcIn));
      default:
        return Container();
    }
  }

  Widget _physicalCondition(Diary diary) {
    return Row(
      children: [
        const Text("体調",
            style: TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: TextColor.black,
            )),
        const SizedBox(width: 16),
        _physicalConditionImage(diary.physicalConditionStatus),
      ],
    );
  }

  Widget _physicalConditionDetails(Diary diary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          children: diary.physicalConditions
              .map((e) => ChoiceChip(
                    label: Text(e),
                    labelStyle: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: TextColor.white,
                    ),
                    selectedColor: PilllColors.primary,
                    selected: true,
                    onSelected: (selected) {},
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _sex(Diary diary) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: 32,
      height: 32,
      decoration: BoxDecoration(shape: BoxShape.circle, color: PilllColors.thinSecondary),
      child: SvgPicture.asset("images/heart.svg", colorFilter: const ColorFilter.mode(PilllColors.primary, BlendMode.srcIn)),
    );
  }

  Widget _memo(Diary diary) {
    return Text(
      diary.memo,
      maxLines: 2,
    );
  }
}
