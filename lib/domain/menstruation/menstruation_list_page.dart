import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
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
        title: SizedBox(
          child: Text(
            "生理履歴",
            style: TextStyle(color: TextColor.black),
          ),
        ),
        backgroundColor: PilllColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
            child: ListView.builder(
                itemCount: state.rows.length,
                itemBuilder: (context, index) {
                  final rowState = state.rows[index];
                  return MenstruationHistoryRow(state: rowState);
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
