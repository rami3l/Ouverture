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

    func testGetUtiDeclaration() throws {
        let uti = "public.plain-text" as CFString
        // ! Some reported that the key `UTTypeDescription` does not exist on
        // ! their machine running macOS Catalina,
        // ! so I will have to suppress this error...
        let desc = getUtiDescription(forUti: uti) as String?
        desc.map { XCTAssertEqual($0, "text") }
        let parents = getUtiParents(forUti: uti)! as [String]
        XCTAssertEqual(parents, ["public.text"])
        let exts = getUtiExtensions(forUti: uti)! as [String]
        XCTAssertEqual(exts, ["txt", "text"])
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

#if FULL
    extension OuvertureTests {
        func testSetDefaultHandler() throws {
            let preview = "com.apple.Preview" as CFString
            let safari = "com.apple.Safari" as CFString
            // Set the default handler of `.pdf` to Safari.
            XCTAssert(setDefaultHandler(forExt: "pdf", to: safari))
            XCTAssertEqual(safari, getDefaultHandler(forExt: "pdf")!)
            // Set the default handler of `.pdf` to Preview.
            XCTAssert(setDefaultHandler(forExt: "pdf", to: preview))
            XCTAssertEqual(preview, getDefaultHandler(forExt: "pdf")!)
        }
    }
#endif
