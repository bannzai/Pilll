import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.dart';

part 'notification_bar_store_parameter.freezed.dart';

@freezed
abstract class NotificationBarStoreParameter
    with _$NotificationBarStoreParameter {
  factory NotificationBarStoreParameter({
    required PillSheet? pillSheet,
    required bool isLinkedLoginProvider,
    required int totalCountOfActionForTakenPill,
  }) = _NotificationBarStoreParameter;
}
