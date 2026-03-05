import SwiftUI

@main
struct ClearanceApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var appSettings = AppSettings()
    private let popoutWindowController = PopoutWindowController()

    var body: some Scene {
        WindowGroup {
            WorkspaceView(
                appSettings: appSettings,
                popoutWindowController: popoutWindowController
            )
        }
        .commands {
            ClearanceCommands()
        }

        Settings {
            SettingsView(settings: appSettings)
        }
    }
}

struct WorkspaceCommandActions {
    let openFile: () -> Void
    let showViewMode: () -> Void
    let showEditMode: () -> Void
    let popOutActive: () -> Void
    let hasActiveSession: Bool
}

private struct WorkspaceCommandActionsKey: FocusedValueKey {
    typealias Value = WorkspaceCommandActions
}

extension FocusedValues {
    var workspaceCommandActions: WorkspaceCommandActions? {
        get { self[WorkspaceCommandActionsKey.self] }
        set { self[WorkspaceCommandActionsKey.self] = newValue }
    }
}

private struct ClearanceCommands: Commands {
    @FocusedValue(\.workspaceCommandActions) private var actions

    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Button("Open Markdown…") {
                actions?.openFile()
            }
            .keyboardShortcut("o")
            .disabled(actions == nil)
        }

        CommandMenu("Document") {
            Button("View Mode") {
                actions?.showViewMode()
            }
            .keyboardShortcut("1")
            .disabled(actions?.hasActiveSession != true)

            Button("Edit Mode") {
                actions?.showEditMode()
            }
            .keyboardShortcut("2")
            .disabled(actions?.hasActiveSession != true)

            Divider()

            Button("Pop Out In New Window") {
                actions?.popOutActive()
            }
            .keyboardShortcut("p", modifiers: [.command, .shift])
            .disabled(actions?.hasActiveSession != true)
        }
    }
}
