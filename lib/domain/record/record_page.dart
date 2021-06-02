import 'dart:io' show Platform;

import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/pill/pill_sheet.dart';
import 'package:pilll/domain/demography/demography_page.dart';
import 'package:pilll/domain/initial_setting/migrate_info.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/record_taken_information.dart';
import 'package:pilll/domain/release_note/release_note.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/signin/signin_sheet.dart';
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
    final state = useProvider(recordPageStoreProvider.state);
    final store = useProvider(recordPageStoreProvider);
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
        titleSpacing: 0,
        backgroundColor: PilllColors.white,
        toolbarHeight: RecordTakenInformationConst.height,
        title: RecordTakenInformation(
          today: DateTime.now(),
          state: state,
          onPressed: () {
            analytics.logEvent(name: "tapped_record_information_header");
            if (currentPillSheet != null) {
              _showBeginDatePicker(context, currentPillSheet, store);
            }
          },
        ),
      ),
      body: _body(context),
    );
  }

  _showBeginDatePicker(
      BuildContext context, PillSheet currentPillSheet, RecordPageStore store) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        var selectedTodayPillNumber = currentPillSheet.todayPillNumber;
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
                  children: List.generate(currentPillSheet.typeInfo.totalCount,
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
    final state = useProvider(recordPageStoreProvider.state);
    final currentPillSheet = state.entity;
    final store = useProvider(recordPageStoreProvider);
    final settingEntity = state.setting;
    if (settingEntity == null || !state.firstLoadIsEnded) {
      return Indicator();
    }
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _notification(context, state, store),
                SizedBox(height: 64),
                _content(
                    context, store, state, currentPillSheet, settingEntity),
              ],
            ),
          ),
        ),
        if (currentPillSheet != null)
          Positioned(
            bottom: 20,
            child: _button(context, currentPillSheet, store),
          ),
      ],
    );
  }

  Widget _content(
    BuildContext context,
    RecordPageStore store,
    RecordPageState state,
    PillSheet? currentPillSheet,
    Setting settingEntity,
  ) {
    if (state.isInvalid)
      return _empty(context, store, settingEntity.pillSheetType);
    if (!state.isInvalid && currentPillSheet != null)
      return _pillSheet(context, currentPillSheet, store);
    throw AssertionError("invalid state ${state.toString()}");
  }

  Widget _button(
      BuildContext context, PillSheet currentPillSheet, RecordPageStore store) {
    if (currentPillSheet.allTaken)
      return _cancelTakeButton(currentPillSheet, store);
    else
      return _takenButton(context, currentPillSheet, store);
  }

  Widget _notification(
    BuildContext context,
    RecordPageState state,
    RecordPageStore store,
  ) {
    final recommendedSignupNotification = state.recommendedSignupNotification;
    if (recommendedSignupNotification.isNotEmpty) {
      return GestureDetector(
        onTap: () => showSigninSheet(context, false, (linkAccount) {
          analytics.logEvent(name: "signined_account_from_notification_bar");
          showDemographyPageIfNeeded(context);
        }),
        child: Container(
          height: 64,
          color: PilllColors.secondary,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    analytics.logEvent(
                        name: "record_page_signing_notification_closed");
                    store.closeRecommendedSignupNotification();
                  }),
              Column(
                children: [
                  SizedBox(height: 12),
                  Text(
                    recommendedSignupNotification,
                    style: TextColorStyle.white.merge(FontType.descriptionBold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 8),
                  IconButton(
                    icon: SvgPicture.asset(
                      "images/arrow_right.svg",
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final restDurationNotification = state.restDurationNotification;
    if (restDurationNotification.isNotEmpty) {
      return Container(
        constraints: BoxConstraints.expand(
          height: 26,
          width: MediaQuery.of(context).size.width,
        ),
        color: PilllColors.secondary,
        child: Center(
          child: Text(restDurationNotification,
              style: FontType.assistingBold.merge(TextColorStyle.white)),
        ),
      );
    }

    return Container();
  }

  Widget _takenButton(
    BuildContext context,
    PillSheet pillSheet,
    RecordPageStore store,
  ) {
    return PrimaryButton(
      text: "飲んだ",
      onPressed: () {
        if (pillSheet.todayPillNumber == 1)
          analytics.logEvent(name: "user_taken_first_day_pill");
        analytics.logEvent(name: "taken_button_pressed", parameters: {
          "last_taken_pill_number": pillSheet.lastTakenPillNumber,
          "today_pill_number": pillSheet.todayPillNumber,
        });
        _take(context, pillSheet, now(), store);
      },
    );
  }

  Widget _cancelTakeButton(PillSheet pillSheet, RecordPageStore store) {
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
    PillSheet pillSheet,
    DateTime takenDate,
    RecordPageStore store,
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

  void _cancelTake(PillSheet pillSheet, RecordPageStore store) {
    if (pillSheet.todayPillNumber != pillSheet.lastTakenPillNumber) {
      return;
    }
    final lastTakenDate = pillSheet.lastTakenDate;
    if (lastTakenDate == null) {
      return;
    }
    store.take(lastTakenDate.subtract(Duration(days: 1)));
  }

  PillSheetView _pillSheet(
    BuildContext context,
    PillSheet pillSheet,
    RecordPageStore store,
  ) {
    return PillSheetView(
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

  Widget _empty(BuildContext context, RecordPageStore store,
      PillSheetType pillSheetType) {
    var progressing = false;
    return GestureDetector(
      child: SizedBox(
        width: PillSheetView.width,
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

        var pillSheet = PillSheet.create(pillSheetType);
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
      final key = IntKey.totalCountOfActionForTakenPill;
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
