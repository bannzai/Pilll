import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/initial_setting/migrate_info.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_page.dart';
import 'package:pilll/domain/record/components/add_pill_sheet_group/add_pill_sheet_group_empty_frame.dart';
import 'package:pilll/domain/record/components/button/record_page_button.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar.dart';
import 'package:pilll/domain/record/components/supports/record_page_pill_sheet_support_actions.dart';
import 'package:pilll/domain/record/components/pill_sheet/record_page_pill_sheet_list.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/domain/record/record_page_state_notifier.dart';
import 'package:pilll/domain/record/components/header/record_page_header.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/hooks/automatic_keep_alive_client_mixin.dart';

class RecordPage extends HookConsumerWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordPageStateNotifierProvider);
    final store = ref.watch(recordPageStateNotifierProvider.notifier);
    useAutomaticKeepAlive(wantKeepAlive: true);

    return state.when(
      data: (state) => RecordPageBody(store: store, state: state),
      error: (error, stackTrace) => UniversalErrorPage(
        error: error,
        reload: () => ref.refresh(recordPageAsyncStateProvider),
        child: null,
      ),
      loading: () => const Indicator(),
    );
  }
}

class RecordPageBody extends StatelessWidget {
  final RecordPageStateNotifier store;
  final RecordPageState state;

  const RecordPageBody({
    Key? key,
    required this.store,
    required this.state,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pillSheetGroup = state.pillSheetGroup;
    final activedPillSheet = pillSheetGroup?.activedPillSheet;
    final setting = state.setting;

    Future.microtask(() async {
      if (state.shouldShowMigrateInfo) {
        _showMigrateInfoDialog(context, store);
      } else if (state.shouldShowPremiumFunctionSurvey) {
        await store.setTrueIsAlreadyShowPremiumFunctionSurvey();
        Navigator.of(context).push(PremiumFunctionSurveyPageRoutes.route());
      }
    });

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: PilllColors.white,
        toolbarHeight: RecordPageInformationHeaderConst.height,
        title: Stack(
          children: [
            RecordPageInformationHeader(
              today: DateTime.now(),
              pillSheetGroup: state.pillSheetGroup,
              setting: setting,
              store: store,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const NotificationBar(),
                const SizedBox(height: 37),
                _content(context, setting, state, store),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (activedPillSheet != null && pillSheetGroup != null && !pillSheetGroup.isDeactived) ...[
            RecordPageButton(
              pillSheetGroup: pillSheetGroup,
              currentPillSheet: activedPillSheet,
              appearanceMode: state.appearanceMode,
              userIsPremiumOtTrial: false,
            ),
            const SizedBox(height: 40),
          ],
        ],
      ),
    );
  }

  Widget _content(
    BuildContext context,
    Setting setting,
    RecordPageState state,
    RecordPageStateNotifier store,
  ) {
    final pillSheetGroup = state.pillSheetGroup;
    final activedPillSheet = pillSheetGroup?.activedPillSheet;
    if (activedPillSheet == null || pillSheetGroup == null || pillSheetGroup.isDeactived) {
      return AddPillSheetGroupEmptyFrame(
        context: context,
        store: store,
        setting: setting,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RecordPagePillSheetSupportActions(
            state: state,
            store: store,
            pillSheetGroup: pillSheetGroup,
            activedPillSheet: activedPillSheet,
            setting: setting,
          ),
          const SizedBox(height: 16),
          RecordPagePillSheetList(
            state: state,
            store: store,
            setting: setting,
          ),
        ],
      );
    }
  }

  void _showMigrateInfoDialog(BuildContext context, RecordPageStateNotifier store) async {
    showDialog(
        context: context,
        barrierColor: Colors.white,
        builder: (context) {
          return MigrateInfo(
            onClose: () async {
              store.showMigrateInfo();
              Navigator.of(context).pop();
            },
          );
        });
  }
}
