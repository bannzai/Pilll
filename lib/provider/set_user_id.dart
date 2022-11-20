import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod/riverpod.dart';

final setUserIDProvider = Provider((_) => SetUserID());

class SetUserID {
  Future<void> call({required String userID}) async {
    unawaited(FirebaseCrashlytics.instance.setUserIdentifier(userID));
    unawaited(firebaseAnalytics.setUserId(id: userID));

    // Keep call initialPurchase before logIn.
    await initializePurchase(userID);
    unawaited(Purchases.logIn(userID));
  }
}
