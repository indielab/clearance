import Foundation

@MainActor
final class WorkspaceViewModel: ObservableObject {
    @Published var activeSession: DocumentSession?
    @Published var errorMessage: String?
    @Published var mode: WorkspaceMode

    let recentFilesStore: RecentFilesStore

    private let openPanelService: OpenPanelServicing
    private let appSettings: AppSettings

    init(
        recentFilesStore: RecentFilesStore = RecentFilesStore(),
        openPanelService: OpenPanelServicing = OpenPanelService(),
        appSettings: AppSettings = AppSettings()
    ) {
        self.recentFilesStore = recentFilesStore
        self.openPanelService = openPanelService
        self.appSettings = appSettings
        mode = appSettings.defaultOpenMode
    }

    var windowTitle: String {
        activeSession?.url.lastPathComponent ?? "Clearance"
    }

    func promptAndOpenFile() {
        guard let url = openPanelService.chooseMarkdownFile() else {
            return
        }

        open(url: url)
    }

    @discardableResult
    func open(recentEntry: RecentFileEntry) -> DocumentSession? {
        open(url: recentEntry.fileURL)
    }

    @discardableResult
    func open(url: URL) -> DocumentSession? {
        do {
            let session = try DocumentSession(url: url)
            activeSession = session
            recentFilesStore.add(url: url)
            mode = appSettings.defaultOpenMode
            errorMessage = nil
            return session
        } catch {
            errorMessage = "Failed to open \(url.path): \(error.localizedDescription)"
            return nil
        }
    }
}
