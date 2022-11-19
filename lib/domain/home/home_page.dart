import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/domain/calendar/calendar_page.dart';
import 'package:pilll/domain/menstruation/menstruation_page.dart';
import 'package:pilll/domain/record/record_page.dart';
import 'package:pilll/domain/settings/setting_page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/service/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum HomePageTabType { record, menstruation, calendar, setting }

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final registerRemotePushNotificationToken = ref.watch(registerRemotePushNotificationTokenProvider);
    useEffect(() {
      final userValue = user.valueOrNull;
      if (userValue != null) {
        // Android 13ユーザー向けに通知の許可を取る必要がある。古いバージョンからアップグレードしたユーザーへの許可はアプリのメインストリームが始まってから取得するようにする
        // https://developer.android.com/guide/topics/ui/notifiers/notification-permission
        requestNotificationPermissions(registerRemotePushNotificationToken);
      }
      return null;
    }, [user.valueOrNull]);

    final tabController = useTabController(initialLength: HomePageTabType.values.length);
    tabController.addListener(() {
      _screenTracking(tabController.index);
    });

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
                controller: tabController,
                labelColor: PilllColors.secondary,
                labelStyle: const TextStyle(fontSize: 12),
                indicatorColor: Colors.transparent,
                unselectedLabelColor: TextColor.gray,
                tabs: <Tab>[
                  Tab(
                    text: "ピル",
                    icon: SvgPicture.asset(
                        tabController.index == HomePageTabType.record.index ? "images/tab_icon_pill_enable.svg" : "images/tab_icon_pill_disable.svg"),
                  ),
                  Tab(
                    text: "生理",
                    icon: SvgPicture.asset(
                        tabController.index == HomePageTabType.menstruation.index ? "images/menstruation.svg" : "images/menstruation_disable.svg"),
                  ),
                  Tab(
                    text: "カレンダー",
                    icon: SvgPicture.asset(tabController.index == HomePageTabType.calendar.index
                        ? "images/tab_icon_calendar_enable.svg"
                        : "images/tab_icon_calendar_disable.svg"),
                  ),
                  Tab(
                    text: "設定",
                    icon: SvgPicture.asset(tabController.index == HomePageTabType.setting.index
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
          controller: tabController,
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

  void _screenTracking(int index) {
    analytics.setCurrentScreen(
      screenName: HomePageTabType.values[index].screenName,
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
