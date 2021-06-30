import 'package:flutter/material.dart';
import 'package:pilll/components/molecules/indicator.dart';

class HUD extends StatefulWidget {
  final bool shown;
  final bool barrierEnabled;
  final Widget? child;

  const HUD({
    Key? key,
    required this.child,
    required this.shown,
    this.barrierEnabled = true,
  }) : super(key: key);

  @override
  _HUDState createState() => _HUDState();

  static _HUDState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_HUDState>();
    if (state == null) {
      throw AssertionError('''
      Not found HUD from this context: $context
      The context should contains HUD widget into current widget tree
      ''');
    }
    return state;
  }
}

class _HUDState extends State<HUD> {
  bool shown = false;
  show() {
    setState(() {
      shown = true;
    });
  }

  hide() {
    setState(() {
      shown = false;
    });
  }

  bool get _shown => widget.shown || shown;

  @override
  Widget build(BuildContext context) {
    final child = this.widget.child;
    if (child != null && !_shown) {
      return child;
    }
    if (child == null) {
      return _hud(context);
    }
    return Stack(
      children: [
        child,
        _hud(context),
      ],
    );
  }

  Widget _hud(BuildContext context) {
    return IgnorePointer(
      ignoring: !_shown,
      child: Stack(
        children: [
          if (_shown) ...[
            if (widget.barrierEnabled)
              Visibility(
                visible: _shown,
                child: ModalBarrier(
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
            Center(child: Indicator()),
          ],
        ],
      ),
    );
  }
}
