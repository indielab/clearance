import SwiftUI

@main
struct ClearanceApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var appSettings = AppSettings()
    private let popoutWindowController = PopoutWindowController()

    var body: some Scene {
        WindowGroup {
            WorkspaceView(
                appSettings: appSettings,
                popoutWindowController: popoutWindowController
            )
        }

        Settings {
            SettingsView(settings: appSettings)
        }
    }
}
