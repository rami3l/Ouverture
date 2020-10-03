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
            paths.contains { $0.contains("/System/Applications/TextEdit.app") }
        )
    }

    func testBestGetBundleUrl() throws {
        let app = "com.apple.TextEdit"
        let path = getBestBundleUrl(from: app as CFString)!.absoluteString!
        XCTAssert(path.contains("TextEdit.app"))
    }

    func testReadInfoFromBundle() throws {
        let app = "Mock/IINA.app"
        let utis = readSupportedFileTypesFromBundle(app)!
        XCTAssert(utis.contains { $0 == "" })
        let exts = readSupportedFileExtensionsFromBundle(app)!
        XCTAssert(exts.contains { $0 == "mkv" })
        let uscs = readSupportedUrlSchemesFromBundle(app)!
        XCTAssert(uscs.contains { $0 == "iina" })
    }
}