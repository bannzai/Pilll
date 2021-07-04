import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/pill/pill_mark.dart';
import 'package:pilll/components/organisms/pill/pill_sheet.dart';
import 'package:pilll/domain/initial_setting/migrate_info.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/record/components/button/record_page_button.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store_parameter.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/record_taken_information.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/toolbar/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecordPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(recordPageStoreProvider.state);
    final store = useProvider(recordPageStoreProvider);
    final currentPillSheet = state.entity;
    Future.delayed(Duration(seconds: 1)).then((_) {
      if (!state.shouldShowMigrateInfo) {
        return;
      }
      showDialog(
          context: context,
          barrierColor: Colors.white,
          builder: (context) {
            return MigrateInfo(
              onClose: () async {
                await store.shownMigrateInfo();
                Navigator.of(context).pop();
              },
            );
          });
    });

    Future.delayed(Duration(seconds: 1)).then((_) {
      if (!state.shouldShowTrial) {
        return;
      }
      showPremiumTrialModalWhenLaunchApp(context, () {
        showPremiumTrialCompleteModalPreDialog(context);
      });
    });

    return UniversalErrorPage(
      error: state.exception,
      reload: () => store.reset(),
      child: Scaffold(
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
      ),
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
                NotificationBar(
                  NotificationBarStoreParameter(
                      pillSheet: state.entity,
                      totalCountOfActionForTakenPill:
                          state.totalCountOfActionForTakenPill),
                ),
                SizedBox(height: 64),
                if (state.isInvalid)
                  _empty(context, store, settingEntity.pillSheetType),
                if (!state.isInvalid && currentPillSheet != null)
                  _pillSheet(context, state, store),
              ],
            ),
          ),
        ),
        if (currentPillSheet != null)
          Positioned(
            bottom: 20,
            child: RecordPageButton(currentPillSheet: currentPillSheet),
          ),
      ],
    );
  }

  PillSheetView _pillSheet(
    BuildContext context,
    RecordPageState state,
    RecordPageStore store,
  ) {
    final pillSheet = state.entity;
    final setting = state.setting;
    if (pillSheet == null || setting == null) {
      throw FormatException(
          "Unexpected pillSheet or setting are null for state of ${state.toString()}");
    }
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
        take(context, pillSheet, takenDate, store);
      },
      premiumMarkBuilder: state.isPremium &&
              state.appearanceMode == PillSheetAppearanceMode.date
          ? (pillMarkNumber) {
              final date = pillSheet.beginingDate
                  .add(Duration(days: pillMarkNumber - 1));
              return PremiumPillMarkModel(
                date,
                pillMarkNumber,
                setting.pillNumberForFromMenstruation,
                setting.durationMenstruation,
                pillSheet.pillSheetType.totalCount,
              );
            }
          : null,
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
      onTap: () async {
        if (progressing) return;
        progressing = true;

        var pillSheet = PillSheet.create(pillSheetType);
        try {
          await store.register(pillSheet);
        } on PillSheetAlreadyExists catch (_) {
          showErrorAlert(
            context,
            message: "ピルシートがすでに存在しています。表示等に問題がある場合は設定タブから「お問い合わせ」ください",
          );
        } on PillSheetAlreadyDeleted catch (_) {
          showErrorAlert(
            context,
            message: "ピルシートの作成に失敗しました。時間をおいて再度お試しください",
          );
        } catch (exception, stack) {
          errorLogger.recordError(exception, stack);
          store.handleException(exception);
        } finally {
          progressing = false;
        }
      },
    );
  }
}
