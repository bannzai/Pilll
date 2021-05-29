import 'package:flutter/material.dart';
import 'package:pilll/components/molecules/indicator.dart';

GlobalKey<_HUDState> hudKey = GlobalKey();

class HUD extends StatefulWidget {
  final Widget child;

  const HUD({Key? key, required this.child}) : super(key: key);
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
  bool _shown = false;
  bool _barrierEnabled = false;

  show() {
    setState(() {
      _shown = true;
      _barrierEnabled = true;
    });
  }

  hide() {
    setState(() {
      _shown = false;
      _barrierEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          ignoring: !_shown,
          child: Stack(
            children: [
              if (_shown) ...[
                if (_barrierEnabled)
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
        )
      ],
    );
  }
}

showHUD() {
  assert(hudKey.currentState != null);
  hudKey.currentState?.show();
}

hideHUD() {
  assert(hudKey.currentState != null);
  hudKey.currentState?.hide();
}
