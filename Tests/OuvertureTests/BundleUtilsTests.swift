// import CoreFoundation
// import Foundation
import XCTest

// import class Foundation.Bundle
@testable import OuvertureLib

extension OuvertureTests {
    func testGetBundleUrlCandidates() throws {
        let app = "com.apple.TextEdit"
        let paths = getBundleUrlCandidates(from: app as CFString)!
            .map { $0.absoluteString! }
        XCTAssert(
            paths.contains { $0.contains("/System/Applications/TextEdit.app/") }
        )
    }
}
