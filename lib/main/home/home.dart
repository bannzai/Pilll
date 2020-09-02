import 'package:Pilll/main/record/pill_sheet.dart';
import 'package:Pilll/main/record/record_taken_information.dart';
import 'package:Pilll/settings/settings.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/text_color.dart';
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
        appBar: AppBar(
          title: Text('Pilll'),
          backgroundColor: PilllColors.primary,
        ),
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
            Settings(),
            _recordView(),
            _recordView(),
            // Settings(),
          ],
        ),
      ),
    );
  }

  Center _recordView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 60),
          RecordTakenInformation(),
          SizedBox(height: 24),
          PillSheet(
            isHideWeekdayLine: false,
          ),
          SizedBox(height: 24),
          Container(
            height: 44,
            width: 180,
            child: RaisedButton(
              child: Text("飲んだ"),
              color: PilllColors.primary,
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
