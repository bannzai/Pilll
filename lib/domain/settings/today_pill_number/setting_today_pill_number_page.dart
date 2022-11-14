import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_store.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_pill_sheet_list.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_store_parameter.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/pill_sheet.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class SettingTodayPillNumberPage extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;

  const SettingTodayPillNumberPage({
    Key? key,
    required this.pillSheetGroup,
    required this.activedPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillNumberIntoPillSheet = useState(_pillNumberIntoPillSheet(activedPillSheet: activedPillSheet, pillSheetGroup: pillSheetGroup));
    final pillSheetPageIndex = useState(activedPillSheet.groupIndex);

    final batchFactory = ref.watch(batchFactoryProvider);
    final batchSetPillSheets = ref.watch(batchSetPillSheetsProvider);
    final batchSetPillSheetGroup = ref.watch(batchSetPillSheetGroupProvider);
    final batchSetPillSheetModifiedHistory = ref.watch(batchSetPillSheetModifiedHistoryProvider);

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "ピル番号の変更",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "今日(${_today()})\n飲む・飲んだピルの番号をタップ",
                    style: FontType.sBigTitle.merge(TextColorStyle.main),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 56),
                  Center(
                    child: SettingTodayPillNumberPillSheetList(
                        pillSheetTypes: pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(),
                        appearanceMode: PillSheetAppearanceMode.number,
                        selectedTodayPillNumberIntoPillSheet: (pageIndex) {
                          if (pillSheetPageIndex.value != pageIndex) {
                            return null;
                          }
                          return pillNumberIntoPillSheet.value;
                        },
                        markSelected: (_pillSheetPageIndex, _pillNumberIntoPillSheet) {
                          pillSheetPageIndex.value = _pillSheetPageIndex;
                          pillNumberIntoPillSheet.value = _pillNumberIntoPillSheet;
                        }),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 180,
                      child: PrimaryButton(
                        onPressed: () async {
                          _submit(
                              pillSheetGroup: pillSheetGroup,
                              activedPillSheet: activedPillSheet,
                              batchFactory: batchFactory,
                              batchSetPillSheetGroup: batchSetPillSheetGroup,
                              batchSetPillSheets: batchSetPillSheets,
                              batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
                              pillSheetPageIndex: pillSheetPageIndex.value,
                              pillNumberIntoPillSheet: pillNumberIntoPillSheet.value);

                          Navigator.of(context).pop();
                        },
                        text: "変更する",
                      ),
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
    required BatchFactory batchFactory,
    required BatchSetPillSheetGroup batchSetPillSheetGroup,
    required BatchSetPillSheets batchSetPillSheets,
    required BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory,
    required int pillSheetPageIndex,
    required int pillNumberIntoPillSheet,
  }) async {
    final batch = batchFactory.batch();

    final pillSheetTypes = pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();
    final nextSerializedPillNumber = summarizedPillCountWithPillSheetTypesToEndIndex(
          pillSheetTypes: pillSheetTypes,
          endIndex: pillSheetPageIndex,
        ) +
        pillNumberIntoPillSheet;
    final firstPilSheetBeginDate = today().subtract(Duration(days: nextSerializedPillNumber - 1));

    final List<PillSheet> updatedPillSheets = [];
    pillSheetGroup.pillSheets.asMap().keys.forEach((index) {
      final pillSheet = pillSheetGroup.pillSheets[index];

      final DateTime beginDate;
      if (index == 0) {
        beginDate = firstPilSheetBeginDate;
      } else {
        final passedTotalCount = summarizedPillCountWithPillSheetTypesToEndIndex(pillSheetTypes: pillSheetTypes, endIndex: index);
        beginDate = firstPilSheetBeginDate.add(Duration(days: passedTotalCount));
      }

      final DateTime? lastTakenDate;
      if (pillSheetPageIndex == index) {
        lastTakenDate = beginDate.add(Duration(days: pillNumberIntoPillSheet - 2));
      } else if (pillSheetPageIndex > index) {
        lastTakenDate = beginDate.add(Duration(days: pillSheet.pillSheetType.totalCount - 1));
      } else {
        // state.selectedPillMarkNumberIntoPillSheet < index
        lastTakenDate = null;
      }

      final updatedPillSheet = pillSheet.copyWith(beginingDate: beginDate, lastTakenDate: lastTakenDate, restDurations: []);
      updatedPillSheets.add(updatedPillSheet);
    });

    batchSetPillSheets(batch, updatedPillSheets);

    final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: activedPillSheet,
      after: updatedPillSheets[pillSheetPageIndex],
    );
    batchSetPillSheetModifiedHistory(batch, history);
    batchSetPillSheetGroup(batch, pillSheetGroup.copyWith(pillSheets: updatedPillSheets));

    await batch.commit();
  }

  String _today() {
    return "${DateTimeFormatter.slashYearAndMonthAndDay(DateTime.now())}(${DateTimeFormatter.weekday(DateTime.now())})";
  }

  int _pillNumberIntoPillSheet({
    required PillSheet activedPillSheet,
    required PillSheetGroup pillSheetGroup,
  }) {
    final pillSheetTypes = pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();
    final _passedTotalCount = summarizedPillCountWithPillSheetTypesToEndIndex(pillSheetTypes: pillSheetTypes, endIndex: activedPillSheet.groupIndex);
    if (_passedTotalCount >= activedPillSheet.todayPillNumber) {
      return activedPillSheet.todayPillNumber;
    }
    return activedPillSheet.todayPillNumber - _passedTotalCount;
  }
}

extension SettingTodayPillNumberPageRoute on SettingTodayPillNumberPage {
  static Route<dynamic> route({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "SettingTodayPillNumberPage"),
      builder: (_) => SettingTodayPillNumberPage(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: activedPillSheet,
      ),
    );
  }
}
