import SwiftUI

struct DocumentSurfaceView: View {
    @ObservedObject var session: DocumentSession
    let parsedDocument: ParsedMarkdownDocument
    let headingScrollRequest: HeadingScrollRequest?
    let onOpenLinkedDocument: (URL) -> Void
    let theme: AppTheme
    let appearance: AppearancePreference
    @Binding var mode: WorkspaceMode

    var body: some View {
        switch mode {
        case .view:
            RenderedMarkdownView(
                document: parsedDocument,
                sourceDocumentURL: session.url,
                headingScrollRequest: headingScrollRequest,
                theme: theme,
                appearance: appearance,
                onOpenLinkedDocument: onOpenLinkedDocument
            )
        case .edit:
            CodeMirrorEditorView(
                text: Binding(
                    get: { session.content },
                    set: { session.content = $0 }
                ),
                theme: theme,
                appearance: appearance
            )
        }
    }
}
