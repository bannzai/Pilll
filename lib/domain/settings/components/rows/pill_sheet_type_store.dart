import 'dart:async';

import 'package:pilll/database/database.dart';
import 'package:pilll/domain/settings/components/rows/pill_sheet_type_state.dart';
import 'package:pilll/domain/settings/setting_page_state.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/service/setting.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetTypeStoreProvider = StateNotifierProvider.autoDispose.family(
  (ref, SettingState state) => PillSheetTypeStateStore(
    state,
    ref.watch(databaseProvider),
    ref.watch(settingServiceProvider),
  ),
);

class PillSheetTypeStateStore extends StateNotifier<PillSheetTypeState> {
  final DatabaseConnection _database;
  final SettingService _settingService;
  PillSheetTypeStateStore(
    SettingState state,
    this._database,
    this._settingService,
  ) : super(PillSheetTypeState(
          setting: state.entity,
          pillSheet: state.latestPillSheet,
        ));

  Future<void> modifyPillSheetType(PillSheetType pillSheetType) {
    final settingEntity = state.setting;
    if (settingEntity == null) {
      throw FormatException("settingEntity is necessary");
    }
    final pillSheetEntity = state.pillSheet;
    if (pillSheetEntity == null) {
      throw FormatException("pillSheetEntity is necessary");
    }
    if (pillSheetEntity.isInvalid) {
      return _settingService.update(
          settingEntity.copyWith(pillSheetTypeRawPath: pillSheetType.rawPath));
    } else {
      return _database.transaction(
        (transaction) {
          return Future.wait(
            [
              transaction
                  .get(
                      _database.pillSheetReference(pillSheetEntity.documentID!))
                  .then((pillSheetDocument) {
                transaction.update(pillSheetDocument.reference, {
                  PillSheetFirestoreKey.typeInfo:
                      pillSheetType.typeInfo.toJson()
                });
              }),
              transaction.get(_database.userReference()).then((userDocument) {
                transaction.update(userDocument.reference, {
                  UserFirestoreFieldKeys.settings: settingEntity
                      .copyWith(pillSheetTypeRawPath: pillSheetType.rawPath)
                      .toJson(),
                });
              })
            ],
          );
        },
      );
    }
  }

  bool shouldShowDiscardDialog(PillSheetType pillSheetType) {
    final pillSheetEntity = state.pillSheet;
    assert(pillSheetEntity != null);
    if (pillSheetEntity == null) {
      return false;
    }
    return pillSheetEntity.todayPillNumber > pillSheetType.totalCount;
  }
}
