import Foundation

enum Const {
    #if DEBUG
    static let appGroupKey = "group.com.mizuki.Ohashi.Pilll.dev"
    #else
    static let appGroupKey = "group.com.mizuki.Ohashi.Pilll"
    #endif

    static let userIsPremiumOrTrial = "userIsPremiumOrTrial"
    static let pillSheetBeginDate = "pillSheetBeginDate"
    static let pillSheetLastTakenDate = "pillSheetLastTakenDate"
}
