import XCTest
@testable import SwiftySass

final class SwiftySassTests: XCTestCase {
	func testVersionNumbers() {
		XCTAssertEqual(SwiftySass.libSassVersion, "3.6.3")
		XCTAssertEqual(SwiftySass.sassLanguageVersion, "3.5")
	}
	
	func testAccessTestResources() {
		XCTAssert(try TestResources.resourceDirectory.checkResourceIsReachable())
		
		let textFileURL = TestResources.url(forResourceAtPath: "hello.txt")
		let textFileContents = try? String(contentsOf: textFileURL)
		XCTAssertEqual(textFileContents, "Hello.\n")
	}
	
	static var allTests = [
		("testVersionNumbers", testVersionNumbers),
		("testAccessTestResources", testAccessTestResources),
	]
}
