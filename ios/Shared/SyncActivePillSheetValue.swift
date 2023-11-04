import Flutter
import Foundation
import WidgetKit

func syncActivePillSheetValue(call: FlutterMethodCall, completionHandler: (Dictionary<String, Any>) -> Void) {
    guard let arguments = call.arguments as? Dictionary<String, Any> else {
        fatalError()
    }

    let pillSheetValueLastUpdateDateTime = arguments[Const.pillSheetValueLastUpdateDateTime] as? Int
    UserDefaults(suiteName: Plist.appGroupKey)?.set(pillSheetValueLastUpdateDateTime, forKey: Const.pillSheetValueLastUpdateDateTime)

    let pillSheetLastTakenDate = arguments[Const.pillSheetLastTakenDate] as? Int
    UserDefaults(suiteName: Plist.appGroupKey)?.set(pillSheetLastTakenDate, forKey: Const.pillSheetLastTakenDate)

    let pillSheetGroupTodayPillNumber = arguments[Const.pillSheetGroupTodayPillNumber] as? Int
    UserDefaults(suiteName: Plist.appGroupKey)?.set(pillSheetGroupTodayPillNumber, forKey: Const.pillSheetGroupTodayPillNumber)

    let pillSheetTodayPillNumber = arguments[Const.pillSheetTodayPillNumber] as? Int
    UserDefaults(suiteName: Plist.appGroupKey)?.set(pillSheetTodayPillNumber, forKey: Const.pillSheetTodayPillNumber)

    let pillSheetEndDisplayPillNumber = arguments[Const.pillSheetEndDisplayPillNumber] as? Int
    UserDefaults(suiteName: Plist.appGroupKey)?.set(pillSheetEndDisplayPillNumber, forKey: Const.pillSheetEndDisplayPillNumber)

    if #available(iOS 14.0, *) {
        WidgetCenter.shared.reloadTimelines(ofKind: Const.widgetKind)
    }
    if #available(iOSApplicationExtension 14.0, *) {
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: Const.widgetKind)
        }
    }

    completionHandler(["result": "success"])
}
