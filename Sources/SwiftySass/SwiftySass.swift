import CLibSass

public struct SwiftySass {
	public static var libSassVersion: String {
		return String(cString: libsass_version())
	}
	
	public static var sassLanguageVersion: String {
		return String(cString: libsass_language_version())
	}
	
	public static func render(source: String) throws -> String {
		let context = LibSassDataContext(sourceString: source)
		return try context.compile()
	}
}
