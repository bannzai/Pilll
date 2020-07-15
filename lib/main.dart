import 'package:Pilll/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum Weekday {
  Sunday,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
}

class WeekdayFunctions {
  // Enumの値を文字列として扱えるようにする(あとで解説)
  static String weekdayString(Weekday weekday) {
    switch (weekday) {
      case Weekday.Sunday:
        return "日";
      case Weekday.Monday:
        return "月";
      case Weekday.Tuesday:
        return "火";
      case Weekday.Wednesday:
        return "水";
      case Weekday.Thursday:
        return "木";
      case Weekday.Friday:
        return "金";
      case Weekday.Saturday:
        return "土";
    }
  }

  static Color weekdayColor(Weekday weekday) {
    switch (weekday) {
      case Weekday.Sunday:
        return PilllColors.sunday;
      case Weekday.Monday:
        return PilllColors.weekday;
      case Weekday.Tuesday:
        return PilllColors.weekday;
      case Weekday.Wednesday:
        return PilllColors.weekday;
      case Weekday.Thursday:
        return PilllColors.weekday;
      case Weekday.Friday:
        return PilllColors.weekday;
      case Weekday.Saturday:
        return PilllColors.saturday;
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  int _calcIndex(int row, int line) {
    return row + 1 + (line - 1) * 7;
  }

  Widget _weekdayLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        return _weekdayElement(index);
      }),
    );
  }

  Widget _weekdayElement(int index) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
            width: 20,
            height: 30,
            decoration: BoxDecoration(color: PilllColors.mat)),
        Container(
          child: Text(WeekdayFunctions.weekdayString(Weekday.values[index]),
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: WeekdayFunctions.weekdayColor(Weekday.values[index]))),
        ),
      ],
    );
  }

  Widget _pillMarkLine(int line) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          return _pillMarkElement(_calcIndex(index, line));
        }),
      ),
    );
  }

  Widget _pillMarkElement(int index) {
    return Column(
      children: <Widget>[
        Text("$index", style: TextStyle(color: PilllColors.weekday)),
        _pillMark(),
      ],
    );
  }

  Widget _pillMark() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: PilllColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Pilll'),
        backgroundColor: PilllColors.primary,
      ),
      body: Center(
        child: Container(
          width: 316,
          height: 264,
          decoration: BoxDecoration(
            color: PilllColors.pillSheet,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 38,
                top: 84,
                child: SvgPicture.asset("images/pill_sheet_dot_line.svg"),
              ),
              Positioned(
                left: 38,
                top: 136,
                child: SvgPicture.asset("images/pill_sheet_dot_line.svg"),
              ),
              Positioned(
                left: 38,
                top: 190,
                child: SvgPicture.asset("images/pill_sheet_dot_line.svg"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (line) {
                    if (line == 0) {
                      return _weekdayLine();
                    }
                    return _pillMarkLine(line);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
