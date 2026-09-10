import Foundation
import AppTrackingTransparency
import FBAudienceNetwork

func requestAppTrackingTransparency(completion: @escaping ([String: Any]) -> Void) {
  switch ATTrackingManager.trackingAuthorizationStatus {
  case .notDetermined:
    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      setMetaAudienceNetworkAdvertiserTrackingEnabled(status: status)
      completion([
        "result": "success",
        "status": status.rawValue
      ])
    })
  case .authorized, .denied, .restricted:
    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      setMetaAudienceNetworkAdvertiserTrackingEnabled(status: status)
      completion([
        "result": "success",
        "status": ATTrackingManager.trackingAuthorizationStatus.rawValue
      ])
    })
  @unknown default:
    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      completion([
        "result": "failure",
        "reason": "unknown status: \(ATTrackingManager.trackingAuthorizationStatus.rawValue)"
      ])
    })
  }
}

/// ATT の応答を Meta Audience Network (AdMob メディエーションの入札ソース) に伝える
///
/// iOS 17 以降 (Audience Network SDK 6.15.0+) は SDK が ATT の状態を自動で参照するため設定不要だが、
/// iOS 15・16 ではこのフラグを設定しないと Meta 側で広告リクエストの利用が制限される
/// 参照: https://developers.facebook.com/docs/audience-network/setting-up/platform-setup/ios/advertising-tracking-enabled
private func setMetaAudienceNetworkAdvertiserTrackingEnabled(status: ATTrackingManager.AuthorizationStatus) {
  if #available(iOS 17.0, *) {
    return
  }
  FBAdSettings.setAdvertiserTrackingEnabled(status == .authorized)
}
