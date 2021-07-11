import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/error_log.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final purchaseServiceProvider = Provider((ref) => PurchaseService());

class PurchaseService {
  Future<Offerings> fetchOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      return offerings;
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
      print(exception);
      rethrow;
    }
  }
}
