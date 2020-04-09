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

public func compileSass(source: String) throws -> String {
	let context = LibSassDataContext(sourceString: source)
	return try context.compile()
}

public func compileSass(filePath: String) throws -> String {
	let context = LibSassFileContext(inputPath: filePath)
	return try context.compile()
}

public func compileSass(fileURL: URL) throws -> String {
	let path = fileURL.path
	return try compileSass(filePath: path)
}
