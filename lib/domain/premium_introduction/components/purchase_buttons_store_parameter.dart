import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
part 'purchase_buttons_store_parameter.freezed.dart';

@freezed
abstract class PurchaseButtonsStoreParameter
    with _$PurchaseButtonsStoreParameter {
  factory PurchaseButtonsStoreParameter({
    required Offerings offerings,
    required DateTime trialDeadlineDate,
  }) = _PurchaseButtonsStoreParameter;
}
