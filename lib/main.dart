import 'package:Pilll/theme/color.dart';
import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/initial_setting/initial_setting_1.dart';
import 'package:Pilll/main/record/pill_sheet.dart';
import 'package:Pilll/main/record/record_taken_information.dart';
import 'package:Pilll/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  initializeDateFormatting('ja_JP');
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<InitialSettingModel>(
            create: (_) => InitialSettingModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: PilllColors.primary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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

  Future<bool> getIsDidEndInitialSettingKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("isDidEndInitialSettingKey");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIsDidEndInitialSettingKey(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return InitialSetting();
          }
          if (!snapshot.data) {
            return InitialSetting();
          }
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
                  border: Border(
                      top: BorderSide(width: 1, color: PilllColors.border)),
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
                            icon: SvgPicture.asset(
                                "images/tab_icon_calendar.svg",
                                color: _tabController.index == 1
                                    ? PilllColors.primary
                                    : TextColor.gray)),
                        Tab(
                            text: "設定",
                            icon: SvgPicture.asset(
                                "images/tab_icon_setting.svg",
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
                  InitialSetting1(),
                  _recordView(),
                  _recordView(),
                ],
              ),
            ),
          );
        });
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
