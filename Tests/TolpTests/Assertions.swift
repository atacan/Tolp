//
// https://github.com/atacan
// 16.07.22
	

import XCTest
import Plot
@testable import Tolp

func assertEqualHTMLContent(html: String, swift: String) throws {
    let swiftConverted = try Converter.shared.convert(html: html)
    XCTAssertEqual(swift.removingWhitespace(), swiftConverted.removingWhitespace())
}
