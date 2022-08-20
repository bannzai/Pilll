import FirebaseAuth
import FirebaseCore
import SwiftUI
import WidgetKit

@main
struct Widgets: WidgetBundle {

    init() {
        FirebaseApp.configure()

        let teamID = "TQPN82UBBY"
        let keychainAccessGroup: String = "\(teamID).\(Bundle.main.bundleIdentifier!).keychain"
        try! Auth.auth().useUserAccessGroup(keychainAccessGroup)
    }

    var body: some Widget {
        SmallWidget()
        MediumWidget()
        LargeWidget()
    }
}
