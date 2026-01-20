import 'package:flutter/cupertino.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/native/channel.dart';

// 種類を増やすならSwiftのコードの定義も追加する必要がある

enum ShareToSNSKind {
  X,
  // ignore: constant_identifier_names
  Facebook,
}

extension ShareToSNSKindExt on ShareToSNSKind {
  String get rawValue {
    switch (this) {
      case ShareToSNSKind.X:
        return 'X';
      case ShareToSNSKind.Facebook:
        return 'Facebook';
    }
  }
}

Future<void> presentShareToSNSForPremiumTrialReward(
  ShareToSNSKind shareToSNSKind,
  VoidCallback completionHandler,
) async {
  final result = await methodChannel.invokeMethod(
    'presentShareToSNSForPremiumTrialReward',
    {'shareToSNSKind': shareToSNSKind.rawValue},
  );
  if (result['result'] == 'success') {
    completionHandler();
    return;
  } else {
    throw AlertError(result['message'], title: result['title']);
  }
}
