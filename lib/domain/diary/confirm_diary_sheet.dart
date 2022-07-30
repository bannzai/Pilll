import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/diary/confirm_diary_store.dart';
import 'package:pilll/domain/diary/diary_state.codegen.dart';
import 'package:pilll/domain/diary_post/diary_post_page.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

final _confirmDiaryStoreProvider = StateNotifierProvider.autoDispose
    .family<ConfirmDiaryStore, DiaryState, Diary>((ref, diary) {
  final service = ref.watch(diaryDatastoreProvider);
  return ConfirmDiaryStore(service, DiaryState(diary: diary.copyWith()));
});

class ConfirmDiarySheet extends HookConsumerWidget {
  final Diary _diary;

  const ConfirmDiarySheet(this._diary, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_confirmDiaryStoreProvider(_diary));
    final store = ref.watch(_confirmDiaryStoreProvider(_diary).notifier);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: PilllColors.white,
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(context, store, state),
            ...[
              if (state.hasPhysicalConditionStatus()) _physicalCondition(state),
              _physicalConditionDetails(state),
              if (state.diary.hasSex) _sex(),
              _memo(state),
            ].map((e) => _withContentSpacer(e)),
          ]),
    );
  }

  Widget _withContentSpacer(Widget content) {
    return Container(
      child: content,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
    );
  }

  Widget _title(
      BuildContext context, ConfirmDiaryStore store, DiaryState state) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(DateTimeFormatter.yearAndMonthAndDay(state.diary.date),
            style: FontType.sBigTitle.merge(TextColorStyle.main)),
        const Spacer(),
        IconButton(
          icon: SvgPicture.asset("images/edit.svg"),
          onPressed: () {
            Navigator.of(context)
                .push(PostDiaryPageRoute.route(state.diary.date, state.diary));
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
                    message: Text("削除された日記は復元ができません",
                        style: FontType.assisting.merge(TextColorStyle.main)),
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
                          await store.delete();

                          Navigator.popUntil(
                              context, (route) => counter++ >= 1);
                          Navigator.of(context).pop();
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
        return SvgPicture.asset("images/laugh.svg",
            color: PilllColors.secondary);
      case PhysicalConditionStatus.bad:
        return SvgPicture.asset("images/angry.svg",
            color: PilllColors.secondary);
      default:
        return Container();
    }
  }

  Widget _physicalCondition(DiaryState state) {
    return Row(
      children: [
        Text("体調", style: FontType.componentTitle.merge(TextColorStyle.black)),
        const SizedBox(width: 16),
        _physicalConditionImage(state.diary.physicalConditionStatus),
      ],
    );
  }

  Widget _physicalConditionDetails(DiaryState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          children: state.diary.physicalConditions
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
      padding: const EdgeInsets.all(4),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: PilllColors.thinSecondary),
      child: SvgPicture.asset("images/heart.svg", color: PilllColors.secondary),
    );
  }

  Widget _memo(DiaryState state) {
    return Text(
      state.diary.memo,
      maxLines: 2,
    );
  }
}
