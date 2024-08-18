import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class PillNumberRange with _$PillNumberRange {
  final int groupIndex;
  final int begin;
  final int end;

  PillNumberRange({
    required this.groupIndex,
    required this.begin,
    required this.end,
  });
}
