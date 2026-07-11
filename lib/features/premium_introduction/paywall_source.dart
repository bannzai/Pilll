/// PremiumIntroductionSheet / SpecialOfferingPage の起動経路を表す。
///
/// Firebase Analytics の `paywall_viewed` / `purchase_succeeded` /
/// `pressed_*_purchase_button` イベントに `paywall_source` パラメータとして
/// 送出され、BigQuery 上で経路別 CV 率を集計するために使用する。
///
/// 値の追加・変更時は PilllBackend/bigquery/queries/paywall_source_conversion.sql の
/// 集計対象と整合させること。
enum PaywallSource {
  appLaunch,
  homeMonthly,
  calendarOverlay,
  pillSheetModifiedHistoryCard,
  pillSheetModifiedHistoryMore,
  menstruationHistoryCard,
  menstruationHistoryMore,
  diaryPhysicalConditionDetail,
  appearanceModeSelect,
  discountAnnouncementBar,
  pilllAdsAnnouncementBarClose,
  endedPillSheetBar,
  settingsPremiumIntroductionRow,
  settingsCriticalAlertRow,
  settingsCreatingNewPillSheetRow,
  settingsQuickRecordRow,
  settingsReminderCustomizeRow,
  featureAppealAlarmKit,
  featureAppealAppearanceMode,
  featureAppealCreatingPillSheet,
  featureAppealCriticalAlert,
  featureAppealQuickRecord,
  featureAppealReminderCustomize,
  specialOfferingBar,
  specialOfferingBar2,
  lifetimeOfferBar,
  lifetimeOfferAppLaunch,
  endedPillSheetDialogHistory,
  endedPillSheetDialogSummary,
}

extension PaywallSourceFunction on PaywallSource {
  /// Firebase Analytics の paywall_source パラメータに送出する snake_case 文字列。
  /// enum 名の rename / Dart の難読化に影響されないよう明示的に列挙する。
  String get value {
    switch (this) {
      case PaywallSource.appLaunch:
        return 'app_launch';
      case PaywallSource.homeMonthly:
        return 'home_monthly';
      case PaywallSource.calendarOverlay:
        return 'calendar_overlay';
      case PaywallSource.pillSheetModifiedHistoryCard:
        return 'pill_sheet_modified_history_card';
      case PaywallSource.pillSheetModifiedHistoryMore:
        return 'pill_sheet_modified_history_more';
      case PaywallSource.menstruationHistoryCard:
        return 'menstruation_history_card';
      case PaywallSource.menstruationHistoryMore:
        return 'menstruation_history_more';
      case PaywallSource.diaryPhysicalConditionDetail:
        return 'diary_physical_condition_detail';
      case PaywallSource.appearanceModeSelect:
        return 'appearance_mode_select';
      case PaywallSource.discountAnnouncementBar:
        return 'discount_announcement_bar';
      case PaywallSource.pilllAdsAnnouncementBarClose:
        return 'pilll_ads_announcement_bar_close';
      case PaywallSource.endedPillSheetBar:
        return 'ended_pill_sheet_bar';
      case PaywallSource.settingsPremiumIntroductionRow:
        return 'settings_premium_introduction_row';
      case PaywallSource.settingsCriticalAlertRow:
        return 'settings_critical_alert_row';
      case PaywallSource.settingsCreatingNewPillSheetRow:
        return 'settings_creating_new_pill_sheet_row';
      case PaywallSource.settingsQuickRecordRow:
        return 'settings_quick_record_row';
      case PaywallSource.settingsReminderCustomizeRow:
        return 'settings_reminder_customize_row';
      case PaywallSource.featureAppealAlarmKit:
        return 'feature_appeal_alarm_kit';
      case PaywallSource.featureAppealAppearanceMode:
        return 'feature_appeal_appearance_mode';
      case PaywallSource.featureAppealCreatingPillSheet:
        return 'feature_appeal_creating_pill_sheet';
      case PaywallSource.featureAppealCriticalAlert:
        return 'feature_appeal_critical_alert';
      case PaywallSource.featureAppealQuickRecord:
        return 'feature_appeal_quick_record';
      case PaywallSource.featureAppealReminderCustomize:
        return 'feature_appeal_reminder_customize';
      case PaywallSource.specialOfferingBar:
        return 'special_offering_bar';
      case PaywallSource.specialOfferingBar2:
        return 'special_offering_bar2';
      case PaywallSource.lifetimeOfferBar:
        return 'lifetime_offer_bar';
      case PaywallSource.lifetimeOfferAppLaunch:
        return 'lifetime_offer_app_launch';
      case PaywallSource.endedPillSheetDialogHistory:
        return 'ended_pill_sheet_dialog_history';
      case PaywallSource.endedPillSheetDialogSummary:
        return 'ended_pill_sheet_dialog_summary';
    }
  }
}
