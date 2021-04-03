import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/store/menstruation_edit.dart';
import 'package:pilll/store/pill_sheet.dart';

class MenstruationPage extends HookWidget {
  final Menstruation entity;

  MenstruationPage(this.entity);
  @override
  Widget build(BuildContext context) {
    final store = useProvider(menstruationEditProvider(entity));
    final state = useProvider(menstruationEditProvider(entity).state);
    throw UnimplementedError();
  }
}
