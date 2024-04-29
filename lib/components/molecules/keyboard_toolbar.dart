import 'package:flutter/material.dart';

const double keyboardToolbarHeight = 44;

class KeyboardToolbar extends StatelessWidget {
  final Widget doneButton;
  const KeyboardToolbar({super.key, required this.doneButton});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: keyboardToolbarHeight,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              const Spacer(),
              doneButton,
              const SizedBox(width: 10),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }
}
