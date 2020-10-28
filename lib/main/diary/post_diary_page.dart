import 'package:Pilll/model/diary.dart';
import 'package:Pilll/store/diary.dart';
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

class PostDiaryStore extends StateNotifier<Diary> {
  PostDiaryStore(Diary state) : super(state);

  Diary get diary => state;

  void removePhysicalCondition(String physicalCondition) {
    state = state.copyWith(
        physicalConditions: state.physicalConditions
          ..remove(physicalCondition));
  }

  void addPhysicalCondition(String physicalCondition) {
    state = state.copyWith(
        physicalConditions: state.physicalConditions..add(physicalCondition));
  }
}

final _postDiaryStoreProvider = StateNotifierProvider.autoDispose
    .family<PostDiaryStore, DateTime>((ref, date) {
  final diary =
      ref.watch(diariesStoreProvider.state).diaryForDatetimeOrNull(date);
  if (diary == null) {
    return PostDiaryStore(Diary.forPost(date));
  }
  return PostDiaryStore(diary.copyWith());
});

class PostDiaryPage extends HookWidget {
  final DateTime date;

  PostDiaryPage(this.date);

  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_protected_member
    final state = useProvider(_postDiaryStoreProvider(date).state);
    final textEditingController = useTextEditingController(text: state.memo);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateTimeFormatter.yearAndMonthAndDay(this.date),
                style: FontType.sBigTitle.merge(TextColorStyle.main)),
            _physicalConditions(),
            Text("体調詳細",
                style: FontType.componentTitle.merge(TextColorStyle.black)),
            _conditions(),
            _sex(),
            _memo(context, textEditingController, focusNode),
            if (focusNode.hasFocus) _keyboardToolbar(focusNode),
          ],
        ),
      ),
    );
  }

  Widget _physicalConditions() {
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
              IconButton(
                  icon: SvgPicture.asset("images/laugh.svg"), onPressed: null),
              Container(
                  height: 48,
                  child: VerticalDivider(width: 1, color: PilllColors.divider)),
              IconButton(
                  icon: SvgPicture.asset("images/angry.svg"), onPressed: null),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _conditions() {
    final store = useProvider(_postDiaryStoreProvider(date));
    final diary = useProvider(_postDiaryStoreProvider(date).state);
    return Wrap(
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
    );
  }

  Widget _sex() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("sex", style: FontType.componentTitle.merge(TextColorStyle.black)),
        SizedBox(width: 80),
        Container(
            padding: EdgeInsets.all(4),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: PilllColors.disabledSheet),
            child: SvgPicture.asset("images/heart.svg",
                color: TextColor.darkGray)),
        Spacer(),
      ],
    );
  }

  Widget _keyboardToolbar(FocusNode focusNode) {
    return Container(
        height: 44.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SecondaryButton(
              text: '完了',
              onPressed: () {
                focusNode.unfocus(); //unfocus()でフォーカスが外れる
              },
            )
          ],
        ));
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
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
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
            )),
      ),
    );
  }
}
