import 'package:equatable/equatable.dart';
import 'package:pilll/entity/diary.codegen.dart';

// ref: https://riverpod.dev/docs/concepts/modifiers/family/
// > A tuple from tuple
// > Objects generated with Freezed or built_value
// > Objects using equatable
class PostDiaryStoreProviderFamily extends Equatable {
  final DateTime date;
  final Diary? diary;

  const PostDiaryStoreProviderFamily({
    required this.date,
    required this.diary,
  });

// NOTE: When diary.physicalConditions did change, PostDiaryPage can not changed for sex,memo,physical condition status.
// if PostDiaryStoreProviderFamily with @\freezed object or props contains [diary].
  @override
  List<Object?> get props => [date];
}
