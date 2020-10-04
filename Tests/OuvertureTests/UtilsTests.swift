// import CoreFoundation
// import Foundation
import XCTest

// import class Foundation.Bundle
@testable import Ouverture

extension OuvertureTests {
    func testIsReverseDomain() throws {
        XCTAssert("com.apple.TextEdit".isReverseDomain())
        XCTAssert("public.plain-text".isReverseDomain())
        XCTAssert("dyn.age81e62".isReverseDomain())
        XCTAssert(!"/System/Applications/TextEdit.app".isReverseDomain())
    }
}
