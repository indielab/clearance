import XCTest
@testable import Clearance

final class MarkdownLinkRouterTests: XCTestCase {
    func testAllowsSameDocumentAnchorNavigation() {
        let sourceURL = URL(fileURLWithPath: "/tmp/docs/root.md")
        let requestedURL = URL(string: "file:///tmp/docs/root.md#overview")

        let action = MarkdownLinkRouter.action(for: requestedURL, sourceDocumentURL: sourceURL)

        XCTAssertEqual(action, .allowWebView)
    }

    func testOpensMarkdownFilesInApp() {
        let sourceURL = URL(fileURLWithPath: "/tmp/docs/root.md")
        let requestedURL = URL(string: "file:///tmp/docs/next.md")

        let action = MarkdownLinkRouter.action(for: requestedURL, sourceDocumentURL: sourceURL)

        XCTAssertEqual(action, .openInApp(URL(fileURLWithPath: "/tmp/docs/next.md")))
    }

    func testOpensTextFilesInApp() {
        let sourceURL = URL(fileURLWithPath: "/tmp/docs/root.md")
        let requestedURL = URL(string: "file:///tmp/docs/notes.txt")

        let action = MarkdownLinkRouter.action(for: requestedURL, sourceDocumentURL: sourceURL)

        XCTAssertEqual(action, .openInApp(URL(fileURLWithPath: "/tmp/docs/notes.txt")))
    }

    func testOpensWebLinksExternally() {
        let sourceURL = URL(fileURLWithPath: "/tmp/docs/root.md")
        let requestedURL = URL(string: "https://example.com/readme.md")

        let action = MarkdownLinkRouter.action(for: requestedURL, sourceDocumentURL: sourceURL)

        XCTAssertEqual(action, .openExternal(URL(string: "https://example.com/readme.md")!))
    }

    func testOpensNonMarkdownFilesExternally() {
        let sourceURL = URL(fileURLWithPath: "/tmp/docs/root.md")
        let requestedURL = URL(string: "file:///tmp/docs/image.png")

        let action = MarkdownLinkRouter.action(for: requestedURL, sourceDocumentURL: sourceURL)

        XCTAssertEqual(action, .openExternal(URL(fileURLWithPath: "/tmp/docs/image.png")))
    }
}
