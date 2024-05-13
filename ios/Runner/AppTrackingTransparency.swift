import Foundation
import AppTrackingTransparency

func requestAppTrackingTransparency(completion: @escaping ([String: Any]) -> Void) {
  switch ATTrackingManager.trackingAuthorizationStatus {
  case .notDetermined:
    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      completion([
        "result": "success",
        "status": status.rawValue
      ])
    })
  case .authorized, .denied, .restricted:
    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
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
