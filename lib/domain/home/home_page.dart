import 'package:pilll/analytics.dart';
import 'package:pilll/auth/auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/calendar/calendar_page.dart';
import 'package:pilll/domain/menstruation/menstruation_page.dart';
import 'package:pilll/domain/record/record_page.dart';
import 'package:pilll/domain/settings/settings_page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/service/push_notification.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../calendar/calendar_weekday_line.dart';

GlobalKey<_HomePageState> homeKey = GlobalKey();

class HomePage extends StatefulWidget {
  HomePage({required Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum HomePageTabType { record, menstruation, calendar, setting }

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RouteAware {
  late TabController _tabController;
  int _selectedIndex = 0;
  HomePageTabType get _selectedTab {
    return HomePageTabType.values[_selectedIndex];
  }

  final GlobalKey<CalendarPageState> calendarPageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: HomePageTabType.values.length,
        vsync: this,
        initialIndex: _selectedIndex);
    _tabController.addListener(_handleTabSelection);
    auth().then((auth) {
      requestNotificationPermissions();
      SettingService(DatabaseConnection(auth.uid)).fetch().then((setting) {
        if (setting.isOnReminder) {
          analytics.logEvent(name: "user_allowed_notification");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: HomePageTabType.values.length,
      child: Scaffold(
        backgroundColor: PilllColors.background,
        appBar: null,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border:
                Border(top: BorderSide(width: 1, color: PilllColors.border)),
          ),
          child: Ink(
            color: PilllColors.bottomBar,
            child: SafeArea(
              child: TabBar(
                controller: _tabController,
                labelColor: PilllColors.secondary,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: TextColor.gray,
                tabs: <Tab>[
                  Tab(
                    text: "ピル",
                    icon: SvgPicture.asset(
                        _tabController.index == HomePageTabType.record.index
                            ? "images/tab_icon_pill_enable.svg"
                            : "images/tab_icon_pill_disable.svg"),
                  ),
                  Tab(
                    text: "生理",
                    icon: SvgPicture.asset(_tabController.index ==
                            HomePageTabType.menstruation.index
                        ? "images/menstruation.svg"
                        : "images/menstruation_disable.svg"),
                  ),
                  Tab(
                    text: DateTimeFormatter.slashYearAndMonth(today()),
                    icon: SvgPicture.asset(
                        _tabController.index == HomePageTabType.calendar.index
                            ? "images/tab_icon_calendar_enable.svg"
                            : "images/tab_icon_calendar_disable.svg"),
                  ),
                  Tab(
                    text: "設定",
                    icon: SvgPicture.asset(
                        _tabController.index == HomePageTabType.setting.index
                            ? "images/tab_icon_setting_enable.svg"
                            : "images/tab_icon_setting_disable.svg"),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            RecordPage(),
            MenstruationPage(),
            CalendarPage(key: calendarPageKey),
            SettingsPage(),
            // SettingsPage(),
          ],
        ),
        floatingActionButton: Visibility(
          visible: _selectedTab == HomePageTabType.calendar,
          child: Container(
            padding: const EdgeInsets.only(right: 10, bottom: 32),
            child: FloatingActionButton(
              onPressed: () {
                switch (_selectedTab) {
                  case HomePageTabType.record:
                    break;
                  case HomePageTabType.menstruation:
                    break;
                  case HomePageTabType.calendar:
                    analytics.logEvent(name: "calendar_fab_pressed");
                    final context = calendarPageKey.currentContext;
                    final state = calendarPageKey.currentState;
                    assert(context != null && state != null);
                    if (context == null || state == null) {
                      return;
                    }
                    final date = today();
                    transitionToPostDiary(context, date, state.diaries);
                    break;
                  case HomePageTabType.setting:
                    break;
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
              backgroundColor: PilllColors.secondary,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTabSelection() {
    setState(() {
      if (_selectedIndex != _tabController.index) {
        _selectedIndex = _tabController.index;
        _screenTracking();
      }
    });
  }

  selectTab(HomePageTabType tab) {
    if (_selectedTab == tab) {
      return;
    }
    _tabController.animateTo(tab.index);
  }

  @override
  void didPush() {
    _screenTracking();
    super.didPush();
  }

  @override
  void didPop() {
    _screenTracking();
    super.didPop();
  }

  void _screenTracking() {
    analytics.setCurrentScreen(
      screenName: "${HomePageTabType.values[_tabController.index].screenName}",
    );
  }
}

extension HomePageTabFunctions on HomePageTabType {
  Widget widget() {
    switch (this) {
      case HomePageTabType.record:
        return RecordPage();
      case HomePageTabType.menstruation:
        return MenstruationPage();
      case HomePageTabType.calendar:
        return CalendarPage();
      case HomePageTabType.setting:
        return SettingsPage();
    }
  }

  String get screenName {
    switch (this) {
      case HomePageTabType.record:
        return "RecordPage";
      case HomePageTabType.menstruation:
        return "MenstruationPage";
      case HomePageTabType.calendar:
        return "CalendarPage";
      case HomePageTabType.setting:
        return "SettingsPage";
    }
  }
}
