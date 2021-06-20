import 'package:flutter/material.dart';
import 'package:pilll/components/molecules/indicator.dart';

class HUD extends StatelessWidget {
  final bool shown;
  final bool barrierEnabled;
  final Widget child;

  const HUD({
    Key? key,
    required this.child,
    required this.shown,
    required this.barrierEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        IgnorePointer(
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
        )
      ],
    );
  }
}
