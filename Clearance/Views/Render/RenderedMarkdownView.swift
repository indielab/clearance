import SwiftUI
import WebKit

struct RenderedMarkdownView: NSViewRepresentable {
    let document: ParsedMarkdownDocument
    private let builder = RenderedHTMLBuilder()

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(builder.build(document: document), baseURL: Bundle.main.bundleURL)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor @Sendable (WKNavigationActionPolicy) -> Void) {
            if LocalNavigationPolicy.allows(navigationAction.request.url) {
                decisionHandler(.allow)
                return
            }

            decisionHandler(.cancel)
        }
    }
}
