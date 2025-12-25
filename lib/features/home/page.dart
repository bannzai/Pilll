import 'package:pilll/utils/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/web_view.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/error/page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/features/settings/components/churn/churn_survey_complete_dialog.dart';
import 'package:pilll/features/store_review/pre_store_review_modal.dart';
import 'package:pilll/provider/locale.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/calendar/page.dart';
import 'package:pilll/features/menstruation/page.dart';
import 'package:pilll/features/record/page.dart';
import 'package:pilll/features/settings/page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/push_notification.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HomePageTabType { record, menstruation, calendar, setting }

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    return AsyncValueGroup.group2(
      user,
      ref.watch(latestPillSheetGroupProvider),
    ).when(
      data: (data) {
        return HomePageBody(
          user: data.$1,
          pillSheetGroup: data.$2,
          sharedPreferences: sharedPreferences,
        );
      },
      error: (error, stackTrace) => UniversalErrorPage(
        error: error,
        reload: () => ref.refresh(latestPillSheetGroupProvider),
        child: null,
      ),
      loading: () => const ScaffoldIndicator(),
    );
  }
}

class HomePageBody extends HookConsumerWidget {
  final User user;
  final PillSheetGroup? pillSheetGroup;
  final SharedPreferences sharedPreferences;

  const HomePageBody({
    super.key,
    required this.user,
    required this.pillSheetGroup,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerRemotePushNotificationToken = ref.watch(registerRemotePushNotificationTokenProvider);
    final tabIndex = useState(0);
    final ticker = useSingleTickerProvider();
    final tabController = useTabController(initialLength: HomePageTabType.values.length, vsync: ticker);
    tabController.addListener(() {
      tabIndex.value = tabController.index;
      _screenTracking(tabController.index);
    });

    final isJaLocale = ref.watch(isJaLocaleProvider);
    final isAlreadyAnsweredPreStoreReviewModal = sharedPreferences.getBool(BoolKey.isAlreadyAnsweredPreStoreReviewModal) ?? false;
    final totalCountOfActionForTakenPill = sharedPreferences.getInt(IntKey.totalCountOfActionForTakenPill) ?? 0;
    final disableShouldAskCancelReason = ref.watch(disableShouldAskCancelReasonProvider);
    final shouldAskCancelReason = user.shouldAskCancelReason;
    final monthlyPremiumIntroductionSheetPresentedDateMilliSeconds =
        sharedPreferences.getInt(IntKey.monthlyPremiumIntroductionSheetPresentedDateMilliSeconds) ?? 0;
    final isOneMonthPassedSinceLastDisplayedMonthlyPremiumIntroductionSheet =
        now().millisecondsSinceEpoch - monthlyPremiumIntroductionSheetPresentedDateMilliSeconds > 1000 * 60 * 60 * 24 * 30;
    final bool isOneMonthPassedTrialDeadline;
    final trialDeadlineDate = user.trialDeadlineDate;
    if (trialDeadlineDate != null) {
      isOneMonthPassedTrialDeadline = now().millisecondsSinceEpoch - trialDeadlineDate.millisecondsSinceEpoch > 1000 * 60 * 60 * 24 * 30;
    } else {
      isOneMonthPassedTrialDeadline = false;
    }
    final error = useState<String?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
        if (shouldAskCancelReason) {
          await Navigator.of(context).push(
            WebViewPageRoute.route(
              title: L.requestForCancelSurvey,
              url: 'https://docs.google.com/forms/d/e/1FAIpQLScmxg1amJik_8viuPI3MeDCzz7FuBDXeIHWzorbXRKR38yp7g/viewform',
            ),
          );
          disableShouldAskCancelReason();
          // ignore: use_build_context_synchronously
          showDialog(context: context, builder: (_) => const ChurnSurveyCompleteDialog());
        } else if (!isAlreadyAnsweredPreStoreReviewModal && totalCountOfActionForTakenPill > 10 && isJaLocale) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => const PreStoreReviewModal(),
          );
          sharedPreferences.setBool(BoolKey.isAlreadyAnsweredPreStoreReviewModal, true);
        } else if (isOneMonthPassedTrialDeadline && isOneMonthPassedSinceLastDisplayedMonthlyPremiumIntroductionSheet && !user.premiumOrTrial) {
          if (!user.premiumOrTrial) {
            showPremiumIntroductionSheet(context);
            sharedPreferences.setInt(IntKey.monthlyPremiumIntroductionSheetPresentedDateMilliSeconds, now().millisecondsSinceEpoch);
          }
        }
      });

      return null;
    }, []);

    // NOTE: iOSではBackground Resolver的なアプローチで許可ダイアログが出たが、Androidではダイアログが出ない。ホーム画面で呼び出すことで表示されるのでここでrequestPermissionを呼び出す
    useEffect(() {
      // Android 13ユーザー向けに通知の許可を取る必要がある。古いバージョンからアップグレードしたユーザーへの許可はアプリのメインストリームが始まってから取得するようにする
      // https://developer.android.com/guide/topics/ui/notifiers/notification-permission
      Future<void> f() async {
        try {
          debugPrint('[DEBUG] PushNotificationResolver');
          await requestNotificationPermissions(registerRemotePushNotificationToken);
        } catch (e, stack) {
          errorLogger.recordError(e, stack);
          error.value = e.toString();
        }
      }

      f();

      return null;
    }, []);

    useEffect(() {
      final errorValue = error.value;
      if (errorValue != null) {
        WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
          showErrorAlert(context, errorValue);
          error.value = null;
        });
      }
      return null;
    }, [error.value]);

    return DefaultTabController(
      length: HomePageTabType.values.length,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: null,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: AppColors.border)),
          ),
          child: Ink(
            color: AppColors.bottomBar,
            child: SafeArea(
              child: TabBar(
                controller: tabController,
                labelColor: AppColors.primary,
                labelStyle: const TextStyle(fontSize: 12),
                indicatorColor: Colors.transparent,
                unselectedLabelColor: TextColor.gray,
                tabs: <Tab>[
                  Tab(
                    text: L.pill,
                    icon: SvgPicture.asset(
                        tabIndex.value == HomePageTabType.record.index ? 'images/tab_icon_pill_enable.svg' : 'images/tab_icon_pill_disable.svg'),
                  ),
                  Tab(
                    text: L.menstruation,
                    icon: SvgPicture.asset(
                        tabIndex.value == HomePageTabType.menstruation.index ? 'images/menstruation.svg' : 'images/menstruation_disable.svg'),
                  ),
                  Tab(
                    text: L.calendar,
                    icon: SvgPicture.asset(tabIndex.value == HomePageTabType.calendar.index
                        ? 'images/tab_icon_calendar_enable.svg'
                        : 'images/tab_icon_calendar_disable.svg'),
                  ),
                  Tab(
                    text: L.settings,
                    icon: SvgPicture.asset(tabIndex.value == HomePageTabType.setting.index
                        ? 'images/tab_icon_setting_enable.svg'
                        : 'images/tab_icon_setting_disable.svg'),
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
        return 'RecordPage';
      case HomePageTabType.menstruation:
        return 'MenstruationPage';
      case HomePageTabType.calendar:
        return 'CalendarPage';
      case HomePageTabType.setting:
        return 'SettingsPage';
    }
  }
}
