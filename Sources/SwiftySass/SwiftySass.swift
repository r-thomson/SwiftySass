import CLibSass
import Foundation

public struct SwiftySass {
	public static var libSassVersion: String {
		return String(cString: libsass_version())
	}
	
	public static var sassLanguageVersion: String {
		return String(cString: libsass_language_version())
	}
	
	public static func compile(source: String) throws -> String {
		let context = LibSassDataContext(sourceString: source)
		return try context.compile()
	}
	
	public static func compile(filePath: String) throws -> String {
		let context = LibSassFileContext(inputPath: filePath)
		return try context.compile()
	}
	
	public static func compile(fileURL: URL) throws -> String {
		let path = fileURL.path
		return try compile(filePath: path)
	}
}
