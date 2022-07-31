import 'package:equatable/equatable.dart';
import 'package:pilll/entity/diary.codegen.dart';

class DiaryPostStateProviderFamily extends Equatable {
  final DateTime date;
  final Diary? diary;

  const DiaryPostStateProviderFamily({
    required this.date,
    required this.diary,
  });

// NOTE: When diary.physicalConditions did change, DiaryPostPage can not changed for sex,memo,physical condition status.
// if DiaryPostStoreProviderFamily with @\freezed object or props contains [diary].
  @override
  List<Object?> get props => [date];
}
