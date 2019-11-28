import XCTest
@testable import G8

final class G8Tests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(G8().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
