//
// https://github.com/atacan
// 16.07.22
	
import XCTest
@testable import Tolp

final class HTMLTests: XCTestCase {
    
    func testPageLanguage() {
        let html = #"<!DOCTYPE html><html lang="en"></html>"#
        let plot = #"HTML(.lang(.english))"#
        assertEqualHTMLContent(html: html, swift: plot)
    }
}
