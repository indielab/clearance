import Foundation

enum MarkdownLinkOpenAction: Equatable {
    case allowWebView
    case openInApp(URL)
    case openExternal(URL)
}

enum MarkdownLinkRouter {
    static func action(for requestedURL: URL?, sourceDocumentURL: URL?) -> MarkdownLinkOpenAction {
        guard let requestedURL else {
            return .allowWebView
        }

        guard let scheme = requestedURL.scheme?.lowercased() else {
            return .allowWebView
        }

        switch scheme {
        case "about", "data":
            return .allowWebView
        case "file":
            if isSameDocumentAnchor(requestedURL: requestedURL, sourceDocumentURL: sourceDocumentURL) {
                return .allowWebView
            }

            let normalizedURL = stripFragment(from: requestedURL).standardizedFileURL
            if shouldOpenInApp(normalizedURL) {
                return .openInApp(normalizedURL)
            }

            return .openExternal(normalizedURL)
        case "http", "https":
            return .openExternal(requestedURL)
        default:
            return .openExternal(requestedURL)
        }
    }

    private static func shouldOpenInApp(_ url: URL) -> Bool {
        let `extension` = url.pathExtension.lowercased()
        return ["md", "markdown", "txt"].contains(`extension`)
    }

    private static func isSameDocumentAnchor(requestedURL: URL, sourceDocumentURL: URL?) -> Bool {
        guard requestedURL.isFileURL,
              requestedURL.fragment != nil,
              let sourceDocumentURL else {
            return false
        }

        let requestedWithoutFragment = stripFragment(from: requestedURL).standardizedFileURL
        let sourceWithoutFragment = stripFragment(from: sourceDocumentURL).standardizedFileURL
        return requestedWithoutFragment.path == sourceWithoutFragment.path
    }

    private static func stripFragment(from url: URL) -> URL {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }

        components.fragment = nil
        return components.url ?? url
    }
}
