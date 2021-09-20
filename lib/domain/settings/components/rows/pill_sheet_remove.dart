import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/service/pill_sheet.dart';

class PillSheetRemoveRow extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingStoreProvider);
    return ListTile(
      title: Text("${store.pillSheetWord}の破棄", style: FontType.listRow),
      onTap: () {
        analytics.logEvent(
          name: "did_select_removing_pill_sheet",
        );
        showDialog(
          context: context,
          builder: (_) {
            return DiscardDialog(
                title: "ピルシートをすべて破棄しますか？",
                message: Text("現在表示されているすべてのピルシートが破棄されます",
                    style: FontType.assisting.merge(TextColorStyle.main)),
                doneButtonText: "破棄する",
                done: () {
                  store.deletePillSheet().catchError((error) {
                    showErrorAlert(context,
                        message:
                            "ピルシートがすでに削除されています。表示等に問題がある場合は設定タブから「お問い合わせ」ください");
                  }, test: (error) => error is PillSheetIsNotExists);
                });
          },
        );
      },
    );
  }
}
