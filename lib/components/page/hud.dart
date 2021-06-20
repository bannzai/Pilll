import 'package:flutter/material.dart';
import 'package:pilll/components/molecules/indicator.dart';

class HUD extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final child = this.child;
    if (child != null && !shown) {
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
      ignoring: !shown,
      child: Stack(
        children: [
          if (shown) ...[
            if (barrierEnabled)
              Visibility(
                visible: shown,
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
