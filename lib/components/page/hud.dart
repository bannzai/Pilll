import 'package:flutter/material.dart';
import 'package:pilll/components/molecules/indicator.dart';

class _InheritedWidget extends InheritedWidget {
  const _InheritedWidget({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  final HUDState state;

  @override
  bool updateShouldNotify(covariant _InheritedWidget oldWidget) {
    return false;
  }
}

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
  HUDState createState() => HUDState();
}

class HUDState extends State<HUD> {
  bool _shown = false;
  void show() {
    setState(() {
      _shown = true;
    });
  }

  void hide() {
    setState(() {
      _shown = false;
    });
  }

  bool get shown => widget.shown || _shown;

  @override
  Widget build(BuildContext context) {
    return _InheritedWidget(state: this, child: _body(context));
  }

  Widget _body(BuildContext context) {
    final child = widget.child;
    if (child == null) {
      return _hud(context);
    }
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        child,
        _hud(context),
      ],
    );
  }

  Widget _hud(BuildContext context) {
    return IgnorePointer(
      ignoring: !shown,
      child: Stack(
        children: [
          if (shown) ...[
            if (widget.barrierEnabled)
              Visibility(
                visible: shown,
                child: ModalBarrier(
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
            const Center(child: Indicator()),
          ],
        ],
      ),
    );
  }
}
