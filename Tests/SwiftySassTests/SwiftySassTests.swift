import XCTest
@testable import SwiftySass

final class SwiftySassTests: XCTestCase {
	func testVersionNumbers() {
		XCTAssertEqual(SwiftySass.libSassVersion, "3.6.3")
		XCTAssertEqual(SwiftySass.sassLanguageVersion, "3.5")
	}
	
	static var allTests = [
		("testVersionNumbers", testVersionNumbers),
	]
}
