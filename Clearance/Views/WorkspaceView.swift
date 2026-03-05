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
            }
            .navigationTitle("Open Files")
        } detail: {
            Group {
                if let session = viewModel.activeSession {
                    DocumentSurfaceView(session: session, mode: $viewModel.mode)
                } else {
                    ContentUnavailableView("Open a Markdown File", systemImage: "doc.text")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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
                    guard let session = viewModel.activeSession else {
                        return
                    }

                    popoutWindowController.openWindow(for: session, mode: viewModel.mode)
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
}
