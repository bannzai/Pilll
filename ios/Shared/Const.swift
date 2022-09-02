import Foundation

enum Const {
    static let widgetKind = "com.mizuki.Ohashi.Pilll.widget"

    static let userIsPremiumOrTrial = "userIsPremiumOrTrial"

    static let pillSheetTodayPillNumber = "pillSheetTodayPillNumber"
    static let pillSheetEndDisplayPillNumber = "pillSheetEndDisplayPillNumber"
    // Epoch milli second
    static let pillSheetLastTakenDate = "pillSheetLastTakenDate"
    // Epoch milli second
    static let lastRecordDate = "lastRecordDate"
}

enum Plist {
    static var appGroupKey: String {
        Bundle.main.infoDictionary!["AppGroupKey"] as! String
    }
}
