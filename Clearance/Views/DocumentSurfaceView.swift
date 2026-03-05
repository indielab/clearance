import SwiftUI

struct DocumentSurfaceView: View {
    @ObservedObject var session: DocumentSession
    let parsedDocument: ParsedMarkdownDocument
    let headingScrollRequest: HeadingScrollRequest?
    let onOpenLinkedDocument: (URL) -> Void
    @Binding var mode: WorkspaceMode

    var body: some View {
        switch mode {
        case .view:
            RenderedMarkdownView(
                document: parsedDocument,
                sourceDocumentURL: session.url,
                headingScrollRequest: headingScrollRequest,
                onOpenLinkedDocument: onOpenLinkedDocument
            )
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
