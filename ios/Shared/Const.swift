import Foundation

enum Const {
    #if DEBUG
    static let appGroupKey = "group.com.mizuki.Ohashi.Pilll.dev"
    #else
    static let appGroupKey = "group.com.mizuki.Ohashi.Pilll"
    #endif

    static let widgetKind = "com.mizuki.Ohashi.Pilll.widget"

    static let userIsPremiumOrTrial = "userIsPremiumOrTrial"
    // Epoch milli second
    static let pillSheetBeginDate = "pillSheetBeginDate"
    // Epoch milli second
    static let pillSheetLastTakenDate = "pillSheetLastTakenDate"
}
