extension BoolKey on String {
  static final didEndInitialSetting = "isDidEndInitialSettingKey";
  static final recommendedSignupNotificationIsAlreadyShow =
      "recommendedSignupNotificationIsAlreadyShow";
  static final isAlreadyShowDemography = "isAlreadyShowDemography";
  static final isAlreadyDoneDemography = "isAlreadyDoneDemography";
  static final isAlreadyShowPremiumTrialModal =
      "isAlreadyShowPremiumTrialModal";
}

extension StringKey on String {
  static final String firebaseAnonymousUserID = "firebaseAnonymousUserID";
  static final String salvagedOldStartTakenDate = "salvagedOldStartTakenDate";
  static final String salvagedOldLastTakenDate = "salvagedOldLastTakenDate";
  static final String beginingVersionKey = "beginingVersion";
  static final String currentUserUID = "currentUserUID";
  static final String lastSigninAnonymousUID = "lastSigninAnonymousUID";
}

extension ReleaseNoteKey on String {
  static final String renewal = "release_notes_shown_renewal";
  static final String version2_4_0 = "release_notes_shown_2.4.0";
}

extension IntKey on String {
  static final String totalCountOfActionForTakenPill = "totalPillCount";
}
