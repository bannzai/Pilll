import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/web_view.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/features/initial_setting/migrate_info.dart';
import 'package:pilll/features/premium_function_survey/premium_function_survey_page.dart';
import 'package:pilll/features/settings/components/churn/churn_survey_complete_dialog.dart';
import 'package:pilll/features/store_review/pre_store_review_modal.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/features/calendar/calendar_page.dart';
import 'package:pilll/features/menstruation/menstruation_page.dart';
import 'package:pilll/features/record/record_page.dart';
import 'package:pilll/features/settings/setting_page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/utils/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HomePageTabType { record, menstruation, calendar, setting }

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final registerRemotePushNotificationToken = ref.watch(registerRemotePushNotificationTokenProvider);

    useEffect(() {
      final userValue = user.valueOrNull;
      if (userValue != null) {
        // Android 13ユーザー向けに通知の許可を取る必要がある。古いバージョンからアップグレードしたユーザーへの許可はアプリのメインストリームが始まってから取得するようにする
        // https://developer.android.com/guide/topics/ui/notifiers/notification-permission
        requestNotificationPermissions(registerRemotePushNotificationToken);
      }
      return null;
    }, [user.valueOrNull]);

    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    return AsyncValueGroup.group3(
      user,
      ref.watch(userProvider),
      ref.watch(shouldShowMigrationInformationProvider),
    ).when(
      data: (data) {
        return HomePageBody(
          user: data.t1,
          premiumAndTrial: data.t2,
          shouldShowMigrateInfo: data.t3,
          sharedPreferences: sharedPreferences,
          registerReminderLocalNotification: registerReminderLocalNotification,
        );
      },
      error: (error, stackTrace) => UniversalErrorPage(
        error: error,
        reload: () => ref.refresh(shouldShowMigrationInformationProvider),
        child: null,
      ),
      loading: () => const Indicator(),
    );
  }
}

class HomePageBody extends HookConsumerWidget {
  final User user;
  final PremiumAndTrial premiumAndTrial;
  final bool shouldShowMigrateInfo;
  final SharedPreferences sharedPreferences;
  final RegisterReminderLocalNotification registerReminderLocalNotification;

  const HomePageBody({
    Key? key,
    required this.user,
    required this.shouldShowMigrateInfo,
    required this.premiumAndTrial,
    required this.sharedPreferences,
    required this.registerReminderLocalNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(0);
    final ticker = useSingleTickerProvider();
    final tabController = useTabController(initialLength: HomePageTabType.values.length, vsync: ticker);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
      _screenTracking(tabController.index);
    });

    final isAlreadyShowPremiumSurvey = sharedPreferences.getBool(BoolKey.isAlreadyShowPremiumSurvey) ?? false;
    final isAlreadyAnsweredPreStoreReviewModal = sharedPreferences.getBool(BoolKey.isAlreadyAnsweredPreStoreReviewModal) ?? false;
    final totalCountOfActionForTakenPill = sharedPreferences.getInt(IntKey.totalCountOfActionForTakenPill) ?? 0;
    final disableShouldAskCancelReason = ref.watch(disableShouldAskCancelReasonProvider);
    final shouldAskCancelReason = user.shouldAskCancelReason;
    final shouldShowPremiumFunctionSurvey = () {
      if (premiumAndTrial.trialIsAlreadyBegin) {
        return false;
      }
      if (premiumAndTrial.premiumOrTrial) {
        return false;
      }
      if (premiumAndTrial.isNotYetStartTrial) {
        return false;
      }
      return !isAlreadyShowPremiumSurvey;
    }();

    Future.microtask(() async {
      final pendingReminderNotifications = await localNotificationService.pendingReminderNotifications();
      if (pendingReminderNotifications.isEmpty) {
        await registerReminderLocalNotification.call();
      }
    });

    Future.microtask(() async {
      if (shouldShowMigrateInfo) {
        showDialog(
            context: context,
            barrierColor: Colors.white,
            builder: (context) {
              return const MigrateInfo();
            });
      } else if (shouldShowPremiumFunctionSurvey) {
        sharedPreferences.setBool(BoolKey.isAlreadyShowPremiumSurvey, true);
        Navigator.of(context).push(PremiumFunctionSurveyPageRoutes.route());
      } else if (shouldAskCancelReason) {
        await Navigator.of(context).push(
          WebViewPageRoute.route(
            title: "解約後のアンケートご協力のお願い",
            url: "https://docs.google.com/forms/d/e/1FAIpQLScmxg1amJik_8viuPI3MeDCzz7FuBDXeIHWzorbXRKR38yp7g/viewform",
          ),
        );
        disableShouldAskCancelReason();
        // ignore: use_build_context_synchronously
        showDialog(context: context, builder: (_) => const ChurnSurveyCompleteDialog());
      } else if (!isAlreadyAnsweredPreStoreReviewModal && totalCountOfActionForTakenPill > 10) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => const PreStoreReviewModal(),
        );
        sharedPreferences.setBool(BoolKey.isAlreadyAnsweredPreStoreReviewModal, true);
      }
    });

    return DefaultTabController(
      length: HomePageTabType.values.length,
      child: Scaffold(
        backgroundColor: PilllColors.background,
        appBar: null,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: PilllColors.border)),
          ),
          child: Ink(
            color: PilllColors.bottomBar,
            child: SafeArea(
              child: TabBar(
                controller: tabController,
                labelColor: PilllColors.primary,
                labelStyle: const TextStyle(fontSize: 12),
                indicatorColor: Colors.transparent,
                unselectedLabelColor: TextColor.gray,
                tabs: <Tab>[
                  Tab(
                    text: "ピル",
                    icon: SvgPicture.asset(
                        tabIndex.value == HomePageTabType.record.index ? "images/tab_icon_pill_enable.svg" : "images/tab_icon_pill_disable.svg"),
                  ),
                  Tab(
                    text: "生理",
                    icon: SvgPicture.asset(
                        tabIndex.value == HomePageTabType.menstruation.index ? "images/menstruation.svg" : "images/menstruation_disable.svg"),
                  ),
                  Tab(
                    text: "カレンダー",
                    icon: SvgPicture.asset(tabIndex.value == HomePageTabType.calendar.index
                        ? "images/tab_icon_calendar_enable.svg"
                        : "images/tab_icon_calendar_disable.svg"),
                  ),
                  Tab(
                    text: "設定",
                    icon: SvgPicture.asset(tabIndex.value == HomePageTabType.setting.index
                        ? "images/tab_icon_setting_enable.svg"
                        : "images/tab_icon_setting_disable.svg"),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: const <Widget>[
            RecordPage(),
            MenstruationPage(),
            CalendarPage(),
            SettingPage(),
          ],
        ),
      ),
    );
  }

  void _screenTracking(int index) {
    analytics.setCurrentScreen(
      screenName: HomePageTabType.values[index].screenName,
    );
  }
}

extension HomePageTabFunctions on HomePageTabType {
  Widget widget() {
    switch (this) {
      case HomePageTabType.record:
        return const RecordPage();
      case HomePageTabType.menstruation:
        return const MenstruationPage();
      case HomePageTabType.calendar:
        return const CalendarPage();
      case HomePageTabType.setting:
        return const SettingPage();
    }
  }

  String get screenName {
    switch (this) {
      case HomePageTabType.record:
        return "RecordPage";
      case HomePageTabType.menstruation:
        return "MenstruationPage";
      case HomePageTabType.calendar:
        return "CalendarPage";
      case HomePageTabType.setting:
        return "SettingsPage";
    }
  }
}
