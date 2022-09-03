import SwiftUI
import Foundation

struct AccessoryCircularWidget: View {
    let entry: Entry

    var body: some View {
        VStack {
            Image("pilll-widget-icon")
                .frame(width: 11, height: 16)
            Text("Hello, world")
        }
    }
}

