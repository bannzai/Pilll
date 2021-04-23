import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/menstruation/menstruation_history_row.dart';
import 'package:pilll/domain/menstruation/menstruation_list_store.dart';

class MenstruationListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(menstruationListStoreProvider.state);

    if (state.isNotYetLoaded) {
      return ScaffoldIndicator();
    }

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
            child: ListView.builder(
                padding: const EdgeInsets.all(32),
                itemCount: state.rows.length,
                itemBuilder: (context, index) {
                  final rowState = state.rows[index];
                  return Column(
                    children: [
                      MenstruationHistoryRow(state: rowState),
                      SizedBox(height: 8),
                    ],
                  );
                })),
      ),
    );
  }
}

extension MenstruationListPageRoute on MenstruationListPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "MenstruationListPage"),
      builder: (_) => MenstruationListPage(),
    );
  }
}
