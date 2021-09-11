import 'package:pilll/analytics.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/pill_sheet_group_select_pill_sheet_type_page_template.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecordPageAddingPillSheet extends StatelessWidget {
  const RecordPageAddingPillSheet({
    Key? key,
    required this.context,
    required this.store,
    required this.setting,
  }) : super(key: key);

  final BuildContext context;
  final RecordPageStore store;
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: 316,
        height: 316,
        child: Stack(
          children: <Widget>[
            Center(
              child: SvgPicture.asset(
                "images/empty_frame.svg",
              ),
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, color: TextColor.noshime),
                Text("ピルシートを追加",
                    style: FontType.assisting.merge(TextColorStyle.noshime)),
              ],
            )),
          ],
        ),
      ),
      onTap: () async {
        analytics.logEvent(name: "adding_pill_sheet_tapped");
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return _picker();
            });
      },
    );
  }

  Widget _picker() {
    return PillSheetGroupSelectPillSheetTypePageTemplate(
      pillSheetType: pillSheetType,
      onSelect: onSelect,
    );
    // TODO:
    return Container();
//    final elements = List.generate(12, (index) => index + 1);
//    int selected = elements.first;
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.end,
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        PickerToolbar(
//          done: (() async {
//            try {
//              await store.register(selected);
//            } on PillSheetAlreadyExists catch (_) {
//              showErrorAlert(
//                context,
//                message: "ピルシートがすでに存在しています。表示等に問題がある場合は設定タブから「お問い合わせ」ください",
//              );
//            } on PillSheetAlreadyDeleted catch (_) {
//              showErrorAlert(
//                context,
//                message: "ピルシートの作成に失敗しました。時間をおいて再度お試しください",
//              );
//            } catch (exception, stack) {
//              errorLogger.recordError(exception, stack);
//              store.handleException(exception);
//            }
//            Navigator.pop(context);
//          }),
//          cancel: (() {
//            Navigator.pop(context);
//          }),
//        ),
//        Container(
//          height: 200,
//          child: GestureDetector(
//            onTap: () {
//              Navigator.pop(context);
//            },
//            child: CupertinoPicker(
//              itemExtent: 40,
//              children: elements.map((e) => Text("$e")).toList(),
//              onSelectedItemChanged: (index) {
//                selected = elements[index];
//              },
//              scrollController: FixedExtentScrollController(
//                initialItem: 0,
//              ),
//            ),
//          ),
//        ),
//      ],
//    );
  }
}
