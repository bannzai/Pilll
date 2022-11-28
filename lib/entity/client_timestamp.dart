import 'package:freezed_annotation/freezed_annotation.dart';

class ClientTimestamp implements Default {
  @override
  DateTime get defaultValue => DateTime.now();
}
