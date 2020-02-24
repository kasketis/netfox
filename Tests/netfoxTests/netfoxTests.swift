import XCTest
@testable import netfox

final class netfoxTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(netfox().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
