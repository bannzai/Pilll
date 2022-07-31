import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';

final diarySettingStreamProvider =
    StreamProvider<DiarySetting?>((ref) => ref.watch(databaseProvider).diarySettingReference().snapshots().map((event) => event.data()));
