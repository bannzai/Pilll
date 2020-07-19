import 'package:Pilll/color.dart';
import 'package:Pilll/record/pill_sheet.dart';
import 'package:Pilll/record/record_taken_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
        primarySwatch: Colors.blue,
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilll'),
        backgroundColor: PilllColors.primary,
      ),
      body: Center(
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
      ),
    );
  }
}
