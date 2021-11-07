import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/components/molecules/select_circle.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/setting.dart';

class SelectAppearanceModeModal extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(recordPageStoreProvider);
    final state = useProvider(recordPageStoreProvider.state);
    final setting = state.setting;
    if (setting == null) {
      return Container();
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 20, top: 24, left: 16, right: 16),
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
                _row(
                  context,
                  store: store,
                  setting: setting,
                  mode: PillSheetAppearanceMode.date,
                  text: "日付表示",
                  showsPremiumBadge: true,
                ),
                _row(
                  context,
                  store: store,
                  setting: setting,
                  mode: PillSheetAppearanceMode.number,
                  text: "ピル番号",
                  showsPremiumBadge: false,
                ),
                _row(
                  context,
                  store: store,
                  setting: setting,
                  mode: PillSheetAppearanceMode.sequential,
                  text: "服用日数",
                  showsPremiumBadge: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required RecordPageStore store,
    required Setting setting,
    required PillSheetAppearanceMode mode,
    required String text,
    required bool showsPremiumBadge,
  }) {
    return GestureDetector(
      onTap: () {
        store.switchingAppearanceMode(mode);
      },
      child: Container(
        height: 48,
        child: Row(
          children: [
            SelectCircle(isSelected: mode == setting.pillSheetAppearanceMode),
            SizedBox(width: 34),
            Text(
              text,
              style: TextStyle(
                color: TextColor.main,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            if (showsPremiumBadge) ...[
              SizedBox(width: 12),
              PremiumBadge(),
            ]
          ],
        ),
      ),
    );
  }
}

void showSelectAppearanceModeModal(
  BuildContext context,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) => SelectAppearanceModeModal(),
    backgroundColor: Colors.transparent,
  );
}
