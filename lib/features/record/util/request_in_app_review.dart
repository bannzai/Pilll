import 'package:in_app_review/in_app_review.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

void requestInAppReview() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  int count = sharedPreferences.getInt(IntKey.totalCountOfActionForTakenPill) ?? 0;
  sharedPreferences.setInt(IntKey.totalCountOfActionForTakenPill, count + 1);

  final isGoodAnswer = sharedPreferences.getBool(BoolKey.isPreStoreReviewGoodAnswer) ?? false;
  if (!isGoodAnswer) {
    return;
  }

  if (await InAppReview.instance.isAvailable()) {
    await InAppReview.instance.requestReview();
  }
}
