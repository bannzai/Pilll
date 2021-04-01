import 'package:pilll/domain/calendar/calendar_state.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CalendarListPageModel {
  final CalendarState calendarState;
  final List<CalendarBandModel> bandModels;

  CalendarListPageModel(this.calendarState, this.bandModels);
}

abstract class CalendarListPageConst {
  static double headerHeight = 64;
}

class CalendarListPage extends HookWidget {
  final List<CalendarListPageModel> models;
  final GlobalKey currentMonthKey = GlobalKey();

  CalendarListPage({Key? key, required this.models}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double initialOffset = 0;
    final previousMonth = DateTime(today().year, today().month, 0);
    Function(Calendar) sideEffect = (calendar) {
      if (calendar.date().isBefore(previousMonth)) {
        initialOffset += calendar.height() + CalendarListPageConst.headerHeight;
      }
    };
    final components = _components(context, sideEffect);
    final scrollController = useScrollController();

// FIXME: ListView won't render non-visible items. Meaning that target most likely will not be build at all.
// See also: https://stackoverflow.com/questions/49153087/flutter-scrolling-to-a-widget-in-listview
    Future(() async {
      await Future.delayed(Duration(seconds: 1));
      await scrollController.animateTo(initialOffset,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });

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
          controller: scrollController,
          children: components,
        ),
      ),
    );
  }

  List<Widget> _components(
      BuildContext context, Function(Calendar) eachCalendar) {
    final components = models.map((model) {
      final calendar = _calendar(context, model);
      eachCalendar(calendar);
      return Column(
        children: <Widget>[
          _header(context, model),
          calendar,
        ],
      );
    }).toList();
    return components;
  }

  Widget _header(BuildContext context, CalendarListPageModel model) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.expand(height: CalendarListPageConst.headerHeight),
      child: Row(
        children: [
          SizedBox(width: 16),
          Text(
            DateTimeFormatter.yearAndMonth(model.calendarState.date),
            textAlign: TextAlign.left,
            style: FontType.cardHeader.merge(TextColorStyle.noshime),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  Calendar _calendar(BuildContext context, CalendarListPageModel model) {
    return Calendar(
      key: isSameMonth(model.calendarState.date, today())
          ? currentMonthKey
          : null,
      calendarState: model.calendarState,
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
