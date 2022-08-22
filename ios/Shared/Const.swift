import Foundation

enum Const {
    static let widgetKind = "com.mizuki.Ohashi.Pilll.widget"

    static let userIsPremiumOrTrial = "userIsPremiumOrTrial"
    // Epoch milli second
    static let pillSheetBeginDate = "pillSheetBeginDate"
    // Epoch milli second
    static let pillSheetLastTakenDate = "pillSheetLastTakenDate"
}

enum Plist {
    static var appGroupKey: String {
        Bundle.main.infoDictionary!["AppGroupKey"] as! String
    }
}
