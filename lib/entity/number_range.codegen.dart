import 'package:freezed_annotation/freezed_annotation.dart';
part 'number_range.codegen.freezed.dart';

@freezed
class PillNumberRange with _$PillNumberRange {
  const factory PillNumberRange({
    required int groupIndex,
    required int begin,
    required int end,
  }) = _PillNumberRange;
}
