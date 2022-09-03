import Foundation
import WidgetKit

struct Entry: TimelineEntry {
  // Timeline Entry required property
  let date: Date

  // PillSheet property
  let pillSheetTodayPillNumber: Int?
  let pillSheetGroupTodayPillNumber: Int?
  let pillSheetEndDisplayPillNumber: Int?
  let pillSheetLastTakenDate: Date?

  // Setting property
  var settingPillSheetAppearanceMode: SettingPillSheetAppearanceMode = .number
  enum SettingPillSheetAppearanceMode: String {
    case number, date, sequential
  }

  // Timestamp
  let pillSheetValueLastUpdateDateTime: Date?

  init(date: Date) {
    self.date = date

    func contains(_ key: String) -> Bool {
      UserDefaults(suiteName: Plist.appGroupKey)?.dictionaryRepresentation().keys.contains(key) == true
    }

    if contains(Const.pillSheetTodayPillNumber), let pillSheetTodayPillNumber = UserDefaults(suiteName: Plist.appGroupKey)?.integer(forKey: Const.pillSheetTodayPillNumber) {
      self.pillSheetTodayPillNumber = pillSheetTodayPillNumber
    } else {
      self.pillSheetTodayPillNumber = nil
    }

    if contains(Const.pillSheetGroupTodayPillNumber), let pillSheetGroupTodayPillNumber = UserDefaults(suiteName: Plist.appGroupKey)?.integer(forKey: Const.pillSheetGroupTodayPillNumber) {
      self.pillSheetGroupTodayPillNumber = pillSheetGroupTodayPillNumber
    } else {
      self.pillSheetGroupTodayPillNumber = nil
    }

    if contains(Const.pillSheetEndDisplayPillNumber), let pillSheetEndDisplayPillNumber = UserDefaults(suiteName: Plist.appGroupKey)?.integer(forKey: Const.pillSheetEndDisplayPillNumber) {
      self.pillSheetEndDisplayPillNumber = pillSheetEndDisplayPillNumber
    } else {
      self.pillSheetEndDisplayPillNumber = nil
    }

    if contains(Const.pillSheetLastTakenDate), let pillSheetLastTakenDateEpochMilliSecond = UserDefaults(suiteName: Plist.appGroupKey)?.integer(forKey: Const.pillSheetLastTakenDate) {
      self.pillSheetLastTakenDate = Date(timeIntervalSince1970: TimeInterval(pillSheetLastTakenDateEpochMilliSecond / 1000))
    } else {
      self.pillSheetLastTakenDate = nil
    }

    if contains(Const.settingPillSheetAppearanceMode), let settingPillSheetAppearanceMode = UserDefaults(suiteName: Plist.appGroupKey)?.string(forKey: Const.settingPillSheetAppearanceMode) {
      self.settingPillSheetAppearanceMode = .init(rawValue: settingPillSheetAppearanceMode) ?? .number
    }

    if contains(Const.pillSheetValueLastUpdateDateTime), let pillSheetValueLastUpdateDateTimeEpochMilliSecond = UserDefaults(suiteName: Plist.appGroupKey)?.integer(forKey: Const.pillSheetValueLastUpdateDateTime) {
      self.pillSheetValueLastUpdateDateTime = Date(timeIntervalSince1970: TimeInterval(pillSheetValueLastUpdateDateTimeEpochMilliSecond / 1000))
    } else {
      self.pillSheetValueLastUpdateDateTime = nil
    }
  }

}

extension Entry {
  private var todayPillNumber: Int? {
    guard let pillSheetValueLastUpdateDateTime = pillSheetValueLastUpdateDateTime else {
      return nil
    }

    let todayPillNumberBase: Int
    switch settingPillSheetAppearanceMode {
    case .number, .date:
      guard let pillSheetTodayPillNumber = pillSheetTodayPillNumber else {
        return nil
      }
      todayPillNumberBase = pillSheetTodayPillNumber
    case .sequential:
      guard let recordedPillSheetGroupTodayPillNumber = pillSheetGroupTodayPillNumber else {
        return nil
      }
      todayPillNumberBase = recordedPillSheetGroupTodayPillNumber
    }

    guard let diff = calendar.dateComponents([.day], from: date, to: pillSheetValueLastUpdateDateTime).day else {
      return todayPillNumberBase
    }
    let todayPillNumber = todayPillNumberBase + diff

    if let pillSheetEndDisplayPillNumber = pillSheetEndDisplayPillNumber, todayPillNumber > pillSheetEndDisplayPillNumber {
      // 更新されるまで常に1で良い
      return 1
    } else {
      return todayPillNumber
    }
  }

  var weekday: String {
    dateFormater.weekdaySymbols[calendar.component(.weekday, from: date) - 1]
  }

  var day: Int {
    calendar.component(.day, from: date)
  }

  var alreadyTaken: Bool {
    guard let pillSheetLastTakenDate = pillSheetLastTakenDate else {
      return false
    }
    return calendar.isDate(date, inSameDayAs: pillSheetLastTakenDate)
  }

  var status: Status {
    guard let userIsPremium = UserDefaults(suiteName: Plist.appGroupKey)?.bool(forKey: Const.userIsPremiumOrTrial), userIsPremium else {
      return .userIsNotPremiumOrTrial
    }

    if let todayPillNumber = entry.todayPillNumber {

    }
  }

}
