import Foundation
import UIKit
import ActivityKit

// 種類を増やすならFlutterのコードの定義も追加する必要がある
enum ShareToSNSKind: String, RawRepresentable, CaseIterable {
  case X
  case facebook

  static var `default` = ShareToSNSKind.X

  var displayName: String {
    "\(self)"
  }

  var activityType: UIActivity.ActivityType {
    switch self {
    case .X: .postToTwitter
    case .facebook: .postToFacebook
    }
  }
}


func presentShareToSNSForPremiumTrialReward(kind: ShareToSNSKind, completionHandler: @escaping (Dictionary<String, Any>) -> Void) {
  let controller = UIActivityViewController(
    activityItems: [
      """
Pilll ピル服用に特化したピルリマインダーアプリ

iOS: https://onl.sc/piiY1A6
Android: https://onl.sc/c9xnQUk;
"""
    ],
    applicationActivities: nil
  )
  controller.completionWithItemsHandler = {
    [weak controller] activityType,
    completed,
    returnedItems,
    activityError in
    if let activityError {
      completionHandler(["result": "failure", "message": activityError.localizedDescription])
    } else {
      guard completed else {
        return
      }
      
      if kind.activityType != activityType {
        let actual = activityType
        let expected = kind.activityType
        let expectedActivityDisplayName = kind.displayName

        completionHandler([
          "result": "failure",
          "titie": "共有先が間違えています",
          "message": "共有先が\(String(describing: actual?.rawValue))でした. `\(expectedActivityDisplayName)にシェアしてください` id:\(expected.rawValue)"
        ])
      } else {
        controller?.dismiss(animated: true) {
          completionHandler(["result": "success", "activityDisplayName": kind.displayName])
        }
      }
    }
  }

  var firstKeyWindow: UIWindow? {
     UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .filter { $0.activationState == .foregroundActive }
      .flatMap(\.windows)
      .first(where: \.isKeyWindow)
  }

  firstKeyWindow?.rootViewController?.present(controller, animated: true)
}
