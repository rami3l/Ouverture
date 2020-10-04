// import CoreFoundation
// import Foundation
import XCTest

// import class Foundation.Bundle
@testable import Ouverture

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
        // dump(txtHandler) // => com.apple.TextEdit
        XCTAssert(txtHandler.isReverseDomain())
        let txtHandler1 = getDefaultHandler(forExt: "txt")! as String
        XCTAssert(txtHandler1.isReverseDomain())
        let httpHandler =
            getDefaultHandler(forUrlScheme: "http" as CFString)! as String
        // dump(httpHandler) // => com.apple.Safari
        XCTAssert(httpHandler.isReverseDomain())
    }

    func testGetHandlerCandidates() throws {
        let txtUti = "public.plain-text" as CFString
        let txtHandlers = getHandlerCandidates(forUti: txtUti)!
        // dump(txtHandlers)  // => com.apple.TextEdit, ..
        XCTAssert(txtHandlers.contains("com.apple.TextEdit" as CFString))
        let txtHandlers1 = getHandlerCandidates(forExt: "txt")!
        // dump(txtHandlers1)
        XCTAssert(txtHandlers1.contains("com.apple.TextEdit" as CFString))
        let httpHandlers = getHandlerCandidates(
            forUrlScheme: "http" as CFString
        )!  // dump(httpHandlers)  // => com.apple.Safari, ..
        XCTAssert(httpHandlers.contains("com.apple.Safari" as CFString))
    }
}
