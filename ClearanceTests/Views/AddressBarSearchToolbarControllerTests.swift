import AppKit
import XCTest
@testable import Clearance

@MainActor
final class AddressBarSearchToolbarControllerTests: XCTestCase {
    func testAddressFieldDoesNotShowSearchGlyph() {
        let controller = AddressBarSearchToolbarController()

        guard let cell = controller.item.searchField.cell as? NSSearchFieldCell else {
            XCTFail("Expected an NSSearchFieldCell backing the address field")
            return
        }

        XCTAssertNil(cell.searchButtonCell)
    }
}
