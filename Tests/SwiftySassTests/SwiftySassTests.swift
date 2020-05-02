import XCTest
import SwiftySass

final class SwiftySassTests: XCTestCase {
	func testVersionNumbers() {
		XCTAssertEqual(SwiftySass.libSassVersion, "3.6.4")
		XCTAssertEqual(SwiftySass.sassLanguageVersion, "3.5")
	}
	
	func testAccessTestResources() {
		XCTAssert(try TestResources.resourceDirectory.checkResourceIsReachable())
		
		let textFileURL = TestResources.url(forResourceAtPath: "hello.txt")
		let textFileContents = try? String(contentsOf: textFileURL)
		XCTAssertEqual(textFileContents, "Hello.\n")
	}
	
	func testCompileSourceString() {
		let scss = """
		nav {
		  ul {
		    margin: 0;
		    padding: 0;
		    list-style: none;
		  }
		
		  a {
		    text-decoration: none;
		  }
		}
		"""
		
		let targetCSS = """
		nav ul {
		  margin: 0;
		  padding: 0;
		  list-style: none; }

		nav a {
		  text-decoration: none; }
		
		"""
		
		XCTAssertEqual(try compileSass(fromSource: scss), targetCSS)
	}
	
	func testCompilerError() {
		let scss = """
		body {
			color: $red;
		}
		"""
		
		XCTAssertThrowsError(try SwiftySass.compileSass(fromSource: scss)) { error in
			guard let error = error as? SassCompilerError else { return XCTFail() }
			
			XCTAssertEqual(error.description, "Undefined variable: \"$red\".")
			XCTAssertEqual(error.line, 2)
			XCTAssertEqual(error.column, 9)
		}
	}
}
