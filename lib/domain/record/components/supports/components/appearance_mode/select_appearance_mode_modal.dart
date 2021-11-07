import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/components/molecules/select_circle.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/setting.dart';

class SelectAppearanceModeModal extends StatelessWidget {
  final RecordPageStore store;
  final PillSheetAppearanceMode mode;

  const SelectAppearanceModeModal(
      {Key? key, required this.store, required this.mode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding:
          const EdgeInsets.only(bottom: 20, top: 24, left: 16, right: 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "表示モード",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            SizedBox(height: 24),
            Column(
              children: [
                Container(
                  height: 48,
                  child: Row(
                    children: [
                      SelectCircle(isSelected: false),
                      SizedBox(width: 34),
                      Text(
                        "日付表示",
                        style: TextStyle(
                          color: TextColor.main,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 12),
                      PremiumBadge(),
                    ],
                  ),
                ),
                Container(
                  height: 48,
                  child: Row(
                    children: [
                      SelectCircle(isSelected: false),
                      SizedBox(width: 34),
                      Text(
                        "ピル番号",
                        style: TextStyle(
                          color: TextColor.main,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 48,
                  child: Row(
                    children: [
                      SelectCircle(isSelected: false),
                      SizedBox(width: 34),
                      Text(
                        "服用日数",
                        style: TextStyle(
                          color: TextColor.main,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showSelectAppearanceModeModal(
  BuildContext context, {
  required RecordPageStore store,
  required PillSheetAppearanceMode mode,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => SelectAppearanceModeModal(store: store, mode: mode),
    backgroundColor: Colors.transparent,
  );
}
