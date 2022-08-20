import Foundation

enum Const {
    #if DEBUG
    static let appGroupKey = "group.com.mizuki.Ohashi.Pilll.dev"
    #else
    static let appGroupKey = "group.com.mizuki.Ohashi.Pilll"
    #endif

    static let pillSheetBeginDate = "pillSheetBeginDate"
    static let pillSheetNumberOffset = "pillSheetNumberOffset"
    static let pillSheetLastTakenDate = "pillSheetLastTakenDate"
    static let pillSheetCurrentStatus = "pillSheetCurrentStatus"
}
