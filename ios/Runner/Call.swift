import Foundation
import UIKit

func call(method: String, arguments: [String: Any]?) {
    let window = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first { $0.activationState == .foregroundActive }?
        .windows
        .first(where: \.isKeyWindow)
    let viewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
        name: "method.channel.MizukiOhashi.Pilll",
        binaryMessenger: viewController.binaryMessenger
    )
    channel.invokeMethod(method, arguments: arguments)
}
