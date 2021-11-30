import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/initial_setting/migrate_info.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_page.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/record/components/adding/record_page_adding_pill_sheet.dart';
import 'package:pilll/domain/record/components/button/record_page_button.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar.dart';
import 'package:pilll/domain/record/components/supports/record_page_pill_sheet_support_actions.dart';
import 'package:pilll/domain/record/components/pill_sheet/record_page_pill_sheet_list.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/components/header/record_page_header.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecordPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(recordPageStoreProvider.state);
    final store = useProvider(recordPageStoreProvider);

    final exception = state.exception;
    if (exception != null) {
      return UniversalErrorPage(
        error: exception,
        reload: () => store.reset(),
        child: null,
      );
    }

    final pillSheetGroup = state.pillSheetGroup;
    final activedPillSheet = pillSheetGroup?.activedPillSheet;
    final setting = state.setting;
    if (setting == null || !state.firstLoadIsEnded) {
      return Indicator();
    }

    Future.microtask(() async {
      if (state.shouldShowMigrateInfo) {
        _showMigrateInfoDialog(context, store);
      } else if (state.shouldShowPremiumFunctionSurvey) {
        await store.setTrueIsAlreadyShowPremiumFunctionSurvey();
        Navigator.of(context).push(PremiumFunctionSurveyPageRoutes.route());
      } else if (state.shouldShowTrial) {
        showPremiumTrialModalWhenLaunchApp(context, () {
          showPremiumTrialCompleteModalPreDialog(context);
        });
      }
    });

    return UniversalErrorPage(
      error: state.exception,
      reload: () => store.reset(),
      child: Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: PilllColors.white,
          toolbarHeight: RecordPageInformationHeaderConst.height,
          title: RecordPageInformationHeader(
            today: DateTime.now(),
            pillSheetGroup: state.pillSheetGroup,
            setting: setting,
            store: store,
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
                    SizedBox(height: 12),
                    _content(context, setting, state, store),
                  ],
                ),
              ),
            ),
            if (activedPillSheet != null &&
                pillSheetGroup != null &&
                !pillSheetGroup.isDeactived)
              Positioned(
                bottom: 20,
                child: RecordPageButton(currentPillSheet: activedPillSheet),
              ),
          ],
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    Setting setting,
    RecordPageState state,
    RecordPageStore store,
  ) {
    final pillSheetGroup = state.pillSheetGroup;
    final activedPillSheet = pillSheetGroup?.activedPillSheet;
    if (activedPillSheet == null ||
        pillSheetGroup == null ||
        pillSheetGroup.isDeactived)
      return RecordPageAddingPillSheet(
        context: context,
        store: store,
        setting: setting,
      );
    else
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RecordPagePillSheetSupportActions(
            store: store,
            pillSheetGroup: pillSheetGroup,
            activedPillSheet: activedPillSheet,
            setting: setting,
          ),
          SizedBox(height: 16),
          RecordPagePillSheetList(
            state: state,
            store: store,
            setting: setting,
          ),
        ],
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
