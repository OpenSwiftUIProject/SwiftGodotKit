import SwiftGodotKit
#if OpenSwiftUI
import OpenSwiftUI
#else
import SwiftUI
#endif

struct ContentView: View {
    let app: GodotApp

    var body: some View {
        GodotAppView()
            .background(Color(red: 0.08, green: 0.18, blue: 0.22))
            .environment(\.godotApp, app)
            #if os(macOS) && !OpenSwiftUI
            .frame(minWidth: 480, minHeight: 720)
            #elseif os(iOS)
            .ignoresSafeArea()
            #endif
    }
}
