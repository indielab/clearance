import SwiftUI

struct WorkspaceView: View {
    @StateObject private var viewModel = WorkspaceViewModel()

    var body: some View {
        NavigationSplitView {
            RecentFilesSidebar(entries: viewModel.recentFilesStore.entries) { entry in
                viewModel.open(recentEntry: entry)
            }
            .navigationTitle("Open Files")
        } detail: {
            Group {
                if let session = viewModel.activeSession {
                    ScrollView {
                        Text(session.content)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(24)
                    }
                } else {
                    ContentUnavailableView("Open a Markdown File", systemImage: "doc.text")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Open") {
                    viewModel.promptAndOpenFile()
                }
            }
        }
        .alert("Could Not Open File", isPresented: .constant(viewModel.errorMessage != nil), actions: {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        }, message: {
            Text(viewModel.errorMessage ?? "")
        })
    }
}
