import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/setting.dart';

class PillSheetAppearanceModeRow extends HookWidget {
  final bool isPremium;
  final bool isTrial;
  final Setting setting;

  bool get isDisableEvent => isPremium || isTrial;

  const PillSheetAppearanceModeRow({
    Key? key,
    required this.isTrial,
    required this.isPremium,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isDisableEvent) {
      return _body(context);
    } else {
      return GestureDetector(
        child: _body(context),
        onTap: () {
          showPremiumIntroductionSheet(context);
        },
      );
    }
  }

  Widget _body(BuildContext context) {
    final store = useProvider(settingStoreProvider);
    final isOn =
        setting.pillSheetAppearanceMode == PillSheetAppearanceMode.date;
    return ListTile(
      title: Row(
        children: [
          Text("日付表示モード", style: FontType.listRow),
          SizedBox(width: 8),
          PremiumBadge(),
        ],
      ),
      trailing: Switch(
        value: isOn,
        onChanged: (value) => _onChanged(context, value, store),
      ),
      onTap: () => _onChanged(context, !isOn, store),
    );
  }

  _onChanged(
    BuildContext context,
    bool value,
    SettingStateStore store,
  ) {
    analytics.logEvent(
      name: "did_select_pill_sheet_appearance",
    );
    if (!isDisableEvent) {
      showPremiumIntroductionSheet(context);
    } else {
      final pillSheetAppearanceMode =
          value ? PillSheetAppearanceMode.date : PillSheetAppearanceMode.number;
      store.modifyPillSheetAppearanceMode(pillSheetAppearanceMode);
    }
  }
}
