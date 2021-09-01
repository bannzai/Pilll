import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/initial_setting/migrate_info.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/record/components/adding/record_page_adding_pill_sheet.dart';
import 'package:pilll/domain/record/components/button/record_page_button.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar.dart';
import 'package:pilll/domain/record/components/pill_sheet_list/record_page_pill_sheet_list.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/record_taken_information.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecordPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(recordPageStoreProvider.state);
    final store = useProvider(recordPageStoreProvider);
    Future.delayed(Duration(seconds: 1)).then((_) {
      if (!state.shouldShowMigrateInfo) {
        return;
      }
      _showMigrateInfoDialog(context, store);
    });

    Future.delayed(Duration(seconds: 1)).then((_) {
      if (!state.shouldShowTrial) {
        return;
      }
      showPremiumTrialModalWhenLaunchApp(context, () {
        showPremiumTrialCompleteModalPreDialog(context);
      });
    });

    final currentPillSheet = state.pillSheetGroup?.activedPillSheet;
    final settingEntity = state.setting;
    if (settingEntity == null || !state.firstLoadIsEnded) {
      return Indicator();
    }

    return UniversalErrorPage(
      error: state.exception,
      reload: () => store.reset(),
      child: Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: PilllColors.white,
          toolbarHeight: RecordTakenInformationConst.height,
          title: RecordTakenInformation(
            today: DateTime.now(),
            state: state,
            onPressed: () {
              analytics.logEvent(name: "tapped_record_information_header");
              if (currentPillSheet != null) {
                _showBeginDatePicker(context, currentPillSheet, store);
              }
            },
          ),
        ),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    NotificationBar(state),
                    SizedBox(height: 64),
                    _content(context, settingEntity, state, store),
                  ],
                ),
              ),
            ),
            if (currentPillSheet != null && !currentPillSheet.isInvalid)
              Positioned(
                bottom: 20,
                child: RecordPageButton(currentPillSheet: currentPillSheet),
              ),
          ],
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    Setting settingEntity,
    RecordPageState state,
    RecordPageStore store,
  ) {
    if (state.isUserInteractionDisabled)
      return RecordPageAddingPillSheet(
          context: context,
          store: store,
          pillSheetType: settingEntity.pillSheetType);
    if (!state.isUserInteractionDisabled)
      return RecordPagePillSheetList(
        state: state,
        store: store,
        setting: settingEntity,
      );
    return Container();
  }

  _showBeginDatePicker(
      BuildContext context, PillSheet currentPillSheet, RecordPageStore store) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        var selectedTodayPillNumber = currentPillSheet.todayPillNumber;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerToolbar(
              done: (() {
                store.modifyBeginingDate(selectedTodayPillNumber);
                Navigator.pop(context);
              }),
              cancel: (() {
                Navigator.pop(context);
              }),
            ),
            Container(
              height: 200,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: List.generate(currentPillSheet.typeInfo.totalCount,
                      (index) => Text("${index + 1}")),
                  onSelectedItemChanged: (index) {
                    selectedTodayPillNumber = index + 1;
                  },
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedTodayPillNumber - 1,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMigrateInfoDialog(
      BuildContext context, RecordPageStore store) async {
    showDialog(
        context: context,
        barrierColor: Colors.white,
        builder: (context) {
          return MigrateInfo(
            onClose: () async {
              await store.shownMigrateInfo();
              Navigator.of(context).pop();
            },
          );
        });
  }
}
