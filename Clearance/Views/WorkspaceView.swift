import SwiftUI

struct WorkspaceView: View {
    @StateObject private var viewModel: WorkspaceViewModel
    private let popoutWindowController: PopoutWindowController

    init(
        appSettings: AppSettings = AppSettings(),
        popoutWindowController: PopoutWindowController = PopoutWindowController()
    ) {
        _viewModel = StateObject(wrappedValue: WorkspaceViewModel(appSettings: appSettings))
        self.popoutWindowController = popoutWindowController
    }

    var body: some View {
        NavigationSplitView {
            RecentFilesSidebar(entries: viewModel.recentFilesStore.entries) { entry in
                viewModel.open(recentEntry: entry)
            } onPopOut: { entry in
                popOut(entry: entry)
            }
        } detail: {
            Group {
                if let session = viewModel.activeSession {
                    DocumentSurfaceView(session: session, mode: $viewModel.mode)
                } else {
                    ContentUnavailableView("Open a Markdown File", systemImage: "doc.text")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(viewModel.windowTitle)
        }
        .focusedSceneValue(\.workspaceCommandActions, WorkspaceCommandActions(
            openFile: { viewModel.promptAndOpenFile() },
            showViewMode: { if viewModel.activeSession != nil { viewModel.mode = .view } },
            showEditMode: { if viewModel.activeSession != nil { viewModel.mode = .edit } },
            popOutActive: { popOutActiveSession() },
            hasActiveSession: viewModel.activeSession != nil
        ))
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Picker("Mode", selection: $viewModel.mode) {
                    ForEach(WorkspaceMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 160)
                .disabled(viewModel.activeSession == nil)
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Open") {
                    viewModel.promptAndOpenFile()
                }
            }
            ToolbarItem(placement: .automatic) {
                Button("Pop Out") {
                    popOutActiveSession()
                }
                .disabled(viewModel.activeSession == nil)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .clearanceOpenURLs)) { notification in
            guard let urls = notification.object as? [URL],
                  let firstURL = urls.first else {
                return
            }

            viewModel.open(url: firstURL)
        }
        .alert("Could Not Open File", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.errorMessage = nil
                }
            }
        ), actions: {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        }, message: {
            Text(viewModel.errorMessage ?? "")
        })
    }

    private func popOutActiveSession() {
        guard let session = viewModel.activeSession else {
            return
        }

        popoutWindowController.openWindow(for: session, mode: viewModel.mode)
    }

    private func popOut(entry: RecentFileEntry) {
        if let session = viewModel.open(recentEntry: entry) {
            popoutWindowController.openWindow(for: session, mode: viewModel.mode)
        }
    }
}
