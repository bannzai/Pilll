import 'package:pilll/domain/initial_setting/initial_setting_store.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExplainPillNumber extends HookWidget {
  final String today;

  const ExplainPillNumber({Key? key, required this.today}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = useProvider(initialSettingStoreProvider.state);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: () {
          final todayPillNumber = state.todayPillNumber;
          if (todayPillNumber == null) {
            return <Widget>[
              Text("", style: FontType.largeNumber.merge(TextColorStyle.main)),
            ];
          }
          return <Widget>[
            Text("$todayに飲むピルは",
                style: FontType.description.merge(TextColorStyle.main)),
            Text("${todayPillNumber.pillNumberIntoPillSheet}",
                style: FontType.largeNumber.merge(TextColorStyle.main)),
            Text("番", style: FontType.description.merge(TextColorStyle.main)),
          ];
        }(),
      ),
    );
  }
}
