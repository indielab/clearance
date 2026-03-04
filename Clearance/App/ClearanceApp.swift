import SwiftUI

@main
struct ClearanceApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            WorkspaceView()
        }
    }
}
