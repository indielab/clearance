import AppKit
import SwiftUI

@MainActor
final class PopoutWindowController {
    private var windows: [NSWindow] = []

    func openWindow(for session: DocumentSession, mode: WorkspaceMode) {
        let content = PopoutDocumentView(session: session, initialMode: mode)
        let hostingController = NSHostingController(rootView: content)

        let window = NSWindow(contentViewController: hostingController)
        window.title = session.url.lastPathComponent
        window.setContentSize(NSSize(width: 980, height: 760))
        window.styleMask.insert(.resizable)
        window.styleMask.insert(.closable)
        window.styleMask.insert(.miniaturizable)
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)

        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { [weak self, weak window] _ in
            guard let self, let window else {
                return
            }
            self.windows.removeAll { $0 === window }
        }

        windows.append(window)
    }
}

private struct PopoutDocumentView: View {
    @ObservedObject var session: DocumentSession
    @State private var mode: WorkspaceMode

    init(session: DocumentSession, initialMode: WorkspaceMode) {
        self.session = session
        _mode = State(initialValue: initialMode)
    }

    var body: some View {
        DocumentSurfaceView(session: session, mode: $mode)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Picker("Mode", selection: $mode) {
                        ForEach(WorkspaceMode.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 160)
                }
            }
            .frame(minWidth: 640, minHeight: 400)
    }
}
