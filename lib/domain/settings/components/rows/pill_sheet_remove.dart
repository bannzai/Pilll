import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/settings/setting_page_state_notifier.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/error/error_alert.dart';

class PillSheetRemoveRow extends HookConsumerWidget {
  final PillSheetGroup latestPillSheetGroup;
  final PillSheet activedPillSheet;

  const PillSheetRemoveRow({
    required this.latestPillSheetGroup,
    required this.activedPillSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(settingStateNotifierProvider.notifier);
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
                    store.asyncAction
                        .deletePillSheet(
                          latestPillSheetGroup: latestPillSheetGroup,
                          activedPillSheet: activedPillSheet,
                        )
                        .catchError(
                            (error) => showErrorAlertFor(context, error));
                    Navigator.of(context).pop();
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
