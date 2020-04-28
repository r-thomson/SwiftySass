import XCTest
@testable import SwiftySass

final class ContextOptionsTests: XCTestCase {
	func testOptionGettersSetters() {
		let context = SassDataContext(sourceString: "")
		
		context.options.precision = 6
		XCTAssertEqual(context.options.precision, 6)
		
		for style in [SassOutputStyle.nested, .expanded, .compact, .compressed] {
			context.options.outputStyle = style
			XCTAssertEqual(context.options.outputStyle, style)
		}
		
		context.options.sourceComments = true
		XCTAssertEqual(context.options.sourceComments, true)
		
		for style in [SassSyntax.scss, .indented] {
			context.options.syntaxType = style
			XCTAssertEqual(context.options.syntaxType, style)
		}
		
		context.options.indentation = "\t"
		XCTAssertEqual(context.options.indentation, "\t")
		
		context.options.lineFeed = "\n\n"
		XCTAssertEqual(context.options.lineFeed, "\n\n")
	}
}
