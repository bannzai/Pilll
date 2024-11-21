import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';

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
        diarySetting.copyWith(physicalConditions: [...diarySetting.physicalConditions]..insert(0, physicalConditionDetail)), SetOptions(merge: true));
  }
}

final deleteDiarySettingPhysicalConditionDetailProvider =
    Provider.autoDispose((ref) => DeleteDiarySettingPhysicalConditionDetail(ref.watch(databaseProvider).diarySettingReference()));

class DeleteDiarySettingPhysicalConditionDetail {
  final DocumentReference<DiarySetting> reference;
  DeleteDiarySettingPhysicalConditionDetail(this.reference);

  Future<void> call({required DiarySetting diarySetting, required String physicalConditionDetail}) async {
    await reference.set(
        diarySetting.copyWith(physicalConditions: [...diarySetting.physicalConditions]..remove(physicalConditionDetail)), SetOptions(merge: true));
  }
}
