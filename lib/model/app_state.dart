import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();
}
