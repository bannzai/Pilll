import 'package:Pilll/model/diary.dart';
import 'package:Pilll/state/diary.dart';
import 'package:Pilll/store/diaries.dart';
import 'package:Pilll/store/post_diary.dart';
import 'package:Pilll/style/button.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:riverpod/all.dart';

final _postDiaryStoreProvider = StateNotifierProvider.autoDispose
    .family<PostDiaryStore, DateTime>((ref, date) {
  final diary =
      ref.watch(diariesStoreProvider.state).diaryForDatetimeOrNull(date);
  if (diary == null) {
    return PostDiaryStore(DiaryState(entity: Diary.forPost(date)));
  }
  return PostDiaryStore(DiaryState(entity: diary.copyWith()));
});

class PostDiaryPage extends HookWidget {
  final DateTime date;

  PostDiaryPage(this.date);

  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_protected_member
    final state = useProvider(_postDiaryStoreProvider(date).state);
    final textEditingController =
        useTextEditingController(text: state.entity.memo);
    final focusNode = useFocusNode();
    return Scaffold(
      backgroundColor: PilllColors.background,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: PilllColors.background,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(DateTimeFormatter.yearAndMonthAndDay(this.date),
                    style: FontType.sBigTitle.merge(TextColorStyle.main)),
                ...[
                  _physicalConditions(),
                  _physicalConditionDetails(),
                  _sex(),
                  _memo(context, textEditingController, focusNode),
                ].map((e) => _withContentSpacer(e)),
              ],
            ),
          ),
          if (focusNode.hasFocus) _keyboardToolbar(context, focusNode),
        ],
      ),
    );
  }

  Widget _withContentSpacer(Widget content) {
    return Container(
      child: content,
      padding: EdgeInsets.only(top: 10, bottom: 10),
    );
  }

  Widget _physicalConditions() {
    final store = useProvider(_postDiaryStoreProvider(date));
    final state = useProvider(_postDiaryStoreProvider(date).state);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("体調", style: FontType.componentTitle.merge(TextColorStyle.black)),
        Spacer(),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: PilllColors.divider,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                  color: state.hasPhysicalConditionStatus(
                          PhysicalConditionStatus.fine)
                      ? PilllColors.primarySheet
                      : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/laugh.svg",
                        color: state.hasPhysicalConditionStatus(
                                PhysicalConditionStatus.fine)
                            ? PilllColors.primary
                            : TextColor.darkGray),
                    onPressed: () {
                      store.switchingPhysicalCondition(
                          PhysicalConditionStatus.fine);
                    }),
              ),
              Container(
                  height: 48,
                  child: VerticalDivider(width: 1, color: PilllColors.divider)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                  color: state.hasPhysicalConditionStatus(
                          PhysicalConditionStatus.bad)
                      ? PilllColors.primarySheet
                      : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/angry.svg",
                        color: state.hasPhysicalConditionStatus(
                                PhysicalConditionStatus.bad)
                            ? PilllColors.primary
                            : TextColor.darkGray),
                    onPressed: () {
                      store.switchingPhysicalCondition(
                          PhysicalConditionStatus.bad);
                    }),
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _physicalConditionDetails() {
    final store = useProvider(_postDiaryStoreProvider(date));
    final diary = useProvider(_postDiaryStoreProvider(date).state).entity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("体調詳細",
            style: FontType.componentTitle.merge(TextColorStyle.black)),
        SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: Diary.allPhysicalConditions
              .map((e) => ChoiceChip(
                    label: Text(e),
                    labelStyle: FontType.assisting.merge(
                        diary.physicalConditions.contains(e)
                            ? TextColorStyle.primary
                            : TextColorStyle.darkGray),
                    disabledColor: PilllColors.disabledSheet,
                    selectedColor: PilllColors.primarySheet,
                    selected: diary.physicalConditions.contains(e),
                    onSelected: (selected) {
                      diary.physicalConditions.contains(e)
                          ? store.removePhysicalCondition(e)
                          : store.addPhysicalCondition(e);
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _sex() {
    final store = useProvider(_postDiaryStoreProvider(date));
    final state = useProvider(_postDiaryStoreProvider(date).state);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("sex", style: FontType.componentTitle.merge(TextColorStyle.black)),
        SizedBox(width: 80),
        GestureDetector(
          onTap: () {
            store.toggleHasSex();
          },
          child: Container(
              padding: EdgeInsets.all(4),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state.entity.hasSex
                      ? PilllColors.primarySheet
                      : PilllColors.disabledSheet),
              child: SvgPicture.asset("images/heart.svg",
                  color: state.entity.hasSex
                      ? PilllColors.primary
                      : TextColor.darkGray)),
        ),
        Spacer(),
      ],
    );
  }

  Widget _keyboardToolbar(BuildContext context, FocusNode focusNode) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      child: Container(
        height: 44,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Spacer(),
            SecondaryButton(
              text: '完了',
              onPressed: () {
                focusNode.unfocus();
              },
            ),
          ],
        ),
        decoration: BoxDecoration(color: PilllColors.white),
      ),
    );
  }

  Widget _memo(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
  ) {
    final textLength = 120;
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: 40,
          maxHeight: 200,
        ),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: "メモ",
            border: OutlineInputBorder(),
          ),
          controller: textEditingController,
          maxLines: null,
          maxLength: textLength,
          keyboardType: TextInputType.multiline,
          focusNode: focusNode,
        ),
      ),
    );
  }
}
