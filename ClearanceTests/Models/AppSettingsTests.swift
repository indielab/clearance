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

    func testDefaultThemeAndAppearanceAreAppleSystem() {
        let suite = UUID().uuidString
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)

        let settings = AppSettings(
            userDefaults: defaults,
            storageKey: "defaultMode",
            themeStorageKey: "theme",
            appearanceStorageKey: "appearance"
        )

        XCTAssertEqual(settings.theme, .apple)
        XCTAssertEqual(settings.appearance, .system)
    }

    func testPersistedThemeAndAppearanceRestoreAfterReload() {
        let suite = UUID().uuidString
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)

        let first = AppSettings(
            userDefaults: defaults,
            storageKey: "defaultMode",
            themeStorageKey: "theme",
            appearanceStorageKey: "appearance"
        )
        first.theme = .classicBlue
        first.appearance = .dark

        let second = AppSettings(
            userDefaults: defaults,
            storageKey: "defaultMode",
            themeStorageKey: "theme",
            appearanceStorageKey: "appearance"
        )

        XCTAssertEqual(second.theme, .classicBlue)
        XCTAssertEqual(second.appearance, .dark)
    }
}
