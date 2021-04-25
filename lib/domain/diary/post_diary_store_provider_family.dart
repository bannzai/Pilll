import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/diary.dart';

part 'post_diary_store_provider_family.freezed.dart';

@freezed
abstract class PostDiaryStoreProviderFamily
    with _$PostDiaryStoreProviderFamily {
  factory PostDiaryStoreProviderFamily({
    required DateTime date,
    required Diary? diary,
  }) = _PostDiaryStoreProviderFamily;
}
