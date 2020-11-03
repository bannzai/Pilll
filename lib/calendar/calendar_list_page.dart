import 'package:Pilll/calendar/calculator.dart';
import 'package:Pilll/calendar/calendar.dart';
import 'package:Pilll/calendar/calendar_band_model.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class CalendarListPageModel {
  final Calculator calculator;
  final List<CalendarBandModel> bandModels;

  CalendarListPageModel(this.calculator, this.bandModels);
}

class CalendarListPage extends StatelessWidget {
  final List<CalendarListPageModel> models;

  const CalendarListPage({Key key, @required this.models}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: PilllColors.background,
      ),
      backgroundColor: PilllColors.background,
      body: ListView(
        children: _components(context),
      ),
    );
  }

  List<Widget> _components(BuildContext context) {
    return models.map((model) {
      return Column(
        children: <Widget>[
          _header(context, model),
          _calendar(context, model),
        ],
      );
    }).toList();
  }

  Widget _header(BuildContext context, CalendarListPageModel model) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 64),
      child: Row(
        children: [
          SizedBox(width: 16),
          Text(
            DateTimeFormatter.yearAndMonth(model.calculator.date),
            textAlign: TextAlign.left,
            style: FontType.cardHeader.merge(TextColorStyle.noshime),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _calendar(BuildContext context, CalendarListPageModel model) {
    return Calendar(calculator: model.calculator, bandModels: model.bandModels);
  }
}
