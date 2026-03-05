import Foundation

final class AppSettings: ObservableObject {
    @Published var defaultOpenMode: WorkspaceMode {
        didSet {
            userDefaults.set(defaultOpenMode.rawValue, forKey: storageKey)
        }
    }

    private let userDefaults: UserDefaults
    private let storageKey: String

    init(userDefaults: UserDefaults = .standard, storageKey: String = "defaultOpenMode") {
        self.userDefaults = userDefaults
        self.storageKey = storageKey

        if let stored = userDefaults.string(forKey: storageKey),
           let mode = WorkspaceMode(rawValue: stored) {
            defaultOpenMode = mode
        } else {
            defaultOpenMode = .view
        }
    }
}
