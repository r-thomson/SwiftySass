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
public func compileSass(fromSource source: String) throws -> String {
	let context = SassDataContext(sourceString: source)
	return try context.compile()
}

/// Compiles the file at URL and returns the compiled output as a String.
/// - Parameter file: Sass source code to compile.
/// - Throws: `SassCompilerError` if there is an error when compiling.
/// - Returns: The compiled CSS as a String.
public func compileSass(fromFile file: URL) throws -> String {
	let context = SassFileContext(inputPath: file.path)
	return try context.compile()
}
