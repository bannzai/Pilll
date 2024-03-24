import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/record/components/add_pill_sheet_group/add_pill_sheet_group_empty_frame.dart';
import 'package:pilll/features/record/components/button/record_page_button.dart';
import 'package:pilll/features/record/components/announcement_bar/announcement_bar.dart';
import 'package:pilll/features/record/components/supports/record_page_pill_sheet_support_actions.dart';
import 'package:pilll/features/record/components/pill_sheet/record_page_pill_sheet_list.dart';
import 'package:pilll/features/record/components/header/record_page_header.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/auth.dart';

class RecordPage extends HookConsumerWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final setting = ref.watch(settingProvider);
    final latestPillSheetGroup = ref.watch(latestPillSheetGroupProvider);
    final isLinked = ref.watch(isLinkedProvider);

    useAutomaticKeepAlive(wantKeepAlive: true);

    return AsyncValueGroup.group4(
      latestPillSheetGroup,
      user,
      setting,
      ref.watch(userProvider),
    ).when(
      data: (data) {
        final latestPillSheetGroup = data.t1;
        final user = data.t2;
        final setting = data.t3;
        return RecordPageBody(
          pillSheetGroup: latestPillSheetGroup,
          setting: setting,
          user: user,
          isLinkedLoginProvider: isLinked,
        );
      },
      error: (error, stackTrace) => UniversalErrorPage(
        error: error,
        reload: () => ref.refresh(refreshAppProvider),
        child: null,
      ),
      loading: () => const Indicator(),
    );
  }
}

class RecordPageBody extends HookConsumerWidget {
  final PillSheetGroup? pillSheetGroup;
  final Setting setting;
  final User user;
  final bool isLinkedLoginProvider;

  const RecordPageBody({
    Key? key,
    required this.pillSheetGroup,
    required this.setting,
    required this.user,
    required this.isLinkedLoginProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillSheetGroup = this.pillSheetGroup;
    final activePillSheet = pillSheetGroup?.activePillSheet;

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: PilllColors.white,
        toolbarHeight: RecordPageInformationHeaderConst.height,
        title: RecordPageInformationHeader(
          today: DateTime.now(),
          pillSheetGroup: pillSheetGroup,
          setting: setting,
          user: user,
        ),
      ),
      body: Builder(builder: (context) {
        if (activePillSheet == null || pillSheetGroup == null || pillSheetGroup.isDeactived) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const AnnouncementBar(),
                    const SizedBox(height: 37),
                    AddPillSheetGroupEmptyFrame(
                      context: context,
                      pillSheetGroup: pillSheetGroup,
                      setting: setting,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const AnnouncementBar(),
                    const SizedBox(height: 37),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RecordPagePillSheetSupportActions(
                          pillSheetGroup: pillSheetGroup,
                          activePillSheet: activePillSheet,
                          setting: setting,
                          user: user,
                        ),
                        const SizedBox(height: 16),
                        RecordPagePillSheetList(
                          pillSheetGroup: pillSheetGroup,
                          activePillSheet: activePillSheet,
                          setting: setting,
                          user: user,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              RecordPageButton(
                pillSheetGroup: pillSheetGroup,
                currentPillSheet: activePillSheet,
                userIsPremiumOtTrial: user.premiumOrTrial,
                user: user,
              ),
              const SizedBox(height: 40),
            ],
          );
        }
      }),
    );
  }
}
