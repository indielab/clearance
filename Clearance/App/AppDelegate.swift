import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func application(_ application: NSApplication, open urls: [URL]) {
        NotificationCenter.default.post(name: .clearanceOpenURLs, object: urls)
    }
}

extension Notification.Name {
    static let clearanceOpenURLs = Notification.Name("clearance.openURLs")
}
