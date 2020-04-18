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
/// - Parameter source: Sass source code to compile.
/// - Throws: `SassCompilerError` if there is an error when compiling.
/// - Returns: The compiled CSS as a String.
public func compileSass(source: String) throws -> String {
	let context = LibSassDataContext(sourceString: source)
	return try context.compile()
}

/// Compiles the file at URL and returns the compiled output as a String.
/// - Parameter fileURL: Sass source code to compile.
/// - Throws: `SassCompilerError` if there is an error when compiling.
/// - Returns: The compiled CSS as a String.
public func compileSass(fileURL: URL) throws -> String {
	let context = LibSassFileContext(inputPath: fileURL.path)
	return try context.compile()
}
