// import CoreFoundation
// import Foundation
import XCTest

// import class Foundation.Bundle
@testable import Ouverture

extension OuvertureTests {
    func testGetBundleUrlCandidates() throws {
        let app = "com.apple.TextEdit"
        let paths = getBundleUrlCandidates(from: app as CFString)!.map {
            $0.absoluteURL!.path
        }
        XCTAssert(
            paths.contains { $0.contains("/System/Applications/TextEdit.app") }
        )
    }

    func testGetBundleUrl() throws {
        let app = "com.apple.TextEdit"
        let path = getBundleUrl(from: app as CFString)!.absoluteURL!.path
        // dump(path)
        XCTAssert(path.contains("TextEdit.app"))
    }

    func testGetBundleId() throws {
        let app = "com.apple.TextEdit"
        let appPath = "/System/Applications/TextEdit.app"
        XCTAssertEqual(getBundleId(from: appPath), app)
    }

    func testReadInfoFromBundle() throws {
        let app = "Mock/IINA.app"
        let utis = readSupportedFileTypesFromBundle(app)!
        XCTAssert(utis.contains(""))
        let exts = readSupportedFileExtensionsFromBundle(app)!
        XCTAssert(exts.contains("mkv"))
        let uscs = readSupportedUrlSchemesFromBundle(app)!
        XCTAssert(uscs.contains("iina"))
    }
}
