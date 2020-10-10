import 'package:Pilll/main/components/ripple.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/model/weekday.dart';
import 'package:Pilll/main/components/pill/pill_mark.dart';
import 'package:Pilll/main/record/weekday_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef PillMarkSelected = void Function(int);
typedef PillMarkTypeBuilder = PillMarkType Function(int);
typedef PillMarkTypePointBuilder = bool Function(int);

class PillSheet extends StatefulWidget {
  static Size size = Size(316, 264);
  final bool isHideWeekdayLine;
  final PillMarkTypeBuilder pillMarkTypeBuilder;
  final PillMarkTypePointBuilder pillMakrtTypePointBuilder;
  final PillMarkSelected markSelected;

  const PillSheet({
    Key key,
    @required this.isHideWeekdayLine,
    @required this.pillMarkTypeBuilder,
    @required this.pillMakrtTypePointBuilder,
    @required this.markSelected,
  }) : super(key: key);

  @override
  _PillSheetState createState() => _PillSheetState();
}

class _PillSheetState extends State<PillSheet> with TickerProviderStateMixin {
  int _calcIndex(int row, int line) {
    return row + 1 + (line) * 7;
  }

  Widget _weekdayLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        return WeekdayBadge(weekday: Weekday.values[index]);
      }),
    );
  }

  Widget _pillMarkWithNumber(int number) {
    var type = widget.pillMarkTypeBuilder(number);
    return Column(
      children: <Widget>[
        Text("$number", style: TextStyle(color: PilllColors.weekday)),
        PillMark(
          key: number == 1 ? stickyKey : null,
          type: type,
          tapped: () {
            widget.markSelected(number);
          },
        ),
      ],
    );
  }

  Widget _pillMarkLine(int line) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          return _pillMarkWithNumber(_calcIndex(index, line));
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PillSheet.size.width,
      height: PillSheet.size.height,
      decoration: BoxDecoration(
        color: PilllColors.pillSheet,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 38,
            top: widget.isHideWeekdayLine ? 64 : 84,
            child: SvgPicture.asset("images/pill_sheet_dot_line.svg"),
          ),
          Positioned(
            left: 38,
            top: widget.isHideWeekdayLine ? 124 : 136,
            child: SvgPicture.asset("images/pill_sheet_dot_line.svg"),
          ),
          Positioned(
            left: 38,
            top: widget.isHideWeekdayLine ? 188 : 190,
            child: SvgPicture.asset("images/pill_sheet_dot_line.svg"),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!widget.isHideWeekdayLine) _weekdayLine() else Container(),
                ...List.generate(4, (line) {
                  return _pillMarkLine(line);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AnimationController _controller;

  OverlayEntry sticky;

  GlobalKey stickyKey = GlobalKey();

  @override
  void initState() {
    if (sticky != null) {
      sticky.remove();
    }
    sticky = OverlayEntry(
      builder: (context) => stickyBuilder(context),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(sticky);
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    sticky.remove();
    super.dispose();
  }

  Widget stickyBuilder(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, Widget child) {
        final keyContext = stickyKey.currentContext;
        if (keyContext != null) {
          final box = keyContext.findRenderObject() as RenderBox;
          final pos = box.localToGlobal(Offset.zero);
          return Positioned(
            top: pos.dy,
            left: pos.dx,
            height: box.size.height,
            child: CustomPaint(
              painter: CirclePainter(
                _controller,
                color: PilllColors.primary,
              ),
              child: Container(
                width: box.size.width * 4.125,
                height: box.size.height * 4.125,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
