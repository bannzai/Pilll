import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/components/month/month_calendar.dart';
import 'package:pilll/domain/menstruation/components/calendar/menstruation_calendar_header.dart';
import 'package:pilll/domain/menstruation/components/menstruation_card_list.dart';
import 'package:pilll/domain/menstruation/components/menstruation_record_button.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/hooks/automatic_keep_alive_client_mixin.dart';

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
