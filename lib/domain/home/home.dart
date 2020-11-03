import 'package:Pilll/domain/calendar/calendar_page.dart';
import 'package:Pilll/domain/record/record_page.dart';
import 'package:Pilll/domain/settings/settings.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
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
                labelColor: PilllColors.primary,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: TextColor.gray,
                tabs: <Tab>[
                  Tab(
                      text: "ピル",
                      icon: SvgPicture.asset("images/tab_icon_pill.svg",
                          color: _tabController.index == 0
                              ? PilllColors.primary
                              : TextColor.gray)),
                  Tab(
                      text: "2020/07",
                      icon: SvgPicture.asset("images/tab_icon_calendar.svg",
                          color: _tabController.index == 1
                              ? PilllColors.primary
                              : TextColor.gray)),
                  Tab(
                      text: "設定",
                      icon: SvgPicture.asset("images/tab_icon_setting.svg",
                          color: _tabController.index == 2
                              ? PilllColors.primary
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
            Settings(),
            // Settings(),
          ],
        ),
      ),
    );
  }
}
