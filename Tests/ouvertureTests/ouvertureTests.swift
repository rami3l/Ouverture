import XCTest

import class Foundation.Bundle

@testable import Ouverture

final class OuvertureTests: XCTestCase {
    static var allTests = [
        // ("testExample", testExample)
        ("testGetBundleUrlCandidates", testGetBundleUrlCandidates)
    ]

    func testGetBundleUrlCandidates() throws {
        let app = "com.apple.TextEdit"
        let paths = getBundleUrlCandidates(from: app as CFString)!
        XCTAssert(
            paths.contains {
                ($0 as String).contains("/System/Applications/TextEdit.app/")
            }
        )
    }
}
