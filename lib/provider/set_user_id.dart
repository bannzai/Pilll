import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
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

    // 初期設定のログインで別のアカウントに切り替わった時は SDK を設定済みのため、logIn で RevenueCat のユーザーを切り替え、
    // 呼び出し側がそのユーザーの CustomerInfo を読めるよう完了を待つ
    if (await Purchases.isConfigured && await Purchases.appUserID != userID) {
      // 通知のアクション (fetchCustomerInfoOutsideUI) が先に別のユーザーで SDK を設定した時は initializePurchase を通らないため、ここでも登録する。
      // listener は SDK が Set で持つため、同じ関数を何度登録しても 1 つになる
      Purchases.addCustomerInfoUpdateListener(callUpdatePurchaseInfo);
      await logInPurchasesUser(uid: userID, currentFirebaseUserID: () => FirebaseAuth.instance.currentUser?.uid);
      return;
    }
    // Keep call initialPurchase before logIn.
    await initializePurchase(userID);
    unawaited(Purchases.logIn(userID));
  }
}
