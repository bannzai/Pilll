import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';

/// テストの間だけグローバルな [L] を言語コード [lang] (例: 'en') の文言に差し替える
///
/// test / testWidgets の本体から呼ぶ前提で、そのテストの終了時 (addTearDown) に元の [L] へ戻す。
void useLanguage(String lang) {
  final originalL = L;
  addTearDown(() => L = originalL);
  L = lookupAppLocalizations(Locale(lang));
}
