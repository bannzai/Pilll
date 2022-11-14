import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/provider/delete_pill_sheet.dart';
import 'package:pilll/provider/pill_sheet.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';

class PillSheetRemoveRow extends HookConsumerWidget {
  final PillSheetGroup latestPillSheetGroup;
  final PillSheet activedPillSheet;

  const PillSheetRemoveRow({
    Key? key,
    required this.latestPillSheetGroup,
    required this.activedPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletePillSheetGroup = ref.watch(deletePillSheetGroupProvider);
    return ListTile(
      title: const Text("ピルシートをすべて破棄", style: FontType.listRow),
      onTap: () {
        analytics.logEvent(
          name: "did_select_remove_pill_sheet",
        );
        showDialog(
          context: context,
          builder: (_) {
            return DiscardDialog(
              title: "ピルシートをすべて破棄しますか？",
              message: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "現在表示されている",
                      style: FontType.assisting.merge(TextColorStyle.main),
                    ),
                    TextSpan(
                      text: "すべてのピルシート",
                      style: FontType.assistingBold.merge(TextColorStyle.main),
                    ),
                    TextSpan(
                      text: "が破棄されます",
                      style: FontType.assisting.merge(TextColorStyle.main),
                    ),
                  ],
                ),
              ),
              actions: [
                AlertButton(
                  text: "キャンセル",
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                AlertButton(
                  text: "破棄する",
                  onPressed: () async {
                    try {
                      await deletePillSheetGroup(latestPillSheetGroup: latestPillSheetGroup, activedPillSheet: activedPillSheet);
                      Navigator.of(context).pop();
                    } catch (error) {
                      showErrorAlert(context, error);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
