import 'package:pilll/analytics.dart';
import 'package:pilll/auth/auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/calendar/calendar_page.dart';
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

GlobalKey<_HomePageState> homeKey = GlobalKey();

class HomePage extends StatefulWidget {
  HomePage({@required Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum HomePageTabType { record, calendar, setting }

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RouteAware {
  TabController _tabController;
  int _selectedIndex = 0;
  HomePageTabType get _selectedTab {
    return HomePageTabType.values[_selectedIndex];
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: _selectedIndex);
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
      length: 3,
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
                    icon: SvgPicture.asset(_tabController.index == 0
                        ? "images/tab_icon_pill_enable.svg"
                        : "images/tab_icon_pill_disable.svg"),
                  ),
                  Tab(
                    text: DateTimeFormatter.slashYearAndMonth(today()),
                    icon: SvgPicture.asset(_tabController.index == 1
                        ? "images/tab_icon_calendar_enable.svg"
                        : "images/tab_icon_calendar_disable.svg"),
                  ),
                  Tab(
                    text: "設定",
                    icon: SvgPicture.asset(_tabController.index == 2
                        ? "images/tab_icon_setting_enable.svg"
                        : "images/tab_icon_setting_disable.svg"),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            RecordPage(),
            CalendarPage(),
            SettingsPage(),
            // SettingsPage(),
          ],
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
      screenName: "${HomePageTab.values[_tabController.index].screenName}",
    );
  }
}

enum HomePageTab { record, calendar, settings }

extension HomePageTabFunctions on HomePageTab {
  Widget widget() {
    switch (this) {
      case HomePageTab.record:
        return RecordPage();
      case HomePageTab.calendar:
        return CalendarPage();
      case HomePageTab.settings:
        return SettingsPage();
    }
    throw ArgumentError.notNull("HomePageTabFunctions#widget");
  }

  String get screenName {
    switch (this) {
      case HomePageTab.record:
        return "RecordPage";
      case HomePageTab.calendar:
        return "CalendarPage";
      case HomePageTab.settings:
        return "SettingsPage";
    }
    throw ArgumentError.notNull("HomePageTabFunctions#screenName");
  }
}
