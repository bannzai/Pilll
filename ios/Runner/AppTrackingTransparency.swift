import Foundation
import AppTrackingTransparency

static func requestAppTrackingTransparency(completion: @escaping [String: Any] -> Void) {
  switch ATTrackingManager.trackingAuthorizationStatus {
  case .notDetermined
    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      completionHandler([
        "result": "success",
        "status": status.rawValue
      ])
    })
  case .authorized, .denied, .restricted:
    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      completionHandler([
        "result": "success",
        "status": ATTrackingManager.trackingAuthorizationStatus.rawValue
      ])
    })
  @unknown default:
    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      completionHandler([
        "result": "failure",
        "reason": "unknown status: \(ATTrackingManager.trackingAuthorizationStatus.rawValue)"
      ])
    })
  }
}
