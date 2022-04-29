import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/components/month/month_calendar.dart';
import 'package:pilll/domain/menstruation/components/calendar/menstruation_calendar_header.dart';
import 'package:pilll/domain/menstruation/menstruation_card.dart';
import 'package:pilll/domain/menstruation/menstruation_state.codegen.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page.dart';
import 'package:pilll/domain/menstruation/menstruation_history_card.dart';
import 'package:pilll/domain/menstruation/menstruation_select_modify_type_sheet.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/hooks/automatic_keep_alive_client_mixin.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

abstract class MenstruationPageConst {
  static const double calendarHeaderDropShadowOffset = 2;
  static final double tileHeight =
      CalendarConstants.tileHeight + calendarHeaderDropShadowOffset;
  static final double calendarHeaderHeight =
      WeekdayBadgeConst.height + tileHeight;
}

class MenstruationPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(menstruationsStoreProvider.notifier);
    final state = ref.watch(menstruationsStoreProvider);

    useAutomaticKeepAlive(wantKeepAlive: true);

    if (state.exception != null) {
      return UniversalErrorPage(
        error: state.exception,
        child: null,
        reload: () => store.reset(),
      );
    }
    if (state.isNotYetLoaded) {
      return ScaffoldIndicator();
    }

    final pageController =
        usePageController(initialPage: state.currentCalendarIndex);
    pageController.addListener(() {
      final index = (pageController.page ?? pageController.initialPage).round();
      store.updateCurrentCalendarIndex(index);
    });

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: SizedBox(
          child: Text(
            state.displayMonth,
            style: const TextStyle(color: TextColor.black),
          ),
        ),
        backgroundColor: PilllColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  MenstruationCalendarHeader(
                    pageController: pageController,
                    state: state,
                  ),
                  Expanded(
                    child: MenstruationCardList(store: store),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: MenstruationRecordButton(state: state, store: store),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenstruationRecordButton extends StatelessWidget {
  const MenstruationRecordButton({
    Key? key,
    required this.state,
    required this.store,
  }) : super(key: key);

  final MenstruationState state;
  final MenstruationStore store;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () async {
        analytics.logEvent(name: "pressed_menstruation_record");
        final latestMenstruation = state.latestMenstruation;
        if (latestMenstruation != null &&
            latestMenstruation.dateRange.inRange(today())) {
          showMenstruationEditPageForUpdate(context, latestMenstruation);
          return;
        }

        final setting = state.setting;
        if (setting == null) {
          throw const FormatException("生理記録前にデータの読み込みに失敗しました。再読み込みしてから再度お試しください");
        }

        if (setting.durationMenstruation == 0) {
          return showMenstruationEditPageForCreate(context);
        }
        showModalBottomSheet(
          context: context,
          builder: (_) =>
              MenstruationSelectModifyTypeSheet(onTap: (type) async {
            switch (type) {
              case MenstruationSelectModifyType.today:
                analytics.logEvent(name: "tapped_menstruation_record_today");
                Navigator.of(context).pop();
                final created = await store.recordFromToday();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                        "${DateTimeFormatter.monthAndDay(created.beginDate)}から生理開始で記録しました"),
                  ),
                );
                return;
              case MenstruationSelectModifyType.yesterday:
                analytics.logEvent(
                    name: "tapped_menstruation_record_yesterday");
                Navigator.of(context).pop();
                final created = await store.recordFromYesterday();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                        "${DateTimeFormatter.monthAndDay(created.beginDate)}から生理開始で記録しました"),
                  ),
                );
                return;
              case MenstruationSelectModifyType.begin:
                analytics.logEvent(name: "tapped_menstruation_record_begin");
                Navigator.of(context).pop();
                return showMenstruationEditPageForCreate(context);
            }
          }),
        );
      },
      text: state.buttonString,
    );
  }
}

class MenstruationCardList extends StatelessWidget {
  const MenstruationCardList({
    Key? key,
    required this.store,
  }) : super(key: key);

  final MenstruationStore store;

  @override
  Widget build(BuildContext context) {
    final cardState = store.cardState();
    final historyCardState = store.historyCardState();
    return Container(
      color: PilllColors.background,
      child: ListView(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        scrollDirection: Axis.vertical,
        children: [
          if (cardState != null) ...[
            MenstruationCard(cardState),
            const SizedBox(height: 24),
          ],
          if (historyCardState != null)
            MenstruationHistoryCard(state: historyCardState),
        ],
      ),
    );
  }
}
