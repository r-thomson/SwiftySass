import XCTest
@testable import SwiftySass

final class ContextOptionsTests: XCTestCase {
	func testOptionGettersSetters() {
		let context = SassDataContext(sourceString: "")
		
		context.options.precision = 6
		XCTAssertEqual(context.options.precision, 6)
		
		for style in [SassOptions.OutputStyle.nested, .expanded, .compact, .compressed] {
			context.options.outputStyle = style
			XCTAssertEqual(context.options.outputStyle, style)
		}
		
		context.options.sourceComments = true
		XCTAssertEqual(context.options.sourceComments, true)
		
		for style in [SassOptions.SyntaxType.scss, .indented] {
			context.options.syntaxType = style
			XCTAssertEqual(context.options.syntaxType, style)
		}
		
		context.options.indentation = "\t"
		XCTAssertEqual(context.options.indentation, "\t")
		
		context.options.lineFeed = "\n\n"
		XCTAssertEqual(context.options.lineFeed, "\n\n")
	}
	
	func testPrecisionOption() {
		let pi = 3.14159265358979323846
		let scss = """
		body {
			line-height: (\(pi));
		}
		"""
		
		for digits in 1...15 {
			let context = SassDataContext(sourceString: scss)
			context.options.precision = Int32(digits)
			
			let divisor = pow(10.0, Double(digits))
			let rounded = (pi * divisor).rounded() / divisor
			let target = "body {\n  line-height: \(rounded); }\n"
			
			XCTAssertEqual(try! context.compile(), target)
		}
	}
	
	func testOutputStyle() {
		typealias OutputStyle = SassOptions.OutputStyle
		
		let scss = """
		body {
			color: #222;
			p {
				line-height: 1.5;
			}
		}
		"""
		
		let targets: [OutputStyle: String] = [
			.nested: """
			body {
			  color: #222; }
			  body p {
			    line-height: 1.5; }
			
			""",
			.expanded: """
			body {
			  color: #222;
			}
			
			body p {
			  line-height: 1.5;
			}
			
			""",
			.compact: """
			body { color: #222; }
			
			body p { line-height: 1.5; }
			
			""",
			.compressed: """
			body{color:#222}body p{line-height:1.5}
			
			""",
		]
		
		for (style, target) in targets {
			let context = SassDataContext(sourceString: scss)
			context.options.outputStyle = style
			
			XCTAssertEqual(try! context.compile(), target)
		}
	}
	
	func testSyntaxType() {
		typealias SyntaxType = SassOptions.SyntaxType
		
		let target = """
		ul {
		  list-style: none; }
		  ul li {
		    display: inline-block; }
		
		"""
		
		let scss = """
		ul {
			list-style: none;
			li {
				display: inline-block;
			}
		}
		"""
		
		let sass = """
		ul
			list-style: none
			li
				display: inline-block
		"""
		
		let scssContext = SassDataContext(sourceString: scss)
		scssContext.options.syntaxType = .scss
		XCTAssertEqual(try! scssContext.compile(), target)
		
		let indentedContext = SassDataContext(sourceString: sass)
		indentedContext.options.syntaxType = .indented
		XCTAssertEqual(try! indentedContext.compile(), target)
	}
	
	func testIndentation() {
		let scss = """
		.foo {
			color: red;
			.bar {
				color: green;
				.baz {
					color: blue;
				}
			}
		}
		"""
		let context = SassDataContext(sourceString: scss)
		context.options.indentation = "\t"
		
		let target = """
		.foo {
			color: red; }
			.foo .bar {
				color: green; }
				.foo .bar .baz {
					color: blue; }
		
		"""
		XCTAssertEqual(try! context.compile(), target)
	}
	
	func testLineFeed() {
		let scss = """
		.foo { font-weight: bold; }
		.bar { font-style: italic; }
		"""
		let context = SassDataContext(sourceString: scss)
		context.options.lineFeed = "\n\n"
		
		let target = """
		.foo {
		
		  font-weight: bold; }
		
		
		
		.bar {
		
		  font-style: italic; }
		
		
		"""
		XCTAssertEqual(try! context.compile(), target)
	}
}
