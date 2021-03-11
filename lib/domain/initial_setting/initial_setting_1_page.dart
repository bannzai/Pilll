import 'dart:io';

import 'package:Pilll/domain/initial_setting/initial_setting_2_page.dart';
import 'package:Pilll/components/organisms/pill/pill_sheet_type_select_page.dart';
import 'package:Pilll/domain/release_note/release_note.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:Pilll/store/initial_setting.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialSetting1Page extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(initialSettingStoreProvider);
    final state = useProvider(initialSettingStoreProvider.state);
    _showReleaseNoteModal(context);
    return PillSheetTypeSelectPage(
      title: "1/4",
      backButtonIsHidden: true,
      selected: (type) {
        store.modify((model) => model.copyWith(pillSheetType: type));
      },
      done: state.entity.pillSheetType == null
          ? null
          : () {
              Navigator.of(context).push(InitialSetting2PageRoute.route());
            },
      doneButtonText: "次へ",
      selectedPillSheetType: state.entity.pillSheetType,
    );
  }

  void _showReleaseNoteModal(BuildContext context) {
    if (!Platform.isIOS) {
      return;
    }
    final key = ReleaseNoteKey.renewal;
    SharedPreferences.getInstance().then((storage) {
      if (storage.getBool(key) ?? false) {
        return;
      }
      showDialog(
          context: context,
          barrierColor: Colors.white,
          builder: (context) {
            return ReleaseNote(
              onClose: () {
                storage.setBool(key, true);
                Navigator.of(context).pop();
              },
            );
          });
    });
  }
}

extension InitialSetting1PageRoute on InitialSetting1Page {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "InitialSetting1Page"),
      builder: (_) => InitialSetting1Page(),
    );
  }
}
