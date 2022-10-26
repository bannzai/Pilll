import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/menstruation_list/menstruation_list_row.dart';
import 'package:pilll/domain/menstruation_list/menstruation_list_store.dart';

class MenstruationListPage extends HookConsumerWidget {
  const MenstruationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(menstruationListStateNotifierProvider);

    if (state.isNotYetLoaded) {
      return const ScaffoldIndicator();
    }

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        title: Text(
          "生理履歴",
          style: TextColorStyle.main.merge(FontType.sBigTitle),
        ),
        backgroundColor: PilllColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: PilllColors.white,
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              ...state.allRows.map((row) {
                return [
                  MenstruationListRow(state: row),
                  const SizedBox(height: 8),
                ];
              }).expand((element) => element),
            ],
          ),
        ),
      ),
    );
  }
}

extension MenstruationListPageRoute on MenstruationListPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "MenstruationListPage"),
      builder: (_) => const MenstruationListPage(),
    );
  }
}
