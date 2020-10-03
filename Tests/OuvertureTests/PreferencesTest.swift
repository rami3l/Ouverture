// import CoreFoundation
// import Foundation
import XCTest

// import class Foundation.Bundle
@testable import OuvertureLib

extension OuvertureTests {
    func testGetUtiString() throws {
        let txtUti = getUtiString(forExt: "txt")! as String
        XCTAssertEqual(txtUti, "public.plain-text")
    }

    func testGetDefaultHandler() throws {
        let txtUti = "public.plain-text" as CFString
        let txtHandler = getDefaultHandler(forUti: txtUti)! as String
        // print(txtHandler) // => com.apple.TextEdit
        XCTAssert(isBundleId(txtHandler))
    }
}
