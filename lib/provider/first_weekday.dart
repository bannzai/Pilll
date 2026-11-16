import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

/// カレンダーと生理タブの週の行の左端に置く曜日。
/// 設定の「週の始まりを月曜日にする」を一度も切り替えていない端末は、この設定を足す前の表示と同じ日曜日にする。
final firstWeekdayProvider = Provider<Weekday>(
  (ref) => ref.watch(boolSharedPreferencesProvider(BoolKey.isFirstWeekdayMonday)).value == true ? Weekday.Monday : Weekday.Sunday,
  dependencies: [boolSharedPreferencesProvider],
);
