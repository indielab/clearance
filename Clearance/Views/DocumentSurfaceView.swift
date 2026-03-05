import SwiftUI

struct DocumentSurfaceView: View {
    @ObservedObject var session: DocumentSession
    @Binding var mode: WorkspaceMode

    var body: some View {
        switch mode {
        case .view:
            let parsed = FrontmatterParser().parse(markdown: session.content)
            RenderedMarkdownView(document: parsed)
        case .edit:
            CodeMirrorEditorView(
                text: Binding(
                    get: { session.content },
                    set: { session.content = $0 }
                )
            )
        }
    }
}
