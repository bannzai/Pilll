import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/service/pill_sheet.dart';

class PillSheetRemoveRow extends HookConsumerWidget {
  @override
  Widget build(BuildContext context) {
    final store = ref.watch(settingStoreProvider.notifier.notifier);
    return ListTile(
      title: Text("ピルシートをすべて破棄", style: FontType.listRow),
      onTap: () {
        analytics.logEvent(
          name: "did_select_removing_pill_sheet",
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                AlertButton(
                  text: "破棄する",
                  onPressed: () {
                    store.deletePillSheet().catchError((error) {
                      showErrorAlert(context,
                          message:
                              "ピルシートがすでに削除されています。表示等に問題がある場合は設定タブから「お問い合わせ」ください");
                    }, test: (error) => error is PillSheetIsNotExists);
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
