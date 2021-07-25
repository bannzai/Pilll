import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/organisms/pill/pill_mark.dart';
import 'package:pilll/components/organisms/pill/pill_sheet.dart';
import 'package:pilll/domain/pill_sheet_history/pill_sheet_history_store.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class PillSheetHistoryPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(pillSheetHistoryStoreProvider.state);

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "履歴",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Center(
            child: ListView(
              children: state.pillSheets
                  .map(
                    (pillSheet) => Container(
                      padding: EdgeInsets.only(top: 20, left: 40, right: 40),
                      child: PillSheetView(
                        pillSheetType: pillSheet.pillSheetType,
                        pillMarkTypeBuilder: (number) {
                          return PillMarkType.done;
                        },
                        enabledMarkAnimation: (number) {
                          return false;
                        },
                        markSelected: (number) {
                          return;
                        },
                        doneStateBuilder: (number) {
                          return true;
                        },
                        premiumMarkBuilder: (pillMarkNumber) {
                          final date = pillSheet.beginingDate
                              .add(Duration(days: pillMarkNumber - 1));
                          return PremiumPillMarkModel(
                            date: date,
                            pillNumberForMenstruationBegin: 0,
                            menstruationDuration: 0,
                            maxPillNumber: pillSheet.pillSheetType.totalCount,
                          );
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

extension PillSheetHistoryPageRoutes on PillSheetHistoryPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "PillSheetHistoryPage"),
      builder: (_) => PillSheetHistoryPage(),
    );
  }
}
