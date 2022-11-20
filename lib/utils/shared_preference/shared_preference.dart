import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesBuilder<T> extends StatelessWidget {
  final String preferenceKey;
  final AsyncWidgetBuilder<T?> builder;

  const SharedPreferencesBuilder({
    Key? key,
    required this.preferenceKey,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T?>(future: _future(), builder: builder);
  }

  Future<T?> _future() async {
    return (await SharedPreferences.getInstance()).get(preferenceKey) as FutureOr<T?>;
  }
}
