import 'dart:io' show Platform;

import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/pill/pill_sheet.dart';
import 'package:pilll/domain/initial_setting/migrate_info.dart';
import 'package:pilll/domain/record/record_taken_information.dart';
import 'package:pilll/domain/release_note/release_note.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/state/pill_sheet.dart';
import 'package:pilll/store/pill_sheet.dart';
import 'package:pilll/store/setting.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isAlreadyShowModal = false;

class RecordPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(pillSheetStoreProvider.state);
    final store = useProvider(pillSheetStoreProvider);
    final currentPillSheet = state.entity;
    if (!isAlreadyShowModal) {
      isAlreadyShowModal = true;
      Future.delayed(Duration(seconds: 1)).then((_) {
        _showMigrateInfo(context);
      });
    }
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: PilllColors.white,
        toolbarHeight: 130,
        title: RecordTakenInformation(
          today: DateTime.now(),
          state: state,
          onPressed: () {
            analytics.logEvent(name: "tapped_record_information_header");
            if (currentPillSheet != null) {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  var selectedTodayPillNumber =
                      currentPillSheet.todayPillNumber;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      PickerToolbar(
                        done: (() {
                          store.modifyBeginingDate(selectedTodayPillNumber);
                          Navigator.pop(context);
                        }),
                        cancel: (() {
                          Navigator.pop(context);
                        }),
                      ),
                      Container(
                        height: 200,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CupertinoPicker(
                            itemExtent: 40,
                            children: List.generate(
                                currentPillSheet.typeInfo.totalCount,
                                (index) => Text("${index + 1}")),
                            onSelectedItemChanged: (index) {
                              selectedTodayPillNumber = index + 1;
                            },
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedTodayPillNumber - 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: _body(context),
    );
  }

  _showMigrateInfo(BuildContext context) {
    if (!Platform.isIOS) {
      return;
    }
    final key = "migrate_from_132_is_shown_9";
    SharedPreferences.getInstance().then((storage) {
      if (storage.getBool(key) ?? false) {
        return;
      }
      if (!storage.containsKey(StringKey.salvagedOldStartTakenDate)) {
        return;
      }
      if (!storage.containsKey(StringKey.salvagedOldLastTakenDate)) {
        return;
      }
      showDialog(
          context: context,
          barrierColor: Colors.white,
          builder: (context) {
            return MigrateInfo(
              onClose: () {
                storage.setBool(key, true);
                Navigator.of(context).pop();
              },
            );
          });
    });
  }

  Widget _body(BuildContext context) {
    final state = useProvider(pillSheetStoreProvider.state);
    final currentPillSheet = state.entity;
    final store = useProvider(pillSheetStoreProvider);
    final settingState = useProvider(settingStoreProvider.state);
    final settingEntity = settingState.entity;
    if (settingEntity == null || !store.firstLoadIsEnded) {
      return Indicator();
    }
    return Center(
      child: ListView(
        children: [
          if (_notificationString(state).isNotEmpty)
            ConstrainedBox(
              constraints: BoxConstraints.expand(height: 26),
              child: Container(
                height: 26,
                color: PilllColors.secondary,
                child: Center(
                  child: Text(_notificationString(state),
                      style:
                          FontType.assistingBold.merge(TextColorStyle.white)),
                ),
              ),
            ),
          SizedBox(height: 67),
          if (state.isInvalid)
            Align(child: _empty(context, store, settingEntity.pillSheetType)),
          if (!state.isInvalid && currentPillSheet != null) ...[
            Align(child: _pillSheet(context, currentPillSheet, store)),
            SizedBox(height: 40),
            if (currentPillSheet.allTaken)
              Align(child: _cancelTakeButton(currentPillSheet, store)),
            if (!currentPillSheet.allTaken)
              Align(child: _takenButton(context, currentPillSheet, store)),
          ],
          SizedBox(height: 60),
        ],
      ),
    );
  }

  String _notificationString(PillSheetState state) {
    if (state.isInvalid) {
      return "";
    }
    final pillSheet = state.entity;
    if (pillSheet == null) {
      return "";
    }
    if (pillSheet.pillSheetType.isNotExistsNotTakenDuration) {
      return "";
    }
    if (pillSheet.typeInfo.dosingPeriod < pillSheet.todayPillNumber) {
      return "${pillSheet.pillSheetType.notTakenWord}期間中";
    }

    final threshold = 4;
    if (pillSheet.typeInfo.dosingPeriod - threshold + 1 <
        pillSheet.todayPillNumber) {
      final diff = pillSheet.typeInfo.dosingPeriod - pillSheet.todayPillNumber;
      return "あと${diff + 1}日で${pillSheet.pillSheetType.notTakenWord}期間です";
    }

    return "";
  }

  Widget _takenButton(
    BuildContext context,
    PillSheetModel pillSheet,
    PillSheetStateStore store,
  ) {
    if (pillSheet.todayPillNumber == 1)
      analytics.logEvent(name: "user_taken_first_day_pill");
    return PrimaryButton(
      text: "飲んだ",
      onPressed: () {
        analytics.logEvent(name: "taken_button_pressed", parameters: {
          "last_taken_pill_number": pillSheet.lastTakenPillNumber,
          "today_pill_number": pillSheet.todayPillNumber,
        });
        _take(context, pillSheet, now(), store);
      },
    );
  }

  Widget _cancelTakeButton(
      PillSheetModel pillSheet, PillSheetStateStore store) {
    return TertiaryButton(
      text: "飲んでない",
      onPressed: () {
        analytics.logEvent(name: "cancel_taken_button_pressed", parameters: {
          "last_taken_pill_number": pillSheet.lastTakenPillNumber,
          "today_pill_number": pillSheet.todayPillNumber,
        });
        _cancelTake(pillSheet, store);
      },
    );
  }

  void _take(
    BuildContext context,
    PillSheetModel pillSheet,
    DateTime takenDate,
    PillSheetStateStore store,
  ) {
    if (pillSheet.todayPillNumber == pillSheet.lastTakenPillNumber) {
      return;
    }
    store.take(takenDate).then((value) {
      _requestInAppReview();
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        showReleaseNotePreDialog(context);
      });
    });
  }

  void _cancelTake(PillSheetModel pillSheet, PillSheetStateStore store) {
    if (pillSheet.todayPillNumber != pillSheet.lastTakenPillNumber) {
      return;
    }
    final lastTakenDate = pillSheet.lastTakenDate;
    if (lastTakenDate == null) {
      return;
    }
    store.take(lastTakenDate.subtract(Duration(days: 1)));
  }

  PillSheet _pillSheet(
    BuildContext context,
    PillSheetModel pillSheet,
    PillSheetStateStore store,
  ) {
    return PillSheet(
      firstWeekday: WeekdayFunctions.weekdayFromDate(pillSheet.beginingDate),
      pillSheetType: pillSheet.pillSheetType,
      doneStateBuilder: (number) {
        return number <= pillSheet.lastTakenPillNumber;
      },
      pillMarkTypeBuilder: (number) => store.markFor(number),
      enabledMarkAnimation: (number) => store.shouldPillMarkAnimation(number),
      markSelected: (number) {
        analytics.logEvent(name: "pill_mark_tapped", parameters: {
          "number": number,
          "last_taken_pill_number": pillSheet.lastTakenPillNumber,
          "today_pill_number": pillSheet.todayPillNumber,
        });
        if (number <= pillSheet.lastTakenPillNumber) {
          return;
        }
        var diff = pillSheet.todayPillNumber - number;
        if (diff < 0) {
          // This is in the future pill number.
          return;
        }
        var takenDate = now().subtract(Duration(days: diff));
        _take(context, pillSheet, takenDate, store);
      },
    );
  }

  Widget _empty(BuildContext context, PillSheetStateStore store,
      PillSheetType pillSheetType) {
    var progressing = false;
    return GestureDetector(
      child: SizedBox(
        width: PillSheet.width,
        height: 316,
        child: Stack(
          children: <Widget>[
            Center(
              child: SvgPicture.asset(
                "images/empty_frame.svg",
              ),
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, color: TextColor.noshime),
                Text("ピルシートを追加",
                    style: FontType.assisting.merge(TextColorStyle.noshime)),
              ],
            )),
          ],
        ),
      ),
      onTap: () {
        if (progressing) return;
        progressing = true;

        var pillSheet = PillSheetModel.create(pillSheetType);
        store.register(pillSheet).catchError((error) {
          showErrorAlert(
            context,
            message: "ピルシートがすでに存在しています。表示等に問題がある場合は設定タブから「お問い合わせ」ください",
          );
        }, test: (e) => e is PillSheetAlreadyExists).catchError((error) {
          showErrorAlert(
            context,
            message: "ピルシートの作成に失敗しました。時間をおいて再度お試しください",
          );
        }, test: (e) => e is PillSheetAlreadyDeleted).whenComplete(
            () => progressing = false);
      },
    );
  }

  _requestInAppReview() {
    SharedPreferences.getInstance().then((store) async {
      final key = IntKey.totalPillCount;
      int? value = store.getInt(key);
      if (value == null) {
        value = 0;
      }
      value += 1;
      store.setInt(key, value);
      if (value % 7 != 0) {
        return;
      }
      if (await InAppReview.instance.isAvailable()) {
        await InAppReview.instance.requestReview();
      }
    });
  }
}
