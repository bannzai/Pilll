import 'package:Pilll/analytics.dart';
import 'package:Pilll/domain/calendar/calendar_page.dart';
import 'package:Pilll/domain/record/record_page.dart';
import 'package:Pilll/domain/settings/settings_page.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/util/datetime/day.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RouteAware {
  TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: _selectedIndex);
    _tabController.addListener(_handleTabSelection);
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
                labelColor: PilllColors.selected,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: TextColor.gray,
                tabs: <Tab>[
                  Tab(
                      text: "ピル",
                      icon: SvgPicture.asset("images/tab_icon_pill.svg",
                          color: _tabController.index == 0
                              ? PilllColors.selected
                              : TextColor.gray)),
                  Tab(
                      text: DateTimeFormatter.slashYearAndMonth(today()),
                      icon: SvgPicture.asset("images/tab_icon_calendar.svg",
                          color: _tabController.index == 1
                              ? PilllColors.selected
                              : TextColor.gray)),
                  Tab(
                      text: "設定",
                      icon: SvgPicture.asset("images/tab_icon_setting.svg",
                          color: _tabController.index == 2
                              ? PilllColors.selected
                              : TextColor.gray)),
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
