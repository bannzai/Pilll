import 'package:Pilll/color.dart';
import 'package:Pilll/record/pill_sheet.dart';
import 'package:Pilll/record/record_taken_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: PilllColors.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  CupertinoTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController();
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: PilllColors.background,
      navigationBar:
          CupertinoNavigationBar(backgroundColor: PilllColors.primary),
      child: CupertinoTabScaffold(
        controller: _tabController,
        tabBar: CupertinoTabBar(
          backgroundColor: PilllColors.bottomBar,
          activeColor: PilllColors.primary,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                title: Text("ピル"),
                activeIcon: SvgPicture.asset("images/tab_icon_pill.svg",
                    color: PilllColors.primary),
                icon: SvgPicture.asset("images/tab_icon_pill.svg",
                    color: PilllColors.plainText)),
            BottomNavigationBarItem(
                title: Text("2020/07"),
                activeIcon: SvgPicture.asset("images/tab_icon_calendar.svg",
                    color: PilllColors.primary),
                icon: SvgPicture.asset("images/tab_icon_calendar.svg",
                    color: PilllColors.plainText)),
            BottomNavigationBarItem(
                title: Text("設定"),
                activeIcon: SvgPicture.asset("images/tab_icon_setting.svg",
                    color: PilllColors.primary),
                icon: SvgPicture.asset("images/tab_icon_setting.svg",
                    color: PilllColors.plainText)),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) {
              return _recordView();
            },
          );
        },
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
          PillSheet(),
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
