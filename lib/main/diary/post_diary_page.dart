import 'package:Pilll/model/diary.dart';
import 'package:Pilll/service/user.dart';
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

class PostDiaryState {
  final Diary diary;

  PostDiaryState(this.diary);
}

class PostDiaryStore extends StateNotifier<PostDiaryState> {
  PostDiaryStore(PostDiaryState state) : super(state);

  Diary get diary => state.diary;

  void removePhysicalCondition(String physicalCondition) {
    state = PostDiaryState(
        state.diary..physicalConditions.remove(physicalCondition));
  }

  void addPhysicalCondition(String physicalCondition) {
    state =
        PostDiaryState(state.diary..physicalConditions.add(physicalCondition));
  }
}

final postDiaryStoreProvider = StateNotifierProvider<PostDiaryStore>((ref) {
  final date = DateTime.parse("2020-10-07");
  return PostDiaryStore(PostDiaryState(Diary.forPost(date)));
});

class PostDiaryPage extends HookWidget {
  final DateTime date;

  PostDiaryPage(this.date);

  @override
  Widget build(BuildContext context) {
    final store = useProvider(postDiaryStoreProvider);
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
            Text(DateTimeFormatter.yearAndMonthAndDay(this.date)),
            _physicalConditions(),
            Text("体調詳細"),
            _conditions(store),
            _sex(),
            _memo(context, null, null),
          ],
        ),
      ),
    );
  }

  Widget _physicalConditions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("体調"),
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

  Widget _conditions(PostDiaryStore store) {
    final diary = store.diary;
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
        Text("sex"),
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
    return Container(
      color: Colors.blue,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: 25,
          maxHeight: 80,
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
            child: TextField(
              decoration: InputDecoration(hintText: "メモ"),
              controller: textEditingController,
              maxLines: null,
              maxLength: 500,
              keyboardType: TextInputType.multiline,
              focusNode: focusNode,
            )),
      ),
    );
  }
}
