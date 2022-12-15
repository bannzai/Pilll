import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';

final diarySettingProvider =
    StreamProvider<DiarySetting?>((ref) => ref.watch(databaseProvider).diarySettingReference().snapshots().map((event) => event.data()));
