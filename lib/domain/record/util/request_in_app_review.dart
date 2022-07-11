import 'package:in_app_review/in_app_review.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

void requestInAppReview() {
  SharedPreferences.getInstance().then((store) async {
    const key = IntKey.totalCountOfActionForTakenPill;
    int? value = store.getInt(key);
    value ??= 0;
    value += 1;
    store.setInt(key, value);
    if (value % 7 != 0) {
      return;
    }
    if (await InAppReview.instance.isAvailable()) {
      await InAppReview.instance.requestReview();
    }
  });
}
