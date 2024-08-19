import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
part 'number_range.codegen.freezed.dart';

@freezed
class PillNumberRange with _$PillNumberRange {
  const factory PillNumberRange({
    required PillSheet pillSheet,
    required int begin,
    required int end,
  }) = _PillNumberRange;

  const PillNumberRange._();

  List<int> get numbers => List.generate(pillSheet.typeInfo.totalCount, (index) {
        if (begin <= end) {
          return index + begin;
        }
        if (index + begin < pillSheet.typeInfo.totalCount) {
          return index + begin;
        } else {
          return index + begin - pillSheet.typeInfo.totalCount;
        }
      }).toList();
}
