import CLibSass
import Foundation

/// The current version of the compiled LibSass library
public var libSassVersion: String {
	return String(cString: libsass_version())
}

/// The current version of the Sass language
public var sassLanguageVersion: String {
	return String(cString: libsass_language_version())
}

/// Compiles the given source String and returns the compiled output as a String.
/// - Parameters:
///   - source: Sass source code to compile.
///   - config: Configuration callback.
/// - Throws: `SassCompilerError` if there is an error when compiling.
/// - Returns: The compiled CSS as a String.
public func compileSass(
	fromSource source: String,
	with config: ((inout SassOptions) -> Void)? = nil
) throws -> String {
	let context = SassDataContext(sourceString: source)
	config?(&context.options)
	return try context.compile()
}

/// Compiles the file at URL and returns the compiled output as a String.
/// - Parameters:
///   - source: Sass source file to compile.
///   - config: Configuration callback.
/// - Throws: `SassCompilerError` if there is an error when compiling.
/// - Returns: The compiled CSS as a String.
public func compileSass(
	fromFile file: URL,
	with config: ((inout SassOptions) -> Void)? = nil
) throws -> String {
	assert(file.isFileURL, "URLs passed to \(#function) must be file paths")
	
	let context = SassFileContext(inputPath: file.path)
	config?(&context.options)
	return try context.compile()
}
