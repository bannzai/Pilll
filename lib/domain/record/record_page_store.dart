import 'dart:io' show Platform;
import 'dart:async';

import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final recordPageStoreProvider = StateNotifierProvider((ref) => RecordPageStore(
      ref.watch(batchFactoryProvider),
      ref.watch(pillSheetServiceProvider),
      ref.watch(settingServiceProvider),
      ref.watch(userServiceProvider),
      ref.watch(authServiceProvider),
      ref.watch(pillSheetModifiedHistoryServiceProvider),
      ref.watch(pillSheetGroupServiceProvider),
    ));

class RecordPageStore extends StateNotifier<RecordPageState> {
  final BatchFactory _batchFactory;
  final PillSheetService _pillSheetService;
  final SettingService _settingService;
  final UserService _userService;
  final AuthService _authService;
  final PillSheetModifiedHistoryService _pillSheetModifiedHistoryService;
  final PillSheetGroupService _pillSheetGroupService;
  RecordPageStore(
    this._batchFactory,
    this._pillSheetService,
    this._settingService,
    this._userService,
    this._authService,
    this._pillSheetModifiedHistoryService,
    this._pillSheetGroupService,
  ) : super(RecordPageState()) {
    reset();
  }

  void reset() {
    Future(() async {
      final pillSheetGroup = await _pillSheetGroupService.fetchLatest();
      final setting = await _settingService.fetch();
      final sharedPreferences = await SharedPreferences.getInstance();
      final user = await _userService.fetch();
      final totalCountOfActionForTakenPill =
          sharedPreferences.getInt(IntKey.totalCountOfActionForTakenPill) ?? 0;
      final shouldShowMigrateInfo = () {
        if (!Platform.isIOS) {
          return false;
        }
        if (sharedPreferences.getBool(BoolKey.migrateFrom132IsShown) ?? false) {
          return false;
        }
        if (!sharedPreferences
            .containsKey(StringKey.salvagedOldStartTakenDate)) {
          return false;
        }
        if (!sharedPreferences
            .containsKey(StringKey.salvagedOldLastTakenDate)) {
          return false;
        }
        return true;
      }();
      final recommendedSignupNotificationIsAlreadyShow = sharedPreferences
              .getBool(BoolKey.recommendedSignupNotificationIsAlreadyShow) ??
          false;
      final premiumTrialGuideNotificationIsClosed = sharedPreferences
              .getBool(BoolKey.premiumTrialGuideNotificationIsClosed) ??
          false;
      state = RecordPageState(
        pillSheetGroup: pillSheetGroup,
        setting: setting,
        firstLoadIsEnded: true,
        totalCountOfActionForTakenPill: totalCountOfActionForTakenPill,
        exception: null,
        isAlreadyShowTiral:
            sharedPreferences.getBool(BoolKey.isAlreadyShowPremiumTrialModal) ??
                false,
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        hasDiscountEntitlement: user.hasDiscountEntitlement,
        discountEntitlementDeadlineDate: user.discountEntitlementDeadlineDate,
        shouldShowMigrateInfo: shouldShowMigrateInfo,
        isLinkedLoginProvider:
            _authService.isLinkedApple() || _authService.isLinkedGoogle(),
        recommendedSignupNotificationIsAlreadyShow:
            recommendedSignupNotificationIsAlreadyShow,
        premiumTrialGuideNotificationIsClosed:
            premiumTrialGuideNotificationIsClosed,
      );
      _subscribe();
    });
  }

  StreamSubscription? _pillSheetGroupCanceller;
  StreamSubscription? _settingCanceller;
  StreamSubscription? _userSubscribeCanceller;
  StreamSubscription? _authServiceCanceller;
  void _subscribe() {
    _pillSheetGroupCanceller?.cancel();
    _pillSheetGroupCanceller =
        _pillSheetGroupService.subscribeForLatest().listen((event) {
      state = state.copyWith(pillSheetGroup: event);
    });
    _settingCanceller?.cancel();
    _settingCanceller = _settingService.subscribe().listen((setting) {
      state = state.copyWith(setting: setting);
    });
    _userSubscribeCanceller?.cancel();
    _userSubscribeCanceller = _userService.subscribe().listen((event) {
      state = state.copyWith(
        isPremium: event.isPremium,
        isTrial: event.isTrial,
        hasDiscountEntitlement: event.hasDiscountEntitlement,
        trialDeadlineDate: event.trialDeadlineDate,
        discountEntitlementDeadlineDate: event.discountEntitlementDeadlineDate,
      );
    });
    _authServiceCanceller?.cancel();
    _authServiceCanceller = _authService.subscribe().listen((event) {
      state = state.copyWith(
          isLinkedLoginProvider:
              _authService.isLinkedApple() || _authService.isLinkedGoogle());
    });
  }

  @override
  void dispose() {
    _pillSheetGroupCanceller?.cancel();
    _settingCanceller?.cancel();
    _userSubscribeCanceller?.cancel();
    _authServiceCanceller?.cancel();
    super.dispose();
  }

  Future<void> register(Setting setting) async {
    final batch = _batchFactory.batch();

    final Map<String, PillSheet> idAndPillSheet = {};
    final n = now();

    var i = 0;
    setting.pillSheetTypes.forEach((pillSheetType) {
      final pillSheet = PillSheet(
        typeInfo: pillSheetType.typeInfo,
        beginingDate: n.add(
          Duration(days: pillSheetType.totalCount * i),
        ),
        groupIndex: i,
      );

      final createdPillSheet = _pillSheetService.register(batch, pillSheet);
      final pillSheetID = createdPillSheet.id;
      if (pillSheetID == null) {
        throw FormatException(
            "ピルシートのIDの登録に失敗しました。設定 > お問い合わせからご報告していただけると幸いです");
      }
      idAndPillSheet[pillSheetID] = createdPillSheet;

      i++;
    });

    final pillSheetIDs = idAndPillSheet.keys.toList();
    final pillSheets = idAndPillSheet.values.toList();
    final pillSheetGroup =
        PillSheetGroup(pillSheetIDs: pillSheetIDs, pillSheets: pillSheets);
    _pillSheetGroupService.register(batch, pillSheetGroup);

    final history = PillSheetModifiedHistoryServiceActionFactory
        .createCreatedPillSheetAction(
      pillSheetIDs: pillSheetIDs,
      pillSheetGroupID: pillSheetGroup.id,
    );
    _pillSheetModifiedHistoryService.add(batch, history);

    _settingService.updateWithBatch(batch, setting);

    return batch.commit();
  }

  Future<dynamic>? _take(DateTime takenDate) async {
    final pillSheetGroup = state.pillSheetGroup;
    if (pillSheetGroup == null) {
      throw FormatException("pill sheet group not found");
    }
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      throw FormatException("active pill sheet not found");
    }
    if (activedPillSheet.todayPillNumber ==
        activedPillSheet.lastTakenPillNumber) {
      return null;
    }
    final updatedPillSheetGroup = await take(
      takenDate: takenDate,
      pillSheetGroup: pillSheetGroup,
      activedPillSheet: activedPillSheet,
      batchFactory: _batchFactory,
      pillSheetService: _pillSheetService,
      pillSheetModifiedHistoryService: _pillSheetModifiedHistoryService,
      pillSheetGroupService: _pillSheetGroupService,
    );
    if (updatedPillSheetGroup == null) {
      return null;
    }
    state = state.copyWith(pillSheetGroup: updatedPillSheetGroup);
  }

  Future<void>? taken() {
    return _take(now());
  }

  Future<void>? takenWithPillNumber({
    required int pillNumberIntoPillSheet,
    required PillSheet pillSheet,
  }) async {
    final activedPillSheet = state.pillSheetGroup?.activedPillSheet;
    if (activedPillSheet == null) {
      return null;
    }
    if (activedPillSheet.id != pillSheet.id) {
      return null;
    }
    if (pillNumberIntoPillSheet <= activedPillSheet.lastTakenPillNumber) {
      return null;
    }
    var diff = activedPillSheet.todayPillNumber - pillNumberIntoPillSheet;
    if (diff < 0) {
      // This is in the future pill number.
      return null;
    }
    var takenDate = now().subtract(Duration(days: diff));
    return _take(takenDate);
  }

  Future<void> cancelTaken() async {
    final pillSheetGroup = state.pillSheetGroup;
    if (pillSheetGroup == null) {
      throw FormatException("pill sheet group not found");
    }
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      throw FormatException("active pill sheet not found");
    }
    if (activedPillSheet.todayPillNumber !=
        activedPillSheet.lastTakenPillNumber) {
      return;
    }
    final lastTakenDate = activedPillSheet.lastTakenDate;
    if (lastTakenDate == null) {
      return;
    }

    final batch = _batchFactory.batch();

    final updatedPillSheet = activedPillSheet.copyWith(
        lastTakenDate: lastTakenDate.subtract(Duration(days: 1)));
    _pillSheetService.update(batch, updatedPillSheet);

    final history = PillSheetModifiedHistoryServiceActionFactory
        .createRevertTakenPillAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: activedPillSheet,
      after: updatedPillSheet,
    );
    _pillSheetModifiedHistoryService.add(batch, history);

    final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);
    _pillSheetGroupService.update(batch, updatedPillSheetGroup);

    await batch.commit();
    state = state.copyWith(pillSheetGroup: updatedPillSheetGroup);
  }

  bool isDone({
    required int pillNumberIntoPillSheet,
    required PillSheet pillSheet,
  }) {
    final activedPillSheet = state.pillSheetGroup?.activedPillSheet;
    if (activedPillSheet == null) {
      throw FormatException("pill sheet not found");
    }
    if (activedPillSheet.groupIndex < pillSheet.groupIndex) {
      return false;
    }
    if (activedPillSheet.id != pillSheet.id) {
      if (pillSheet.isOutOfRange) {
        if (pillNumberIntoPillSheet > pillSheet.lastTakenPillNumber) {
          return false;
        }
      }
      return true;
    }

    return pillNumberIntoPillSheet <= activedPillSheet.lastTakenPillNumber;
  }

  PillMarkType markFor({
    required int pillNumberIntoPillSheet,
    required PillSheet pillSheet,
  }) {
    if (pillNumberIntoPillSheet > pillSheet.typeInfo.dosingPeriod) {
      return pillSheet.pillSheetType == PillSheetType.pillsheet_21
          ? PillMarkType.rest
          : PillMarkType.fake;
    }
    if (pillNumberIntoPillSheet <= pillSheet.lastTakenPillNumber) {
      return PillMarkType.done;
    }
    if (pillNumberIntoPillSheet < pillSheet.todayPillNumber) {
      return PillMarkType.normal;
    }
    return PillMarkType.normal;
  }

  bool shouldPillMarkAnimation({
    required int pillNumberIntoPillSheet,
    required PillSheet pillSheet,
  }) {
    final activedPillSheet = state.pillSheetGroup?.activedPillSheet;
    if (activedPillSheet == null) {
      throw FormatException("pill sheet not found");
    }
    if (activedPillSheet.groupIndex < pillSheet.groupIndex) {
      return false;
    }
    if (activedPillSheet.id != pillSheet.id) {
      if (pillSheet.isOutOfRange) {
        if (pillNumberIntoPillSheet > pillSheet.lastTakenPillNumber) {
          return true;
        }
      }
      return false;
    }

    return pillNumberIntoPillSheet > activedPillSheet.lastTakenPillNumber &&
        pillNumberIntoPillSheet <= activedPillSheet.todayPillNumber;
  }

  handleException(Object exception) {
    state = state.copyWith(exception: exception);
  }

  shownMigrateInfo() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(BoolKey.migrateFrom132IsShown, true);
    state = state.copyWith(shouldShowMigrateInfo: false);
  }

  addPillSheetType(PillSheetType pillSheetType, Setting setting) {
    final updatedSetting = setting.copyWith(
        pillSheetTypes: setting.pillSheetTypes..add(pillSheetType));
    state = state.copyWith(setting: updatedSetting);
  }

  changePillSheetType(int index, PillSheetType pillSheetType, Setting setting) {
    final copied = [...setting.pillSheetTypes];
    copied[index] = pillSheetType;

    final updatedSetting = setting.copyWith(pillSheetTypes: copied);
    state = state.copyWith(setting: updatedSetting);
  }

  removePillSheetType(int index, Setting setting) {
    final copied = [...setting.pillSheetTypes];
    copied.removeAt(index);

    final updatedSetting = setting.copyWith(pillSheetTypes: copied);
    state = state.copyWith(setting: updatedSetting);
  }
}

DateTime calcBeginingDateFromNextTodayPillNumberFunction(
  PillSheet pillSheet,
  int pillNumber,
) {
  if (pillNumber == pillSheet.todayPillNumber) return pillSheet.beginingDate;
  final diff = pillNumber - pillSheet.todayPillNumber;
  return pillSheet.beginingDate.subtract(Duration(days: diff));
}
