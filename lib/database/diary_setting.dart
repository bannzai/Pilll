import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/database/database.dart';

final diarieSettingStreamProvider =
    StreamProvider((ref) => ref.watch(databaseProvider).diarySettingReference().snapshots().);
