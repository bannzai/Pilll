import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pilll/domain/modal/release_note.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> effectAfterTaken({
  required BuildContext context,
  required Future<void>? taken,
  required RecordPageStore store,
}) async {
  final _taken = taken;
  if (_taken == null) {
    return;
  }
  try {
    await _taken;
    _requestInAppReview();
    await showReleaseNotePreDialog(context);
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
    store.handleException(exception);
  }
}

_requestInAppReview() {
  SharedPreferences.getInstance().then((store) async {
    final key = IntKey.totalCountOfActionForTakenPill;
    int? value = store.getInt(key);
    if (value == null) {
      value = 0;
    }
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
