import CLibSass

public struct SwiftySass {
	public static var libSassVersion: String {
		return String(cString: libsass_version())
	}
	
	public static var sassLanguageVersion: String {
		return String(cString: libsass_language_version())
	}
}
