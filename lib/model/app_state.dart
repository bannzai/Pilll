import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  final bool value;

  AppState(this.value) {
    print("value: $value");
  }
}
