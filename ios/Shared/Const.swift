import Foundation

enum Const {
    static let widgetKind = "com.mizuki.Ohashi.Pilll.widget"

    static let userIsPremiumOrTrial = "userIsPremiumOrTrial"

    static let pillSheetTodayPillNumber = "pillSheetTodayPillNumber"
    static let pillSheetEndDisplayPillNumber = "pillSheetEndDisplayPillNumber"
    static let settingPillSheetAppearanceMode = "settingPillSheetAppearanceMode" // number or date or sequential
    // Epoch milli second
    static let pillSheetLastTakenDate = "pillSheetLastTakenDate"
    // Epoch milli second
    static let pillSheetValueLastUpdateDateTime = "pillSheetValueLastUpdateDateTime"
}

enum Plist {
    static var appGroupKey: String {
        Bundle.main.infoDictionary!["AppGroupKey"] as! String
    }
}
