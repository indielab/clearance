import XCTest
@testable import Clearance

@MainActor
final class WorkspaceViewModelTests: XCTestCase {
    func testOpenURLCreatesActiveSession() throws {
        let fileURL = try makeTempMarkdown(contents: "# One")
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = RecentFilesStore(userDefaults: defaults, storageKey: "recent")
        let viewModel = WorkspaceViewModel(recentFilesStore: store)

        viewModel.open(url: fileURL)

        XCTAssertEqual(viewModel.activeSession?.url.path, fileURL.path)
    }

    func testOpenURLInsertsRecentAtTop() throws {
        let firstURL = try makeTempMarkdown(contents: "1")
        let secondURL = try makeTempMarkdown(contents: "2")
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = RecentFilesStore(userDefaults: defaults, storageKey: "recent")
        let viewModel = WorkspaceViewModel(recentFilesStore: store)

        viewModel.open(url: firstURL)
        viewModel.open(url: secondURL)

        XCTAssertEqual(store.entries.first?.path, secondURL.path)
    }

    func testOpeningFromRecentEntryReopensSession() throws {
        let firstURL = try makeTempMarkdown(contents: "1")
        let secondURL = try makeTempMarkdown(contents: "2")
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = RecentFilesStore(userDefaults: defaults, storageKey: "recent")
        let viewModel = WorkspaceViewModel(recentFilesStore: store)

        viewModel.open(url: firstURL)
        viewModel.open(url: secondURL)

        let firstEntry = store.entries.last!
        viewModel.open(recentEntry: firstEntry)

        XCTAssertEqual(viewModel.activeSession?.url.path, firstURL.path)
    }

    private func makeTempMarkdown(contents: String) throws -> URL {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let fileURL = directory.appendingPathComponent("sample.md")
        try contents.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }
}
