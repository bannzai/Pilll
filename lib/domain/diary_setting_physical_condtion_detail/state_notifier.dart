import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/diary_setting_physical_condtion_detail/state.codegen.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';
import 'package:pilll/util/datetime/day.dart';

import 'package:riverpod/riverpod.dart';

final diarySettingPhysicalConditionDetailStateNotifierProvider =
    StateNotifierProvider.autoDispose<DiarySettingPhysicalConditionDetailStateNotifier, AsyncValue<DiarySettingPhysicalConditionDetailState>>(
  (ref) => DiarySettingPhysicalConditionDetailStateNotifier(
    initialState: ref.watch(diarySettingPhysicalConditionDetailAsyncStateProvider),
  ),
);

class DiarySettingPhysicalConditionDetailStateNotifier extends StateNotifier<AsyncValue<DiarySettingPhysicalConditionDetailState>> {
  DiarySettingPhysicalConditionDetailStateNotifier({
    required AsyncValue<DiarySettingPhysicalConditionDetailState> initialState,
  }) : super(initialState);

  DiarySettingPhysicalConditionDetailState? get value => state.value;

  void select({required String physicalConditionDetail}) {
    state = AsyncValue.data(value!.copyWith(selected: value!.selected..add(physicalConditionDetail)));
  }

  void deleted() {
    state = AsyncValue.data(value!.copyWith(selected: []));
  }
}

final createDiarySettingPhysicalConditionDetailProvider =
    Provider.autoDispose((ref) => CreateDiarySettingPhysicalConditionDetail(ref.watch(databaseProvider).diarySettingReference()));

class CreateDiarySettingPhysicalConditionDetail {
  final DocumentReference<DiarySetting> reference;
  CreateDiarySettingPhysicalConditionDetail(this.reference);

  Future<void> call() async {
    await reference.set(DiarySetting(createdAt: now()), SetOptions(merge: true));
  }
}

final addDiarySettingPhysicalConditionDetailProvider =
    Provider.autoDispose((ref) => AddDiarySettingPhysicalConditionDetail(ref.watch(databaseProvider).diarySettingReference()));

class AddDiarySettingPhysicalConditionDetail {
  final DocumentReference<DiarySetting> reference;
  AddDiarySettingPhysicalConditionDetail(this.reference);

  Future<void> call({required DiarySetting diarySetting, required String physicalConditionDetail}) async {
    await reference.set(
        diarySetting.copyWith(physicalConditions: diarySetting.physicalConditions..add(physicalConditionDetail)), SetOptions(merge: true));
  }
}

final deleteDiarySettingPhysicalConditionDetailProvider = Provider.autoDispose((ref) => ref.watch(databaseProvider).diarySettingReference());

class DeleteDiarySettingPhysicalConditionDetail {
  final DocumentReference<DiarySetting> reference;
  DeleteDiarySettingPhysicalConditionDetail(this.reference);

  Future<void> call({required DiarySetting diarySetting, required List<String> physicalConditionDetails}) async {
    await reference.set(diarySetting.copyWith(physicalConditions: diarySetting.physicalConditions..removeWhere(physicalConditionDetails.contains)),
        SetOptions(merge: true));
  }
}
