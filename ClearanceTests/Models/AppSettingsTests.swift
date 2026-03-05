import XCTest
@testable import Clearance

final class AppSettingsTests: XCTestCase {
    func testDefaultOpenModeIsView() {
        let suite = UUID().uuidString
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)

        let settings = AppSettings(userDefaults: defaults, storageKey: "defaultMode")

        XCTAssertEqual(settings.defaultOpenMode, .view)
    }

    func testPersistedEditModeRestoresAfterReload() {
        let suite = UUID().uuidString
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)

        let first = AppSettings(userDefaults: defaults, storageKey: "defaultMode")
        first.defaultOpenMode = .edit

        let second = AppSettings(userDefaults: defaults, storageKey: "defaultMode")
        XCTAssertEqual(second.defaultOpenMode, .edit)
    }
}
