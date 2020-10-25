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

final diaryProvider = Provider.autoDispose.family<Diary, DateTime>((ref,
        date) =>
    ref.watch(diariesStoreProvider.state).diaryForDatetime(date).copyWith());

class PostDiaryPage extends HookWidget {
  final DateTime date;

  PostDiaryPage(this.date);

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    Diary diary = useMemoized(
        () => useProvider(diaryProvider(date)) ?? Diary.forPost(date));
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
            Text(DateTimeFormatter.yearAndMonthAndDay(this.date)),
            _physicalConditions(),
            Text("体調詳細"),
            _conditions(diary),
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

  Widget _conditions(Diary diary) {
    return Wrap(
      spacing: 10,
      children: Diary.physicalConditions
          .map((e) => ChoiceChip(
                label: Text(e),
                labelStyle: FontType.assisting.merge(
                    diary.physicalCondtions.contains(e)
                        ? TextColorStyle.primary
                        : TextColorStyle.darkGray),
                disabledColor: PilllColors.disabledSheet,
                selectedColor: PilllColors.primarySheet,
                selected: diary.physicalCondtions.contains(e),
                onSelected: (selected) {
                  diary.physicalCondtions.contains(e)
                      ? diary.physicalCondtions.remove(e)
                      : diary.physicalCondtions.add(e);
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
