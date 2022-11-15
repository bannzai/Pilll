import 'package:pilll/analytics.dart';
import 'package:pilll/domain/calendar/calendar_page.dart';
import 'package:pilll/domain/menstruation/menstruation_page.dart';
import 'package:pilll/domain/record/record_page.dart';
import 'package:pilll/domain/settings/setting_page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/service/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

GlobalKey<_HomePageState> homeKey = GlobalKey();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum HomePageTabType { record, menstruation, calendar, setting }

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, RouteAware {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: HomePageTabType.values.length, vsync: this, initialIndex: _selectedIndex);
    _tabController.addListener(_handleTabSelection);

    Future(() async {
      // Android 13ユーザー向けに通知の許可を取る必要がある。古いバージョンからアップグレードしたユーザーへの許可はアプリのメインストリームが始まってから取得するようにする
      // https://developer.android.com/guide/topics/ui/notifiers/notification-permission
      await requestNotificationPermissions();
      listenNotificationEvents();
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
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: PilllColors.border)),
          ),
          child: Ink(
            color: PilllColors.bottomBar,
            child: SafeArea(
              child: TabBar(
                controller: _tabController,
                labelColor: PilllColors.secondary,
                labelStyle: const TextStyle(fontSize: 12),
                indicatorColor: Colors.transparent,
                unselectedLabelColor: TextColor.gray,
                tabs: <Tab>[
                  Tab(
                    text: "ピル",
                    icon: SvgPicture.asset(_tabController.index == HomePageTabType.record.index
                        ? "images/tab_icon_pill_enable.svg"
                        : "images/tab_icon_pill_disable.svg"),
                  ),
                  Tab(
                    text: "生理",
                    icon: SvgPicture.asset(
                        _tabController.index == HomePageTabType.menstruation.index ? "images/menstruation.svg" : "images/menstruation_disable.svg"),
                  ),
                  Tab(
                    text: "カレンダー",
                    icon: SvgPicture.asset(_tabController.index == HomePageTabType.calendar.index
                        ? "images/tab_icon_calendar_enable.svg"
                        : "images/tab_icon_calendar_disable.svg"),
                  ),
                  Tab(
                    text: "設定",
                    icon: SvgPicture.asset(_tabController.index == HomePageTabType.setting.index
                        ? "images/tab_icon_setting_enable.svg"
                        : "images/tab_icon_setting_disable.svg"),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const <Widget>[
            RecordPage(),
            MenstruationPage(),
            CalendarPage(),
            SettingPage(),
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
      screenName: HomePageTabType.values[_tabController.index].screenName,
    );
  }
}

extension HomePageTabFunctions on HomePageTabType {
  Widget widget() {
    switch (this) {
      case HomePageTabType.record:
        return const RecordPage();
      case HomePageTabType.menstruation:
        return const MenstruationPage();
      case HomePageTabType.calendar:
        return const CalendarPage();
      case HomePageTabType.setting:
        return const SettingPage();
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
