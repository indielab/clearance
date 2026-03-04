import SwiftUI

struct RecentFilesSidebar: View {
    let entries: [RecentFileEntry]
    let onSelect: (RecentFileEntry) -> Void

    var body: some View {
        List(entries) { entry in
            Button {
                onSelect(entry)
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.displayName)
                        .font(.body)
                        .lineLimit(1)
                    Text(entry.path)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.sidebar)
    }
}
