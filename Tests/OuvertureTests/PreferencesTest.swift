// import CoreFoundation
// import Foundation
import XCTest

// import class Foundation.Bundle
@testable import OuvertureLib

extension OuvertureTests {
    func testGetUtiString() throws {
        func uti(_ ext: String, _ parent: String? = nil) -> String {
            return getUtiString(forExt: ext, conformingTo: parent as CFString?)!
                as String
        }
        XCTAssertEqual(uti("txt"), "public.plain-text")
        XCTAssertEqual(uti("rs"), "dyn.age81e62")
        XCTAssertEqual(uti("rs", "public.plain-text"), "dyn.ah62d4sb4ge81e62")
    }

    func testGetDefaultHandler() throws {
        let txtUti = "public.plain-text" as CFString
        let txtHandler = getDefaultHandler(forUti: txtUti)! as String
        // print(txtHandler) // => com.apple.TextEdit
        XCTAssert(isBundleId(txtHandler))
    }
}
