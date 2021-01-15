import 'package:Pilll/domain/calendar/calculator.dart';
import 'package:Pilll/domain/calendar/calendar.dart';
import 'package:Pilll/domain/calendar/calendar_band_model.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
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
        backgroundColor: PilllColors.white,
      ),
      backgroundColor: PilllColors.white,
      body: SafeArea(
        child: ListView(
          children: _components(context),
        ),
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
    return Calendar(
      calculator: model.calculator,
      bandModels: model.bandModels,
      horizontalPadding: 0,
    );
  }
}

extension CalendarListPageRoute on CalendarListPage {
  static Route<dynamic> route(List<CalendarListPageModel> models) {
    return MaterialPageRoute(
      settings: RouteSettings(name: "CalendarListPage"),
      builder: (_) => CalendarListPage(models: models),
    );
  }
}
