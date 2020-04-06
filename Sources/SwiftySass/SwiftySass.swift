import CLibSass

public struct SwiftySass {
	public static var libSassVersion: String {
		return String(cString: libsass_version())
	}
	
	public static var sassLanguageVersion: String {
		return String(cString: libsass_language_version())
	}
	
	public static func render(source: String) throws -> String {
		let sassContext = sass_make_data_context(sass_copy_c_string(source))
		defer {
			sass_delete_data_context(sassContext)
		}
		
		sass_compile_data_context(sassContext)
		
		guard sass_context_get_error_status(sassContext) == 0 else {
			let message = String(cString: sass_context_get_error_message(sassContext))
			let text = String(cString: sass_context_get_error_text(sassContext))
			let file = String(cString: sass_context_get_error_file(sassContext))
			let line = sass_context_get_error_line(sassContext)
			let column = sass_context_get_error_column(sassContext)
			
			throw SassCompilerError(message: message, issue: text, filename: file, line: line, column: column)
		}
		
		return String(cString: sass_context_get_output_string(sassContext))
	}
}
