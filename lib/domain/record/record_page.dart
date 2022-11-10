import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/setting.dart';
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
import 'package:pilll/domain/root/provider.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/shared_preference.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/shared_preference/keys.dart';

class RecordPage extends HookConsumerWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordPageStateNotifierProvider);
    final store = ref.watch(recordPageStateNotifierProvider.notifier);
    useAutomaticKeepAlive(wantKeepAlive: true);

    useEffect(() {
      final f = (() async {
        try {
          syncUserStatus(premiumAndTrial: state.asData?.value.premiumAndTrial);
        } catch (error) {
          debugPrint(error.toString());
        }
      });

      f();
      return null;
    }, [state.asData?.value.premiumAndTrial]);

    useEffect(() {
      final f = (() async {
        try {
          syncSetting(setting: state.asData?.value.setting);
        } catch (error) {
          debugPrint(error.toString());
        }
      });

      f();
      return null;
    }, [state.asData?.value.setting]);

    useEffect(() {
      final f = (() async {
        try {
          syncActivePillSheetValue(pillSheetGroup: state.asData?.value.pillSheetGroup);
        } catch (error) {
          debugPrint(error.toString());
        }
      });

      f();
      return null;
    }, [state.asData?.value.pillSheetGroup]);

    final isLinked = ref.watch(isLinkedProvider);
    AsyncValueGroup.group5(
      ref.watch(latestPillSheetGroupStreamProvider),
      ref.watch(premiumAndTrialProvider),
      ref.watch(settingStreamProvider),
      ref.watch(sharedPreferenceProvider),
      ref.watch(shouldShowMigrationInformationProvider),
    ).when(
      data: (data) {
        final latestPillSheetGroup = data.t1;
        final premiumAndTrial = data.t2;
        final setting = data.t3;
        final sharedPreferences = data.t4;
        final shouldShowMigrationInformation = data.t5;
        return RecordPageBody(
          pillSheetGroup: latestPillSheetGroup,
          setting: setting,
          premiumAndTrial: premiumAndTrial,
          totalCountOfActionForTakenPill: sharedPreferences.getInt(IntKey.totalCountOfActionForTakenPill) ?? 0,
          shouldShowMigrateInfo: shouldShowMigrationInformation,
          isAlreadyShowPremiumSurvey: sharedPreferences.getBool(BoolKey.isAlreadyShowPremiumSurvey) ?? false,
          isLinkedLoginProvider: isLinked,
          timestamp: now(),
        );
      },
      error: (error, stackTrace) => UniversalErrorPage(
        error: error,
        reload: () => ref.refresh(refreshAppProvider),
        child: null,
      ),
      loading: () => const Indicator(),
    );

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
//  final RecordPageStateNotifier store;
//  final RecordPageState state;
//
  final PillSheetGroup? pillSheetGroup;
  final Setting setting;
  final PremiumAndTrial premiumAndTrial;
  final int totalCountOfActionForTakenPill;
  final bool isAlreadyShowPremiumSurvey;
  final bool shouldShowMigrateInfo;
  final bool isLinkedLoginProvider;
  // Workaround for no update RecordPageStateNotifier when pillSheetGroup.activedPillSheet.restDurations is change
  // Add and always update timestamp when every stream or provider changed to avoid this issue
  final DateTime timestamp;

  const RecordPageBody({
    Key? key,
    this.pillSheetGroup,
    required this.setting,
    required this.premiumAndTrial,
    required this.totalCountOfActionForTakenPill,
    required this.isAlreadyShowPremiumSurvey,
    required this.shouldShowMigrateInfo,
    required this.isLinkedLoginProvider,
    required this.timestamp,
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
              userIsPremiumOtTrial: state.premiumAndTrial.premiumOrTrial,
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
